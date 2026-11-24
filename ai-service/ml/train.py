"""기존 CPU 점검과 명시적으로 호출하는 Colab GPU 학습을 제공함."""

import argparse
import csv
import gc
import hashlib
import importlib.metadata
import json
import math
import os
import platform
import random
import statistics
import time
from pathlib import Path

from config import MAX_APPROVED_BATCHES, SmokeConfig, GpuConfig


# 모델 원본과 데이터 파일의 해시를 읽음.
def file_hash(path):
    with Path(path).open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


# 자동 설치·외부 통신과 공용 사용자 설정 저장을 막음.
def isolate_runtime(config):
    runtime = config.output / 'runtime'
    runtime.mkdir(parents=True, exist_ok=True)
    # SDK가 작업 폴더로 대체 저장하지 않도록 부모 경로를 먼저 만듦.
    (runtime / 'ultralytics').mkdir(exist_ok=True)
    settings = {'YOLO_CONFIG_DIR': str(runtime / 'ultralytics'), 'YOLO_AUTOINSTALL': 'false',
                'YOLO_OFFLINE': 'true', 'MPLCONFIGDIR': str(runtime / 'matplotlib'),
                'HF_HUB_OFFLINE': '1', 'HF_HOME': str(runtime / 'huggingface'),
                'TORCH_HOME': str(runtime / 'torch'), 'OMP_NUM_THREADS': str(config.threads),
                'MKL_NUM_THREADS': str(config.threads)}
    os.environ.update(settings)


# 재실행해도 모델당 실제 데이터 점검이 총 5배치를 넘지 않도록 예약함.
def reserve_batch(config):
    path = config.output / f'{config.model}_batch_budget.json'
    state = json.loads(path.read_text(encoding='utf-8')) if path.exists() else {'attempted_batches': 0}
    if state['attempted_batches'] >= MAX_APPROVED_BATCHES:
        raise RuntimeError('해당 모델의 승인된 총 5배치를 이미 사용함')
    state['attempted_batches'] += 1
    path.write_text(json.dumps(state, indent=2), encoding='utf-8')
    return state['attempted_batches']


# 고정 시드로 train 표본만 선택함.
def choose_indices(count, sample_count, seed):
    if count < sample_count:
        raise ValueError('요청한 점검 배치보다 train 표본이 적음')
    return random.Random(seed).sample(range(count), sample_count)


# 실제 속도 측정치를 학습 연산 시간으로만 단순 외삽함.
def estimate_epoch(batch_seconds, samples, batch_size):
    if not batch_seconds or samples <= 0 or batch_size <= 0:
        raise ValueError('속도 외삽 입력이 유효하지 않음')
    mean_seconds = statistics.mean(batch_seconds)
    return {'train_samples': samples, 'batches_per_epoch': math.ceil(samples / batch_size),
            'steady_batch_mean_seconds': mean_seconds,
            'train_compute_seconds_per_epoch': mean_seconds * math.ceil(samples / batch_size),
            'includes_validation_or_checkpointing': False}


# 설치된 실제 패키지 버전을 외부 결과 폴더에 기록함.
def environment_record(config):
    versions = {distribution.metadata['Name']: distribution.version for distribution in importlib.metadata.distributions()}
    result = {'python': platform.python_version(), 'executable': os.sys.executable,
              'platform': platform.platform(), 'processor': platform.processor(),
              'packages': dict(sorted(versions.items()))}
    (config.output / 'environment.json').write_text(json.dumps(result, indent=2), encoding='utf-8')
    (config.output / 'installed_versions.txt').write_text(
        '\n'.join(f'{name}=={version}' for name, version in sorted(versions.items()))+'\n', encoding='utf-8')
    return result


# 로컬 사전학습 가중치로 51개 클래스 EfficientNet을 준비함.
def build_efficientnet(config, class_count):
    import timm
    from timm.models import load_checkpoint

    model = timm.create_model('efficientnet_b0.ra_in1k', pretrained=False)
    load_checkpoint(model, str(config.weight_path()), strict=True)
    model.reset_classifier(class_count)
    return model


