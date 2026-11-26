"""기존 Test를 열지 않고 Validation·외부 진단·승인된 Holdout을 분리 평가함."""
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


# 최종 Holdout은 별도 승인·데이터 지문·선정된 가중치가 있어야 허용함.
def validate_evaluation_request(args):
    split = getattr(args, 'split', 'valid')
    manifest = getattr(args, 'manifest', None)
    if split not in {'valid', 'diagnostic', 'holdout'}:
        raise ValueError('지원하지 않는 평가 목적임')
    if args.model != 'efficientnet' and split != 'valid':
        raise ValueError('외부 진단·Holdout은 EfficientNet만 지원함')
    if split == 'valid':
        if manifest is not None:
            raise ValueError('기존 Validation과 외부 평가 목록을 혼합할 수 없음')
        return {'split': split, 'selection_allowed': True}
    if manifest is None or not manifest.is_file():
        raise ValueError('별도 외부 평가 목록이 없어 실행을 차단함')
    if split == 'diagnostic':
        return {'split': split, 'selection_allowed': False, 'final_performance_claim_allowed': False}
    approval_path = getattr(args, 'holdout_approval', None)
    checkpoint = getattr(args, 'checkpoint', None)
    ledger = getattr(args, 'holdout_ledger', None)
    if (approval_path is None or not approval_path.is_file() or checkpoint is None
            or not checkpoint.is_file() or ledger is None):
        raise ValueError('Holdout 승인 파일·선정된 체크포인트·실행 기록 경로가 필요함')
    approval = json.loads(approval_path.read_text(encoding='utf-8'))
    manifest_hash = digest(manifest)
    if (approval.get('approved') is not True or approval.get('purpose') != 'final_holdout'
            or approval.get('independence_review_complete') is not True
            or approval.get('not_for_model_selection') is not True
            or approval.get('manifest_sha256') != manifest_hash
            or approval.get('checkpoint_sha256') != digest(checkpoint)):
        raise ValueError('Holdout 승인·독립성·모델 지문이 일치하지 않음')
    marker = ledger.resolve() / (manifest_hash + '.json')
    if marker.exists():
        raise ValueError('이미 실행을 시도한 Holdout임. 자동 재평가하지 않음')
    return {'split': split, 'selection_allowed': False, 'manifest_sha256': manifest_hash,
            'checkpoint_sha256': approval['checkpoint_sha256'], 'ledger_marker': str(marker)}


# 외부 이미지 목록의 라벨·출처·그룹·해시와 평가 용도를 검사함.
def external_evaluation_records(args, mapping):
    manifest = args.manifest
    with manifest.open(encoding='utf-8-sig', newline='') as stream:
        rows = list(csv.DictReader(stream))
    if not rows:
        raise ValueError('외부 평가 이미지가 없어 실행을 차단함')
    references = args.dataset / 'manifest.csv'
    known_hashes, known_groups = set(), set()
    if references.is_file():
        with references.open(encoding='utf-8-sig', newline='') as stream:
            for item in csv.DictReader(stream):
                known_hashes.add(item['sha256']); known_groups.add(item['source_group'])
    seen, seen_hashes, records = set(), set(), []
    required = {'path', 'class_name', 'source', 'specimen_group', 'capture_group', 'split',
                'sha256', 'license', 'independence_status', 'previously_diagnosed', 'condition'}
    for row in rows:
        if not required.issubset(row) or any(not row[key] for key in required):
            raise ValueError('외부 평가에 필요한 라벨·출처·그룹 정보가 없음')
        path = Path(row['path'])
        path = (path if path.is_absolute() else manifest.parent / path).resolve()
        if row['class_name'] not in mapping or row['split'] != args.split:
            raise ValueError('외부 평가 라벨 또는 분할이 현재 요청과 다름')
        if path in seen or any(part.lower() in {'test', 'train'} for part in path.parts):
            raise ValueError('기존 Train·Test 경로 또는 중복된 외부 이미지임')
        if path.is_relative_to(args.dataset.resolve()):
            raise ValueError('기존 데이터셋을 외부 평가로 다시 지정할 수 없음')
        if row['sha256'] in seen_hashes:
            raise ValueError('동일 파일을 여러 외부 평가 표본으로 중복 집계할 수 없음')
        seen.add(path); seen_hashes.add(row['sha256'])
        if args.split == 'holdout':
            if (row['independence_status'] != 'CONFIRMED' or row['previously_diagnosed'].lower() != 'false'
                    or row['sha256'] in known_hashes or row['specimen_group'] in known_groups
                    or row['capture_group'] in known_groups or row['source'].lower().startswith('fruitlife')):
                raise ValueError('독립 Holdout으로 승인되지 않은 사진·촬영 그룹임')
        if (not path.is_file() or len(row['sha256']) != 64 or digest(path) != row['sha256']):
            raise ValueError('외부 평가 파일이 없거나 원본 해시가 다름')
        records.append(dict(row, path=str(path)))
    return records


