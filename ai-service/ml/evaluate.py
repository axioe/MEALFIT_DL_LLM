"""기존 best 가중치로 valid만 평가함. test 경로는 열지 않음."""
import argparse
import csv
import hashlib
import io
import json
import os
import pickle
import shutil
from pathlib import Path, PurePosixPath
from zipfile import ZipFile


# Python 3.13의 경로 메타데이터만 플랫폼 독립 경로로 복원함.
class CompatibleUnpickler(pickle.Unpickler):
    # 가중치 텐서는 그대로 두고 PosixPath 메타데이터만 호환 처리함.
    def find_class(self, module, name):
        if module in ('pathlib', 'pathlib._local') and name == 'PosixPath':
            return PurePosixPath
        return super().find_class(module, name)


class CompatiblePickle:
    Unpickler = CompatibleUnpickler
    load = pickle.load
    loads = pickle.loads


# 파일의 원본 유지 여부를 확인함.
def digest(path):
    with Path(path).open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


# 분석 표를 UTF-8 CSV로 저장함.
def table(path, rows):
    if not rows:
        return
    with Path(path).open('w', encoding='utf-8-sig', newline='') as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)


# 행은 정답·열은 예측인 혼동행렬을 표와 그림으로 저장함.
def matrix_output(root, matrix, names):
    import matplotlib
    matplotlib.use('Agg')
    import matplotlib.pyplot as plt
    table(root/'confusion_matrix.csv', [dict(actual=name, **dict(zip(names, map(int, row))))
                                        for name, row in zip(names, matrix)])
    fig, ax = plt.subplots(figsize=(18, 16))
    ax.imshow(matrix, cmap='Blues')
    ax.set_xticks(range(len(names)), names, rotation=90, fontsize=6)
    ax.set_yticks(range(len(names)), names, fontsize=6)
    ax.set_xlabel('Predicted'); ax.set_ylabel('Actual')
    fig.tight_layout(); fig.savefig(root/'confusion_matrix.png', dpi=150); plt.close(fig)


# 검증한 결과 ZIP에서 해당 모델 best만 별도 분석 폴더에 복사함.
def weight_file(args, root):
    member = ('runs/baseline_01/efficientnet/best.pt' if args.model == 'efficientnet'
              else 'runs/baseline_01/yolo/train/weights/best.pt')
    with ZipFile(args.results) as archive:
        manifest = json.loads(archive.read('result_manifest.json'))
        expected = next(row['sha256'] for row in manifest if row['path'] == member)
        data = archive.read(member)
        if hashlib.sha256(data).hexdigest() != expected:
            raise ValueError('가중치 해시 불일치')
    path = root/'best.pt'
    path.write_bytes(data)
    return path, expected


# 분류 valid의 전체 예측·클래스 지표·오분류를 저장함.
def efficientnet(args, root, weight):
    import torch
    import timm
    import numpy as np
    from torchvision.datasets import ImageFolder
    from sklearn.metrics import classification_report, confusion_matrix
    state = torch.load(weight, map_location='cpu', weights_only=False, pickle_module=CompatiblePickle)
    mapping = json.loads((args.dataset/'class_indices.json').read_text(encoding='utf-8'))
    if state['class_indices'] != mapping:
        raise ValueError('클래스 매핑 불일치')
    model = timm.create_model('efficientnet_b0.ra_in1k', pretrained=False, num_classes=51)
    model.load_state_dict(state['model'], strict=True)
    model.eval()
    transform = timm.data.create_transform(**timm.data.resolve_model_data_config(model), is_training=False)
    dataset = ImageFolder(args.dataset/'efficientnet/valid', transform)
    if dataset.class_to_idx != mapping['efficientnet_imagefolder']:
        raise ValueError('valid 폴더 매핑 불일치')
    loader = torch.utils.data.DataLoader(dataset, batch_size=16, shuffle=False, num_workers=0)
    rows, actual, predicted = [], [], []
    with torch.inference_mode():
        for images, labels in loader:
            probabilities = model(images).softmax(1)
            top = probabilities.topk(3, dim=1)
            for index, target in enumerate(labels.tolist()):
                prediction = int(top.indices[index, 0])
                rows.append({'image': dataset.samples[len(rows)][0], 'actual': dataset.classes[target],
                             'predicted': dataset.classes[prediction], 'probability': float(top.values[index, 0]),
                             'actual_probability': float(probabilities[index, target]),
                             'top3': json.dumps([dataset.classes[int(i)] for i in top.indices[index]])})
                actual.append(target); predicted.append(prediction)
            print('classified', len(rows), flush=True)
    report = classification_report(actual, predicted, labels=list(range(51)),
                                   target_names=dataset.classes, output_dict=True, zero_division=0)
    table(root/'classes.csv', [{'class': name, **report[name]} for name in dataset.classes])
    table(root/'predictions.csv', rows)
    errors = [row for row in rows if row['actual'] != row['predicted']]
    table(root/'errors.csv', errors)
    matrix_output(root, confusion_matrix(actual, predicted, labels=list(range(51))), dataset.classes)
    return {'samples': len(rows), 'errors': len(errors), 'top1': float(np.mean(np.array(actual)==predicted)),
            'macro_f1': report['macro avg']['f1-score']}