# 로컬 YOLOv8n 가중치를 51개 클래스 탐지 구조에 전이함.
def build_yolo(config, class_count):
    from ultralytics import YOLO, settings
    from ultralytics.cfg import get_cfg
    from ultralytics.nn.tasks import DetectionModel

    settings.update({'sync': False, 'tensorboard': False, 'wandb': False, 'mlflow': False,
                     'clearml': False, 'comet': False, 'hub': False,
                     'datasets_dir': str(config.dataset / 'yolo'),
                     'weights_dir': str(config.weights), 'runs_dir': str(config.output)})
    pretrained = YOLO(str(config.weight_path()), task='detect', verbose=False).model
    model = DetectionModel(cfg=pretrained.yaml, ch=3, nc=class_count, verbose=False)
    model.load(pretrained, verbose=False)
    model.args = get_cfg()
    return model


# ImageFolder의 실제 클래스 순서와 train 전용 로더를 준비함.
def classification_loader(config, batches, model):
    import torch
    import timm
    from torchvision.datasets import ImageFolder

    batch_size, _ = config.dimensions()
    transform = timm.data.create_transform(**timm.data.resolve_model_data_config(model), is_training=True)
    dataset = ImageFolder(config.dataset / 'efficientnet/train', transform=transform)
    indices = json.loads((config.dataset / 'class_indices.json').read_text(encoding='utf-8'))['efficientnet_imagefolder']
    if dataset.class_to_idx != indices:
        raise ValueError('분류 폴더의 클래스 인덱스가 승인된 매핑과 다름')
    counts = [0] * len(indices)
    for _, target in dataset.samples:
        counts[target] += 1
    # 분포를 재표집하지 않고 손실 가중치만 역제곱근으로 완화함.
    weights = torch.tensor([1 / math.sqrt(count) for count in counts], dtype=torch.float32)
    weights /= weights.mean()
    selected = choose_indices(len(dataset), batches * batch_size, config.seed)
    loader = torch.utils.data.DataLoader(torch.utils.data.Subset(dataset, selected),
                                       batch_size=batch_size, shuffle=False, num_workers=0)
    return loader, len(dataset), torch.nn.CrossEntropyLoss(weight=weights)


class DetectionSmokeDataset:
    # test·valid 이미지를 읽지 않도록 train 파일 목록만 준비함.
    def __init__(self, config, batches, class_count):
        batch_size, self.image_size = config.dimensions()
        self.root, self.class_count = config.dataset, class_count
        with (self.root / 'images.csv').open(encoding='utf-8-sig', newline='') as stream:
            samples = [row['image'] for row in csv.DictReader(stream) if row['split'] == 'train']
        self.full_count = len(samples)
        self.samples = [samples[index] for index in choose_indices(len(samples), batches * batch_size, config.seed)]

    # 선택한 train 이미지 개수를 반환함.
    def __len__(self):
        return len(self.samples)

    # 이미지와 정규화된 실제 객체 라벨을 점검용 텐서로 읽음.
    def __getitem__(self, index):
        import numpy as np
        import torch
        from PIL import Image
        from prepare_data import parse_annotation, detection_values

        name = self.samples[index]
        with Image.open(self.root / 'yolo' / name) as image:
            pixels = np.asarray(image.convert('RGB').resize((self.image_size, self.image_size))).copy()
        tensor = torch.from_numpy(pixels).permute(2, 0, 1).float().div_(255)
        path = (self.root / 'yolo' / name.replace('/images/', '/labels/')).with_suffix('.txt')
        rows = []
        for line in path.read_text(encoding='utf-8').splitlines():
            annotation = parse_annotation(line, self.class_count)
            if annotation is not None:
                rows.append(detection_values(annotation, annotation['class_id']))
        return tensor, torch.tensor(rows, dtype=torch.float32).reshape(-1, 5)