# 기존 분류 표본을 원본 촬영 그룹과 연결하며 이미지는 추가로 열지 않음.
def internal_classification_metadata(dataset):
    metadata = {}
    manifest = dataset / 'manifest.csv'
    if manifest.is_file():
        with manifest.open(encoding='utf-8-sig', newline='') as stream:
            source_rows = list(csv.DictReader(stream))
        for row in source_rows:
            path = (dataset / row['path']).resolve()
            metadata[str(path)] = {'source': row['source'], 'specimen_group': row['source_group'],
                                   'capture_group': row['source_group'], 'condition': 'UNSPECIFIED'}
    elif (dataset / 'crops.csv').is_file():
        with (dataset / 'crops.csv').open(encoding='utf-8-sig', newline='') as stream:
            source_rows = list(csv.DictReader(stream))
        for row in source_rows:
            path = (dataset / 'efficientnet' / row['crop']).resolve()
            metadata[str(path)] = {'source': dataset.name, 'specimen_group': row['source_image'],
                                   'capture_group': row['source_image'], 'condition': 'UNSPECIFIED'}
    return metadata


# 동일한 EXIF·RGB 로더로 외부 진단 표본을 읽음.
def external_classification_dataset(records, mapping, transform):
    from torch.utils.data import Dataset
    from train import classification_image_loader

    class EvaluationDataset(Dataset):
        # 모델의 고정 인덱스와 원본 경로를 보존함.
        def __init__(self):
            self.classes = sorted(mapping, key=mapping.get)
            self.samples = [(row['path'], mapping[row['class_name']]) for row in records]
            self.targets = [target for _, target in self.samples]

        # 외부 평가 이미지 수를 반환함.
        def __len__(self):
            return len(self.samples)

        # 원본 변경 없이 방향을 보정하고 평가 변환만 적용함.
        def __getitem__(self, index):
            path, target = self.samples[index]
            image = classification_image_loader(path)
            return transform(image), target

    return EvaluationDataset()


# 출처·실물·촬영 그룹·외관 상태별 성능과 표본 수를 분리함.
def classification_slices(rows, names):
    from train import classification_metrics
    mapping = {name: index for index, name in enumerate(names)}
    result = {}
    for key in ('source', 'specimen_group', 'capture_group', 'condition'):
        groups = {}
        for row in rows:
            groups.setdefault(row[key], []).append(row)
        result[key] = {}
        for group, items in groups.items():
            metrics = classification_metrics([mapping[r['actual']] for r in items],
                [mapping[r['predicted']] for r in items],
                [[mapping[name] for name in json.loads(r['top3'])] for r in items], len(names))
            result[key][group] = dict(metrics, specimen_groups=len({r['specimen_group'] for r in items}),
                                      capture_groups=len({r['capture_group'] for r in items}))
    return result


# 목적별 분류 평가와 클래스·출처·그룹별 오류 분석을 저장함.
def efficientnet(args, root, weight):
    import torch
    import timm
    import numpy as np
    from sklearn.metrics import confusion_matrix
    from train import classifier_mapping, classification_metrics, mapped_imagefolder

    state = torch.load(weight, map_location='cpu', weights_only=False, pickle_module=CompatiblePickle)
    mapping = json.loads((args.dataset/'class_indices.json').read_text(encoding='utf-8'))
    if state['class_indices'] != mapping:
        raise ValueError('클래스 매핑 불일치')
    indices = classifier_mapping(args.dataset)
    names = sorted(indices, key=indices.get)
    class_count = len(names)
    model = timm.create_model('efficientnet_b0.ra_in1k', pretrained=False, num_classes=class_count)
    model.load_state_dict(state['model'], strict=True)
    model.eval()
    transform = timm.data.create_transform(**timm.data.resolve_model_data_config(model), is_training=False)
    split = getattr(args, 'split', 'valid')
    if split == 'valid':
        dataset = mapped_imagefolder(args.dataset/'efficientnet/valid', indices, transform)
        metadata = internal_classification_metadata(args.dataset)
    else:
        records = external_evaluation_records(args, indices)
        dataset = external_classification_dataset(records, indices, transform)
        metadata = {str(Path(r['path']).resolve()): r for r in records}
    if not len(dataset):
        raise ValueError('평가할 이미지가 없음')
    loader = torch.utils.data.DataLoader(dataset, batch_size=16, shuffle=False, num_workers=0)
    rows, actual, predicted, candidates = [], [], [], []
    with torch.inference_mode():
        for images, labels in loader:
            probabilities = model(images).softmax(1)
            top = probabilities.topk(3, dim=1)
            for index, target in enumerate(labels.tolist()):
                prediction = int(top.indices[index, 0])
                path = str(Path(dataset.samples[len(rows)][0]).resolve())
                info = metadata.get(path, {'source': 'METADATA_MISSING', 'specimen_group': path,
                                           'capture_group': path, 'condition': 'UNSPECIFIED'})
                ranked = top.indices[index].tolist()
                rows.append({'image': path, 'actual': names[target], 'predicted': names[prediction],
                             'probability': float(top.values[index, 0]),
                             'actual_probability': float(probabilities[index, target]),
                             'top3': json.dumps([names[i] for i in ranked]),
                             **{key: info[key] for key in ('source','specimen_group','capture_group','condition')}})
                actual.append(target); predicted.append(prediction); candidates.append(ranked)
            print('classified', len(rows), flush=True)
    metrics = classification_metrics(actual, predicted, candidates, class_count)
    classes = []
    for i, name in enumerate(names):
        support = metrics['per_class_support'][i]
        classes.append({'class': name, 'precision': metrics['per_class_precision'][i],
                        'recall': metrics['per_class_recall'][i],
                        'f1-score': metrics['per_class_f1'][i] if support else None,
                        'support': support, 'evaluation_status': 'MEASURED' if support else 'NOT_MEASURED'})
    table(root/'classes.csv', classes)
    table(root/'predictions.csv', rows)
    errors = [row for row in rows if row['actual'] != row['predicted']]
    table(root/'errors.csv', errors)
    matrix_output(root, confusion_matrix(actual, predicted, labels=list(range(class_count))), names)
    (root/'group_metrics.json').write_text(json.dumps(classification_slices(rows, names), indent=2), encoding='utf-8')
    missing = [name for i,name in enumerate(names) if not metrics['per_class_support'][i]]
    supported_f1 = [metrics['per_class_f1'][i] for i in range(class_count) if metrics['per_class_support'][i]]
    return dict(metrics, class_count=class_count, validation_missing_classes=missing,
                missing_new_validation_classes=[name for name in missing if indices[name] >= 51],
                macro_f1_all_outputs_zero_fill=metrics['macro_f1'],
                macro_f1=float(np.mean(supported_f1)), samples=len(rows), errors=len(errors),
                split=split, selection_allowed=split=='valid', final_holdout_result=split=='holdout',
                independence_status=('CONDITIONAL_DIAGNOSTIC' if split=='diagnostic' else
                                     'USER_REVIEWED_HOLDOUT' if split=='holdout' else 'EXISTING_VALIDATION'),
                service_replacement_allowed=False)


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


