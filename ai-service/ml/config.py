"""기존 CPU 점검과 사용자가 실행할 Colab GPU 학습 설정을 관리함."""

import math
from dataclasses import dataclass
from pathlib import Path

DATASET_ROOT = Path(r'D:\MealFit_ingredient_data\foods_ingredients_v11_stage3')
WEIGHT_ROOT = Path(r'D:\MealFit_ingredient_models\pretrained')
RUN_ROOT = Path(r'D:\MealFit_ingredient_runs\stage3_cpu_smoke')
MAX_APPROVED_BATCHES = 5


@dataclass(frozen=True)
class SmokeConfig:
    model: str
    dataset: Path = DATASET_ROOT
    weights: Path = WEIGHT_ROOT
    output: Path = RUN_ROOT
    batches: int = 5
    seed: int = 42
    threads: int = 4

    # 승인 범위와 저장 경로를 검사함.
    def validate(self):
        if self.model not in {'efficientnet', 'yolo'}:
            raise ValueError('지원하는 점검 모델이 아님')
        if not 1 <= self.batches <= MAX_APPROVED_BATCHES or not 1 <= self.threads <= 4:
            raise ValueError('CPU 1~4스레드·최대 5배치 승인 범위를 벗어남')
        repository = Path(__file__).resolve().parents[2]
        output = self.output.resolve()
        if (output.is_relative_to(repository) or output.is_relative_to(self.dataset.resolve())
                or output.is_relative_to(self.weights.resolve())):
            raise ValueError('결과는 저장소·데이터·사전학습 파일 외부에 저장해야 함')
        return self

    # 모델별 보수적인 CPU 배치 크기와 입력 크기를 반환함.
    def dimensions(self):
        return (8, 224) if self.model == 'efficientnet' else (2, 640)

    # 다운로드 없이 읽을 사전학습 파일 경로를 반환함.
    def weight_path(self):
        filename = 'efficientnet_b0.ra_in1k.safetensors' if self.model == 'efficientnet' else 'yolov8n.pt'
        return self.weights / filename