# 여러 이미지의 객체를 YOLO 손실 함수 입력으로 묶음.
def detection_collate(batch):
    import torch

    images, labels = zip(*batch)
    targets = torch.cat(labels, dim=0)
    batch_indices = torch.cat([torch.full((len(rows),), index, dtype=torch.float32)
                               for index, rows in enumerate(labels)])
    return {'img': torch.stack(images), 'batch_idx': batch_indices,
            'cls': targets[:, :1], 'bboxes': targets[:, 1:]}


# 승인된 배치만 순전파·역전파·메모리 점검하고 가중치는 저장하지 않음.
def run_smoke(config):
    config.validate()
    config.output.mkdir(parents=True, exist_ok=True)
    isolate_runtime(config)
    import numpy as np
    import psutil
    import torch

    if not config.weight_path().is_file():
        raise ValueError('승인 후 내려받은 로컬 사전학습 파일이 필요함')
    budget_path = config.output / f'{config.model}_batch_budget.json'
    used = json.loads(budget_path.read_text(encoding='utf-8'))['attempted_batches'] if budget_path.exists() else 0
    batches = min(config.batches, MAX_APPROVED_BATCHES - used)
    if batches <= 0:
        raise RuntimeError('총 5배치 점검을 이미 완료함. 추가 실행 승인이 필요함')
    if psutil.virtual_memory().available < 3 * 1024**3:
        raise RuntimeError('사용 가능한 RAM이 3GiB 미만이라 점검을 시작하지 않음')
    random.seed(config.seed)
    np.random.seed(config.seed)
    torch.manual_seed(config.seed)
    torch.set_num_threads(config.threads)
    torch.set_num_interop_threads(1)
    torch.use_deterministic_algorithms(True)
    before_weight = file_hash(config.weight_path())
    validation_path = config.dataset / 'validation_report.json'
    dataset_fingerprint = file_hash(validation_path)
    validation = json.loads(validation_path.read_text(encoding='utf-8'))
    if any(validation[key] for key in ['cross_split_image_hash_groups', 'cross_split_source_groups',
                                      'cross_split_crop_hash_groups']):
        raise ValueError('분할 누수 검증을 통과하지 않은 데이터임')
    class_count = validation['class_count']
    setup_started = time.perf_counter()
    if config.model == 'efficientnet':
        model = build_efficientnet(config, class_count)
        loader, full_count, criterion = classification_loader(config, batches, model)
    else:
        model = build_yolo(config, class_count)
        dataset = DetectionSmokeDataset(config, batches, class_count)
        loader = torch.utils.data.DataLoader(dataset, batch_size=config.dimensions()[0],
                                           shuffle=False, num_workers=0, collate_fn=detection_collate)
        full_count, criterion = dataset.full_count, None
    torch.set_num_threads(config.threads)
    model.to('cpu').train()
    optimizer = torch.optim.AdamW(model.parameters(), lr=1e-3, weight_decay=1e-4)
    setup_seconds = time.perf_counter() - setup_started
    process = psutil.Process()
    measurements, error = [], None
    iterator = iter(loader)
    for _ in range(batches):
        load_started = time.perf_counter()
        batch = next(iterator)
        load_seconds = time.perf_counter() - load_started
        budget_number = reserve_batch(config)
        started = time.perf_counter()
        try:
            optimizer.zero_grad(set_to_none=True)
            if config.model == 'efficientnet':
                inputs, targets = batch
                loss = criterion(model(inputs), targets)
            else:
                loss = model(batch)[0].sum()
            if not torch.isfinite(loss).item():
                raise RuntimeError('유한하지 않은 손실이 발생함')
            loss.backward()
            optimizer.step()
            seconds = time.perf_counter() - started
            memory = process.memory_info()._asdict()
            measurement = {'budget_batch': budget_number, 'step_seconds': seconds,
                           'load_seconds': load_seconds, 'loss': float(loss.detach()),
                           'rss_mib': memory['rss'] / 1024**2,
                           'process_peak_mib': memory.get('peak_wset', memory['rss']) / 1024**2}
            measurements.append(measurement)
            print(json.dumps(measurement), flush=True)
        except Exception as exception:
            error = {'type': type(exception).__name__, 'message': str(exception), 'budget_batch': budget_number}
            break
    weights_unchanged = file_hash(config.weight_path()) == before_weight
    data_unchanged = file_hash(validation_path) == dataset_fingerprint
    steady = measurements[1:] if len(measurements) > 1 else measurements
    result = {'model': config.model, 'seed': config.seed, 'device': 'cpu', 'threads': config.threads,
              'batch_size': config.dimensions()[0], 'input_size': config.dimensions()[1],
              'optimizer': 'AdamW', 'learning_rate': 1e-3, 'setup_seconds': setup_seconds,
              'completed_batches_this_run': len(measurements), 'measurements': measurements,
              'weights_unchanged': weights_unchanged, 'data_validation_unchanged': data_unchanged,
              'formal_training_completed': False, 'test_evaluated': False, 'checkpoint_saved': False,
              'error': error, 'classifier_imbalance_policy': 'inverse_sqrt_loss_weights' if criterion else None}
    if steady:
        result['epoch_estimate'] = estimate_epoch([row['step_seconds']+row['load_seconds'] for row in steady],
                                                full_count, config.dimensions()[0])
        result['peak_process_mib'] = max(row['process_peak_mib'] for row in measurements)
    environment_record(config)
    output_path = config.output / f'{config.model}_smoke_attempt_{used}.json'
    if output_path.exists():
        raise RuntimeError('기존 점검 결과를 덮어쓰지 않음')
    output_path.write_text(json.dumps(result, indent=2), encoding='utf-8')
    del model, optimizer, loader
    gc.collect()
    if error:
        raise RuntimeError('점검 오류를 보고서에 기록함: ' + json.dumps(error))
    if not weights_unchanged or not data_unchanged:
        raise RuntimeError('입력 원본의 해시가 변경됨')
    return result