# 위치가 겹친 객체를 먼저 연결해 클래스 혼동과 순수 미탐·오탐을 구분함.
def match_objects(gt, predictions, threshold=0.5):
    import numpy as np
    candidates = []
    for g, target in enumerate(gt):
        a = np.array(target['box'])
        for p, prediction in enumerate(predictions):
            b = np.array(prediction['box'])
            overlap = np.maximum(0, np.minimum(a[2:], b[2:])-np.maximum(a[:2], b[:2])).prod()
            union = (a[2:]-a[:2]).prod()+(b[2:]-b[:2]).prod()-overlap
            iou = overlap/union if union else 0
            if iou >= threshold:
                candidates.append((float(iou), g, p))
    matched, used_g, used_p = [], set(), set()
    for iou, g, p in sorted(candidates, reverse=True):
        if g not in used_g and p not in used_p:
            matched.append((g, p, iou)); used_g.add(g); used_p.add(p)
    return matched, [g for g in range(len(gt)) if g not in used_g], [p for p in range(len(predictions)) if p not in used_p]


# YOLO 공식 AP 평가와 고정 임계값 오류 분석을 한 번의 valid 추론으로 수행함.
def yolo(args, root, weight):
    import numpy as np
    from ultralytics import YOLO
    from ultralytics.models.yolo.detect.val import DetectionValidator
    from ultralytics.utils import ops
    names = list(json.loads((args.dataset/'class_indices.json').read_text(encoding='utf-8'))['yolo'])
    view = root/'validation_view'
    for kind in ('images', 'labels'):
        destination = view/'valid'/kind
        destination.mkdir(parents=True)
        for source in (args.dataset/'yolo/valid'/kind).iterdir():
            if source.is_file():
                shutil.copyfile(source, destination/source.name)
    data = {'path': str(view), 'train': 'valid/images', 'val': 'valid/images', 'nc':51, 'names':names}
    # SDK 캐시는 복사본에만 생성되며 원래 train·valid·test 분할은 변경하지 않음.
    config = root/'validation_only.yaml'
    config.write_text(json.dumps(data), encoding='utf-8')
    records = []

    class AuditValidator(DetectionValidator):
        # 공식 지표를 유지하면서 원본 좌표의 정답과 예측을 기록함.
        def update_metrics(self, preds, batch):
            for index, prediction in enumerate(preds):
                target = self._prepare_batch(index, batch)
                boxes = ops.scale_boxes(target['imgsz'], target['bboxes'].clone(), target['ori_shape'], ratio_pad=target['ratio_pad'])
                scaled = self.scale_preds(prediction, target)
                records.append({'image': target['im_file'],
                    'gt': [{'class': int(c), 'box': box} for c, box in zip(target['cls'].tolist(), boxes.tolist())],
                    'predictions': [{'class': int(c), 'box': box, 'confidence': float(conf)}
                        for c, box, conf in zip(scaled['cls'].tolist(), scaled['bboxes'].tolist(), scaled['conf'].tolist())]})
            super().update_metrics(preds, batch)

    model = YOLO(str(weight))
    if list(model.names.values()) != names:
        raise ValueError('탐지 클래스 매핑 불일치')
    metrics = model.val(validator=AuditValidator, data=str(config), split='val', device='cpu',
                        imgsz=640, batch=4, workers=0, conf=0.001, iou=0.7,
                        plots=False, save_json=False, save_txt=False, project=str(root), name='native', verbose=False)
    table(root/'classes.csv', metrics.summary(decimals=8))
    matrix = np.zeros((52,52), dtype=int)
    events, images = [], []
    for record in records:
        gt = record['gt']; predictions = [p for p in record['predictions'] if p['confidence'] >= .25]
        matches, missing, extra = match_objects(gt, predictions)
        errors = []
        for g,p,iou in matches:
            a,b = gt[g]['class'], predictions[p]['class']; matrix[a,b]+=1
            if a != b:
                errors.append({'type':'class_confusion','actual':names[a],'predicted':names[b],
                               'confidence':predictions[p]['confidence'],'iou':iou})
        for g in missing:
            a=gt[g]['class']; matrix[a,51]+=1
            errors.append({'type':'miss','actual':names[a],'predicted':'background','confidence':0,'iou':0})
        for p in extra:
            b=predictions[p]['class']; matrix[51,b]+=1
            errors.append({'type':'false_positive','actual':'background','predicted':names[b],
                           'confidence':predictions[p]['confidence'],'iou':0})
        multi = len({g['class'] for g in gt})>1
        for error in errors:
            events.append({'image':record['image'],'multi_class':multi,**error})
        images.append({'image':record['image'],'gt_objects':len(gt),'predictions':len(predictions),
                       'multi_class':multi,'confusions':sum(e['type']=='class_confusion' for e in errors),
                       'misses':len(missing),'false_positives':len(extra)})
    table(root/'errors.csv', events); table(root/'images.csv', images)
    with (root/'detections.jsonl').open('w',encoding='utf-8') as stream:
        for record in records: stream.write(json.dumps(record)+'\n')
    matrix_output(root,matrix,names+['background'])
    return {'samples':len(records),'map50':float(metrics.box.map50),'map50_95':float(metrics.box.map),
            'precision':float(metrics.box.mp),'recall':float(metrics.box.mr),
            'error_confidence':.25,'error_match_iou':.5,'multi_class_images':sum(r['multi_class'] for r in images)}