@dataclass(frozen=True)
class GpuConfig:
    model: str
    dataset: Path = Path('/content/mealfit/data')
    weights: Path = Path('/content/mealfit/data/pretrained')
    output: Path = Path('/content/mealfit/runs/baseline_01')
    epochs: int = 20
    batch_size: int | None = None
    seed: int = 42
    threads: int = 2
    workers: int = 2
    learning_rate: float = 0.001
    weight_decay: float = 0.0001
    resume: Path | None = None
    init_checkpoint: Path | None = None
    init_sha256: str | None = None
    preliminary: bool = False
    baseline_report: Path | None = None
    max_old_metric_drop: float = 0.02
    max_old_recall_drop: float = 0.10
    recall_min_support: int = 20
    finetune_scope: str = 'head'
    backbone_learning_rate: float | None = None
    class_sampling: str = 'shuffle'
    class_loss: str = 'inverse_sqrt'
    selection_metric: str = 'old_macro_f1'
    early_stopping_patience: int | None = None
    early_stopping_min_delta: float = 0.0

    # 모델과 학습 범위를 검사하고 원본 내부 결과 저장을 막음.
    def validate(self):
        if self.model not in {'efficientnet', 'yolo'}:
            raise ValueError('지원하는 모델이 아님')
        if (not 1 <= self.epochs <= 100 or (self.batch_size is not None and self.batch_size < 1)):
            raise ValueError('학습 에포크 또는 배치 크기가 유효하지 않음')
        if not 0 <= self.workers <= 4 or not 1 <= self.threads <= 4:
            raise ValueError('Colab 작업자·스레드 범위를 벗어남')
        if (not math.isfinite(self.learning_rate) or not math.isfinite(self.weight_decay)
                or self.learning_rate <= 0 or self.weight_decay < 0):
            raise ValueError('학습률과 가중치 감쇠 값이 유효하지 않음')
        if (self.finetune_scope not in {'head', 'last_block'}
                or self.class_sampling not in {'shuffle', 'balanced'}
                or self.class_loss not in {'inverse_sqrt', 'none'}
                or self.selection_metric not in {'old_macro_f1', 'balanced_old_new_macro_f1'}):
            raise ValueError('지원하지 않는 분류 실험 정책임')
        custom_policy = (self.finetune_scope != 'head' or self.class_sampling != 'shuffle'
                         or self.class_loss != 'inverse_sqrt' or self.selection_metric != 'old_macro_f1'
                         or self.early_stopping_patience is not None or self.early_stopping_min_delta != 0)
        if custom_policy and not self.preliminary:
            raise ValueError('새 학습 정책은 명시한 예비 EfficientNet 실험에서만 허용함')
        if self.finetune_scope == 'last_block':
            if (self.backbone_learning_rate is None or not math.isfinite(self.backbone_learning_rate)
                    or not 0 < self.backbone_learning_rate < self.learning_rate):
                raise ValueError('마지막 블록 학습률은 출력층보다 작고 0보다 커야 함')
        elif self.backbone_learning_rate is not None:
            raise ValueError('출력층 실험에는 특징 추출층 학습률을 지정할 수 없음')
        if self.class_sampling == 'balanced' and self.class_loss != 'none':
            raise ValueError('균형 샘플링과 클래스 손실 가중치를 중복 적용할 수 없음')
        if (self.early_stopping_patience is not None
                and (isinstance(self.early_stopping_patience, bool)
                     or not isinstance(self.early_stopping_patience, int)
                     or not 1 <= self.early_stopping_patience <= self.epochs)):
            raise ValueError('조기 종료 대기 에포크가 유효하지 않음')
        if not math.isfinite(self.early_stopping_min_delta) or not 0 <= self.early_stopping_min_delta <= 1:
            raise ValueError('조기 종료 최소 개선량이 유효하지 않음')
        output = self.output.resolve()
        code_root = Path(__file__).resolve().parent
        repository = code_root.parents[1] if code_root.name == 'ml' else code_root
        if any(output.is_relative_to(path.resolve()) for path in (self.dataset, self.weights, repository)):
            raise ValueError('결과는 데이터·가중치·저장소 외부에 저장해야 함')
        if self.init_checkpoint is not None:
            if self.model != 'efficientnet' or self.resume is not None:
                raise ValueError('클래스 확장은 EfficientNet 새 실험으로만 실행해야 함')
            if (not self.init_checkpoint.is_file() or self.init_sha256 is None
                    or len(self.init_sha256) != 64
                    or any(c not in '0123456789abcdef' for c in self.init_sha256)):
                raise ValueError('초기 가중치 파일과 검증된 SHA-256이 필요함')
            if output.is_relative_to(self.init_checkpoint.resolve().parent):
                raise ValueError('기존 서비스 가중치 폴더에 결과를 저장할 수 없음')
        if self.preliminary and (self.model != 'efficientnet' or self.init_checkpoint is None
                                 or self.resume is not None or self.epochs > 3):
            raise ValueError('예비 확장은 새 EfficientNet 실험·최대 3에포크로만 준비해야 함')
        if (not all(math.isfinite(value) and 0 <= value <= 1
                    for value in (self.max_old_metric_drop, self.max_old_recall_drop))
                or self.recall_min_support < 1):
            raise ValueError('기존 클래스 성능 감시 기준이 유효하지 않음')
        if self.init_checkpoint is not None and (self.baseline_report is None or not self.baseline_report.is_file()):
            raise ValueError('기존 51클래스 Validation 기준 보고서가 필요함')
        if self.resume is not None and not self.resume.is_file():
            raise ValueError('재개할 체크포인트가 없음')
        return self

    # T4 기준 초기 배치 크기와 해상도를 반환함.
    def dimensions(self):
        default_batch, image_size = (32, 224) if self.model == 'efficientnet' else (8, 640)
        return self.batch_size or default_batch, image_size

    # 기존에 검증한 사전학습 파일 이름을 재사용함.
    def weight_path(self):
        return self.init_checkpoint or SmokeConfig(self.model, weights=self.weights).weight_path()