# 실제 표적과 상위 후보로 분류 지표를 계산함.
def classification_metrics(targets, predictions, top3, class_count=51):
    if not targets or not len(targets) == len(predictions) == len(top3):
        raise ValueError('평가 표본 수가 유효하지 않음')
    tp, fp, fn = [0] * class_count, [0] * class_count, [0] * class_count
    for actual, predicted in zip(targets, predictions):
        if not 0 <= actual < class_count or not 0 <= predicted < class_count:
            raise ValueError('평가 클래스 ID가 유효하지 않음')
        if actual == predicted:
            tp[actual] += 1
        else:
            fp[predicted] += 1
            fn[actual] += 1
    f1 = [2 * tp[index] / (2 * tp[index] + fp[index] + fn[index])
          if 2 * tp[index] + fp[index] + fn[index] else 0.0 for index in range(class_count)]
    return {'top1': sum(tp) / len(targets),
            'top3': sum(actual in candidates for actual, candidates in zip(targets, top3)) / len(targets),
            'macro_f1': statistics.mean(f1), 'samples': len(targets), 'per_class_f1': f1}


# GPU와 검증된 51개 클래스 데이터를 확인하고 실행 환경을 기록함.
def prepare_gpu(config):
    config.validate()
    config.output.mkdir(parents=True, exist_ok=True)
    isolate_runtime(config)
    os.environ['CUBLAS_WORKSPACE_CONFIG'] = ':4096:8'
    import numpy as np
    import torch

    if not torch.cuda.is_available():
        raise RuntimeError('CUDA GPU가 없어 학습을 시작하지 않음')
    validation = json.loads((config.dataset / 'validation_report.json').read_text(encoding='utf-8'))
    if validation['class_count'] != 51 or any(validation[key] for key in
            ('cross_split_image_hash_groups', 'cross_split_source_groups', 'cross_split_crop_hash_groups')):
        raise ValueError('데이터 클래스·누수 검증이 유효하지 않음')
    if not config.weight_path().is_file():
        raise ValueError('ZIP에 포함된 사전학습 가중치가 없음')
    if config.model == 'yolo':
        detector_data_path(config)
    random.seed(config.seed)
    np.random.seed(config.seed)
    torch.manual_seed(config.seed)
    torch.cuda.manual_seed_all(config.seed)
    torch.set_num_threads(config.threads)
    torch.backends.cudnn.benchmark = False
    torch.backends.cudnn.deterministic = True
    torch.use_deterministic_algorithms(True, warn_only=True)
    environment = environment_record(config)
    environment.update({'cuda': torch.version.cuda, 'gpu': torch.cuda.get_device_name(0),
                        'gpu_total_gib': torch.cuda.get_device_properties(0).total_memory / 1024**3,
                        'test_evaluated': False})
    (config.output / 'gpu_environment.json').write_text(json.dumps(environment, indent=2), encoding='utf-8')
    return torch.device('cuda:0')


