"""기존 CPU 점검과 사용자가 실행할 Colab GPU 학습 설정을 관리함."""

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

    # 모델과 학습 범위를 검사하고 원본 내부 결과 저장을 막음.
    def validate(self):
        if self.model not in {'efficientnet', 'yolo'}:
            raise ValueError('지원하는 모델이 아님')
        if (not 1 <= self.epochs <= 100 or (self.batch_size is not None and self.batch_size < 1)):
            raise ValueError('학습 에포크 또는 배치 크기가 유효하지 않음')
        if not 0 <= self.workers <= 4 or not 1 <= self.threads <= 4:
            raise ValueError('Colab 작업자·스레드 범위를 벗어남')
        if self.learning_rate <= 0 or self.weight_decay < 0:
            raise ValueError('학습률과 가중치 감쇠 값이 유효하지 않음')
        output = self.output.resolve()
        code_root = Path(__file__).resolve().parent
        repository = code_root.parents[1] if code_root.name == 'ml' else code_root
        if any(output.is_relative_to(path.resolve()) for path in (self.dataset, self.weights, repository)):
            raise ValueError('결과는 데이터·가중치·저장소 외부에 저장해야 함')
        if self.resume is not None and not self.resume.is_file():
            raise ValueError('재개할 체크포인트가 없음')
        return self

    # T4 기준 초기 배치 크기와 해상도를 반환함.
    def dimensions(self):
        default_batch, image_size = (32, 224) if self.model == 'efficientnet' else (8, 640)
        return self.batch_size or default_batch, image_size

    # 기존에 검증한 사전학습 파일 이름을 재사용함.
    def weight_path(self):
        return SmokeConfig(self.model, weights=self.weights).weight_path()