# 평가 목적과 Holdout 승인을 먼저 검사하고 입력 가중치 해시를 재확인함.
def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--model',choices=['efficientnet','yolo'],required=True)
    parser.add_argument('--dataset',type=Path,required=True)
    source = parser.add_mutually_exclusive_group(required=True)
    source.add_argument('--results',type=Path)
    source.add_argument('--checkpoint',type=Path)
    parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--split', choices=['valid','diagnostic','holdout'], default='valid')
    parser.add_argument('--manifest', type=Path)
    parser.add_argument('--holdout-approval', type=Path)
    parser.add_argument('--holdout-ledger', type=Path)
    args=parser.parse_args()
    request = validate_evaluation_request(args)
    if args.split != 'valid':
        from train import classifier_mapping
        external_evaluation_records(args, classifier_mapping(args.dataset))
    root=args.output.resolve()/args.model
    repository = Path(__file__).resolve().parents[2]
    if (root.is_relative_to(args.dataset.resolve()) or root.is_relative_to(repository) or root.exists()
            or (args.checkpoint is not None and root.is_relative_to(args.checkpoint.resolve().parent))):
        raise ValueError('기존 데이터·결과 경로는 수정하지 않음')
    root.mkdir(parents=True)
    runtime=root/'runtime'; (runtime/'ultralytics'/'Ultralytics').mkdir(parents=True)
    os.environ.update(YOLO_CONFIG_DIR=str(runtime/'ultralytics'), YOLO_OFFLINE='true',
                      YOLO_AUTOINSTALL='false',MPLCONFIGDIR=str(runtime/'matplotlib'), MPLBACKEND='Agg')
    import torch
    torch.set_num_threads(4)
    if args.checkpoint is not None:
        if args.model != 'efficientnet': raise ValueError('직접 체크포인트 평가는 분류만 지원함')
        weight, original=args.checkpoint.resolve(), digest(args.checkpoint)
    else:
        weight, original=weight_file(args,root)
    if args.split == 'holdout':
        marker = Path(request['ledger_marker'])
        if (marker.is_relative_to(args.dataset.resolve()) or marker.is_relative_to(repository)
                or marker.is_relative_to(args.checkpoint.resolve().parent)):
            raise ValueError('Holdout 실행 기록은 저장소·데이터 외부에 보존해야 함')
        marker.parent.mkdir(parents=True, exist_ok=True)
        with marker.open('x', encoding='utf-8') as stream:
            json.dump(dict(request, status='ATTEMPT_RESERVED_NOT_FOR_MODEL_SELECTION'), stream, indent=2)
    result=efficientnet(args,root,weight) if args.model=='efficientnet' else yolo(args,root,weight)
    if digest(weight)!=original: raise ValueError('가중치 해시 변경')
    result.update(split=args.split, test_accessed=False, weight_sha256=original, weight_unchanged=True,
                  selection_allowed=args.split=='valid', holdout_used_for_selection=False)
    (root/'summary.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
    print(json.dumps(result),flush=True)


if __name__=='__main__':
    main()