# test·다운로드 경로가 없는 Colab 전용 탐지 설정만 허용함.
def detector_data_path(config):
    path = config.dataset / 'yolo/colab_data.yaml'
    data = json.loads(path.read_text(encoding='utf-8'))
    mapping = json.loads((config.dataset / 'class_indices.json').read_text(encoding='utf-8'))['yolo']
    if (set(data) != {'path', 'train', 'val', 'nc', 'names'} or data['nc'] != 51
            or data['names'] != list(mapping)
            or data['train'] != 'train/images' or data['val'] != 'valid/images'
            or Path(data['path']).resolve() != (config.dataset / 'yolo').resolve()):
        raise ValueError('train·valid 전용 탐지 경로가 아님')
    return path


# train 표본만 최대 5배치 점검하고 학습 체크포인트는 저장하지 않음.
def gpu_smoke(config, batches=5):
    if not 1 <= batches <= MAX_APPROVED_BATCHES:
        raise ValueError('GPU 소규모 점검은 최대 5배치임')
    budget_path = config.output / f'{config.model}_batch_budget.json'
    used = json.loads(budget_path.read_text(encoding='utf-8'))['attempted_batches'] if budget_path.exists() else 0
    batches = min(batches, MAX_APPROVED_BATCHES - used)
    if batches < 1:
        raise ValueError('해당 GPU 실험의 소규모 점검 5배치를 이미 사용함')
    device = prepare_gpu(config)
    import torch

    if config.model == 'efficientnet':
        model = build_efficientnet(config, 51)
        loader, _, criterion = classification_loader(config, batches, model)
        criterion = criterion.to(device)
    else:
        model = build_yolo(config, 51)
        dataset = DetectionSmokeDataset(config, batches, 51)
        loader = torch.utils.data.DataLoader(dataset, batch_size=config.dimensions()[0],
                                           collate_fn=detection_collate, num_workers=0)
        criterion = None
    model.to(device).train()
    optimizer = torch.optim.AdamW(model.parameters(), lr=config.learning_rate, weight_decay=config.weight_decay)
    records = []
    try:
        for batch in loader:
            reserve_batch(config)
            torch.cuda.reset_peak_memory_stats()
            torch.cuda.synchronize()
            started = time.perf_counter()
            optimizer.zero_grad(set_to_none=True)
            if criterion is not None:
                images, targets = batch
                loss = criterion(model(images.to(device)), targets.to(device))
            else:
                inputs = {key: value.to(device) for key, value in batch.items()}
                loss = model(inputs)[0].sum()
            if not torch.isfinite(loss).item():
                raise RuntimeError('소규모 점검 손실이 유한하지 않음')
            loss.backward()
            optimizer.step()
            torch.cuda.synchronize()
            row = {'batch': len(records) + 1, 'seconds': time.perf_counter() - started,
                   'loss': float(loss.detach()), 'peak_cuda_mib': torch.cuda.max_memory_allocated() / 1024**2}
            records.append(row)
            print(json.dumps(row), flush=True)
    finally:
        del model, optimizer, loader
        gc.collect()
        torch.cuda.empty_cache()
    result = {'model': config.model, 'batches': records, 'test_evaluated': False, 'checkpoint_saved': False}
    (config.output / f'{config.model}_gpu_smoke.json').write_text(json.dumps(result, indent=2), encoding='utf-8')
    return result