# 모델별 valid 평가만 실행하고 입력 가중치 해시를 재확인함.
def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--model',choices=['efficientnet','yolo'],required=True)
    parser.add_argument('--dataset',type=Path,required=True)
    parser.add_argument('--results',type=Path,required=True)
    parser.add_argument('--output',type=Path,required=True)
    args=parser.parse_args()
    root=args.output.resolve()/args.model
    if root.is_relative_to(args.dataset.resolve()) or root.exists():
        raise ValueError('기존 데이터·결과 경로는 수정하지 않음')
    root.mkdir(parents=True)
    runtime=root/'runtime'; (runtime/'ultralytics'/'Ultralytics').mkdir(parents=True)
    os.environ.update(YOLO_CONFIG_DIR=str(runtime/'ultralytics'), YOLO_OFFLINE='true',
                      YOLO_AUTOINSTALL='false',MPLCONFIGDIR=str(runtime/'matplotlib'), MPLBACKEND='Agg')
    import torch
    torch.set_num_threads(4)
    weight, original=weight_file(args,root)
    result=efficientnet(args,root,weight) if args.model=='efficientnet' else yolo(args,root,weight)
    if digest(weight)!=original: raise ValueError('가중치 해시 변경')
    result.update(split='valid',test_accessed=False,weight_sha256=original,weight_unchanged=True)
    (root/'summary.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
    print(json.dumps(result),flush=True)


if __name__=='__main__':
    main()