# train·valid 폴더만 읽고 클래스 순서와 불균형 손실 가중치를 준비함.
def full_classification_loaders(config, model):
    import torch
    import timm
    from torchvision.datasets import ImageFolder

    info = timm.data.resolve_model_data_config(model)
    train = ImageFolder(config.dataset / 'efficientnet/train', timm.data.create_transform(**info, is_training=True))
    valid = ImageFolder(config.dataset / 'efficientnet/valid', timm.data.create_transform(**info, is_training=False))
    mapping = json.loads((config.dataset / 'class_indices.json').read_text(encoding='utf-8'))['efficientnet_imagefolder']
    if train.class_to_idx != mapping or valid.class_to_idx != mapping or len(mapping) != 51:
        raise ValueError('train·valid 클래스 인덱스가 기존 매핑과 다름')
    counts = [train.targets.count(index) for index in range(51)]
    weights = torch.tensor([1 / math.sqrt(count) for count in counts], dtype=torch.float32)
    weights /= weights.mean()
    generator = torch.Generator().manual_seed(config.seed)
    common = {'batch_size': config.dimensions()[0], 'num_workers': config.workers, 'pin_memory': True}
    return (torch.utils.data.DataLoader(train, shuffle=True, generator=generator, **common),
            torch.utils.data.DataLoader(valid, shuffle=False, **common),
            torch.nn.CrossEntropyLoss(weight=weights), generator)


# valid 분할만 평가하고 Top-1·Top-3·Macro-F1을 반환함.
def validate_classifier(model, loader, device):
    import torch

    model.eval()
    targets, predictions, candidates = [], [], []
    with torch.inference_mode():
        for images, actual in loader:
            logits = model(images.to(device, non_blocking=True))
            ranked = logits.topk(3, dim=1).indices.cpu().tolist()
            targets.extend(actual.tolist())
            candidates.extend(ranked)
            predictions.extend(row[0] for row in ranked)
    return classification_metrics(targets, predictions, candidates)


# 체크포인트를 임시 파일에 저장한 뒤 완성된 파일로 교체함.
def atomic_checkpoint(state, path):
    import torch

    temporary = path.with_suffix('.tmp')
    torch.save(state, temporary)
    temporary.replace(path)


# EfficientNet 전체 학습을 수행하고 valid Macro-F1으로 최적 모델을 선정함.
def train_classifier(config, device, checkpoint_callback=None):
    import numpy as np
    import torch
    from dataclasses import asdict

    run = config.output / 'efficientnet'
    if run.exists() and config.resume is None:
        raise ValueError('기존 실험이 있음. 새 output 또는 명시적 resume을 사용해야 함')
    run.mkdir(parents=True, exist_ok=True)
    model = build_efficientnet(config, 51).to(device)
    train, valid, criterion, generator = full_classification_loaders(config, model)
    criterion = criterion.to(device)
    optimizer = torch.optim.AdamW(model.parameters(), lr=config.learning_rate, weight_decay=config.weight_decay)
    scaler = torch.amp.GradScaler('cuda')
    start_epoch, best_score = 0, -1.0
    fingerprint = file_hash(config.dataset / 'validation_report.json')
    mapping = json.loads((config.dataset / 'class_indices.json').read_text(encoding='utf-8'))
    if config.resume:
        # 사용자가 직접 보관한 신뢰 가능한 자체 체크포인트만 재개함.
        state = torch.load(config.resume, map_location='cpu', weights_only=False)
        if state['dataset_sha256'] != fingerprint or state['class_indices'] != mapping:
            raise ValueError('체크포인트의 데이터 버전·클래스가 다름')
        for key in ('seed', 'batch_size', 'learning_rate', 'weight_decay'):
            if state['config'][key] != asdict(config)[key]:
                raise ValueError('재개 설정이 이전 실행과 다름: ' + key)
        model.load_state_dict(state['model'])
        optimizer.load_state_dict(state['optimizer'])
        scaler.load_state_dict(state['scaler'])
        start_epoch, best_score = state['epoch'] + 1, state['best_macro_f1']
        random.setstate(state['python_rng'])
        np.random.set_state(state['numpy_rng'])
        torch.set_rng_state(state['torch_rng'])
        torch.cuda.set_rng_state_all(state['cuda_rng'])
        generator.set_state(state['loader_rng'])
    (run / 'config.json').write_text(json.dumps(asdict(config), default=str, indent=2), encoding='utf-8')
    try:
        for epoch in range(start_epoch, config.epochs):
            model.train()
            total_loss, samples = 0.0, 0
            for images, targets in train:
                images, targets = images.to(device, non_blocking=True), targets.to(device, non_blocking=True)
                optimizer.zero_grad(set_to_none=True)
                with torch.autocast('cuda', dtype=torch.float16):
                    loss = criterion(model(images), targets)
                if not torch.isfinite(loss).item():
                    raise RuntimeError('학습 손실이 유한하지 않음')
                scaler.scale(loss).backward()
                scaler.step(optimizer)
                scaler.update()
                total_loss += float(loss.detach()) * len(targets)
                samples += len(targets)
            metrics = validate_classifier(model, valid, device)
            improved = metrics['macro_f1'] > best_score
            best_score = max(best_score, metrics['macro_f1'])
            row = {'epoch': epoch + 1, 'train_loss': total_loss / samples,
                   'validation': metrics, 'split': 'valid', 'test_evaluated': False}
            with (run / 'history.jsonl').open('a', encoding='utf-8') as stream:
                stream.write(json.dumps(row) + '\n')
            state = {'epoch': epoch, 'model': model.state_dict(), 'optimizer': optimizer.state_dict(),
                     'scaler': scaler.state_dict(), 'best_macro_f1': best_score,
                     'dataset_sha256': fingerprint, 'class_indices': mapping, 'config': asdict(config),
                     'python_rng': random.getstate(), 'numpy_rng': np.random.get_state(),
                     'torch_rng': torch.get_rng_state(), 'cuda_rng': torch.cuda.get_rng_state_all(),
                     'loader_rng': generator.get_state()}
            atomic_checkpoint(state, run / 'last.pt')
            if improved:
                atomic_checkpoint(state, run / 'best.pt')
                (run / 'best_validation.json').write_text(json.dumps(row, indent=2), encoding='utf-8')
            print(json.dumps({key: value for key, value in row.items() if key != 'validation'}),
                  {key: metrics[key] for key in ('top1', 'top3', 'macro_f1')}, flush=True)
            if checkpoint_callback:
                checkpoint_callback('efficientnet', epoch + 1, run)
    finally:
        del model, optimizer, train, valid
        gc.collect()
        torch.cuda.empty_cache()
    return json.loads((run / 'best_validation.json').read_text(encoding='utf-8'))


# YOLO 네이티브 학습을 실행하고 valid mAP 기준 최적 모델을 평가함.
def train_detector(config, device, checkpoint_callback=None):
    from ultralytics import YOLO, settings
    import torch
    from dataclasses import asdict

    run = config.output / 'yolo'
    if run.exists() and config.resume is None:
        raise ValueError('기존 실험이 있음. 새 output 또는 명시적 resume을 사용해야 함')
    settings.update({'sync': False, 'wandb': False, 'mlflow': False, 'clearml': False,
                     'comet': False, 'hub': False, 'tensorboard': False,
                     'datasets_dir': str(config.dataset / 'yolo'),
                     'weights_dir': str(config.weights), 'runs_dir': str(config.output)})
    run.mkdir(parents=True, exist_ok=True)
    provenance_path = run / 'provenance.json'
    provenance = {'dataset_sha256': file_hash(config.dataset / 'validation_report.json'),
                  'class_indices': json.loads((config.dataset / 'class_indices.json').read_text(encoding='utf-8')),
                  'seed': config.seed, 'batch_size': config.dimensions()[0],
                  'learning_rate': config.learning_rate, 'weight_decay': config.weight_decay}
    if config.resume:
        if not config.resume.resolve().is_relative_to(run.resolve()):
            raise ValueError('현재 실험에 속하지 않은 체크포인트임')
        if not provenance_path.is_file() or json.loads(provenance_path.read_text(encoding='utf-8')) != provenance:
            raise ValueError('이전 YOLO 실험의 데이터·설정 확인이 필요함')
    else:
        provenance_path.write_text(json.dumps(provenance, indent=2), encoding='utf-8')
    model = YOLO(str(config.resume or config.weight_path()), task='detect')

    # 에포크 저장이 끝난 시점에만 사용자 백업 동작을 연결함.
    def on_save(trainer):
        if checkpoint_callback:
            checkpoint_callback('yolo', trainer.epoch + 1, run)

    model.add_callback('on_model_save', on_save)
    (run / 'config.json').write_text(json.dumps(asdict(config), default=str, indent=2), encoding='utf-8')
    try:
        model.train(data=str(detector_data_path(config)), device=0,
                    epochs=config.epochs, batch=config.dimensions()[0], imgsz=640,
                    seed=config.seed, deterministic=True, workers=config.workers,
                    optimizer='AdamW', lr0=config.learning_rate, weight_decay=config.weight_decay,
                    project=str(run), name='train', exist_ok=config.resume is not None,
                    resume=bool(config.resume), val=True, split='val', patience=0,
                    save=True, save_period=1, plots=False, cache=False, amp=False)
        # 별도 test 평가 없이 valid에 대한 최적 모델 지표만 기록함.
        best = YOLO(str(run / 'train/weights/best.pt'), task='detect')
        metrics = best.val(data=str(detector_data_path(config)), split='val', device=0,
                           batch=config.dimensions()[0], imgsz=640, workers=config.workers,
                           project=str(run), name='best_valid', plots=False, save_json=False)
        result = {'split': 'valid', 'map50': float(metrics.box.map50),
                  'map50_95': float(metrics.box.map), 'precision': float(metrics.box.mp),
                  'recall': float(metrics.box.mr), 'test_evaluated': False}
        (run / 'best_validation.json').write_text(json.dumps(result, indent=2), encoding='utf-8')
        return result
    finally:
        del model
        gc.collect()
        torch.cuda.empty_cache()


# 사용자가 명시적으로 실행한 GPU 학습만 해당 모델 함수로 전달함.
def run_gpu_training(config, checkpoint_callback=None):
    device = prepare_gpu(config)
    if config.model == 'efficientnet':
        return train_classifier(config, device, checkpoint_callback)
    return train_detector(config, device, checkpoint_callback)


# 명시적인 스모크 모드에서만 CPU 최대 5배치 점검을 시작함.
def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--smoke', action='store_true')
    parser.add_argument('--model', choices=['efficientnet', 'yolo'], required=True)
    parser.add_argument('--dataset', type=Path, default=SmokeConfig.__dataclass_fields__['dataset'].default)
    parser.add_argument('--output', type=Path, default=SmokeConfig.__dataclass_fields__['output'].default)
    parser.add_argument('--weights', type=Path, default=SmokeConfig.__dataclass_fields__['weights'].default)
    parser.add_argument('--batches', type=int, default=5)
    args = parser.parse_args()
    if not args.smoke:
        parser.error('이 CLI는 --smoke CPU 점검만 지원함. GPU 학습은 Colab의 명시적 실행 셀을 사용해야 함')
    result = run_smoke(SmokeConfig(model=args.model, dataset=args.dataset, output=args.output,
                                  weights=args.weights, batches=args.batches))
    print(json.dumps({key: value for key, value in result.items() if key != 'measurements'}), flush=True)


if __name__ == '__main__':
    main()
