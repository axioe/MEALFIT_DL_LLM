"""단일 식재료 사진의 후보만 반환하며 재고는 변경하지 않음."""
import hashlib
import io
import pickle
import threading
import warnings
from pathlib import Path, PurePosixPath

from mealfit_ai.errors import ServiceError

MAX_IMAGE_BYTES = 10 * 1024**2


class CompatibleUnpickler(pickle.Unpickler):
    # Python 3.13 경로 메타데이터를 현재 플랫폼과 독립적으로 복원함.
    def find_class(self, module, name):
        if module in ('pathlib', 'pathlib._local') and name == 'PosixPath':
            return PurePosixPath
        return super().find_class(module, name)


class CompatiblePickle:
    Unpickler = CompatibleUnpickler
    load = pickle.load
    loads = pickle.loads


# 파일 내용과 이미지 크기를 검사하고 EXIF 방향을 반영한 RGB 픽셀만 반환함.
def read_image(data):
    from PIL import Image, ImageOps, UnidentifiedImageError

    if not data or len(data) > MAX_IMAGE_BYTES:
        raise ServiceError(400, 'VISION_001', '10MB 이하의 JPEG·PNG 이미지 한 장을 입력해 주세요.', 'image')
    try:
        with warnings.catch_warnings():
            warnings.simplefilter('error', Image.DecompressionBombWarning)
            with Image.open(io.BytesIO(data)) as image:
                if image.format not in {'JPEG', 'PNG'} or image.width * image.height > 16_000_000:
                    raise ValueError('지원하지 않는 이미지임')
                image.verify()
            with Image.open(io.BytesIO(data)) as image:
                result = ImageOps.exif_transpose(image).convert('RGB')
                result.thumbnail((1024, 1024))
                result.info.clear()
                return result
    except (UnidentifiedImageError, OSError, ValueError, Image.DecompressionBombError,
            Image.DecompressionBombWarning):
        raise ServiceError(400, 'VISION_001', '정상적인 JPEG·PNG 이미지를 입력해 주세요.', 'image') from None


class IngredientClassifier:
    # 앱별 모델 캐시와 초기 로딩 잠금을 준비함.
    def __init__(self, config):
        self.path = config.get('VISION_MODEL_PATH', '')
        self.sha256 = config.get('VISION_MODEL_SHA256', '')
        self.version = config.get('VISION_MODEL_VERSION', 'efficientnet-b0-stage3-epoch19')
        self.model = None
        self.lock = threading.Lock()

    # 신뢰한 해시의 로컬 가중치만 읽고 모델을 한 번 로딩함.
    def load(self):
        if self.model is not None:
            return
        with self.lock:
            if self.model is not None:
                return
            try:
                import torch
                import timm

                path = Path(self.path)
                if not self.sha256 or not path.is_file():
                    raise ValueError('모델 설정이 없음')
                raw = path.read_bytes()
                if hashlib.sha256(raw).hexdigest() != self.sha256:
                    raise ValueError('모델 무결성 검사 실패')
                # 자체 학습·해시 검증을 마친 체크포인트만 호환 로더로 읽음.
                state = torch.load(io.BytesIO(raw), map_location='cpu', weights_only=False,
                                   pickle_module=CompatiblePickle)
                mapping = state['class_indices']['efficientnet_imagefolder']
                if len(mapping) != 51 or set(mapping.values()) != set(range(51)):
                    raise ValueError('클래스 매핑 오류')
                model = timm.create_model('efficientnet_b0.ra_in1k', pretrained=False, num_classes=51)
                model.load_state_dict(state['model'], strict=True)
                model.eval()
                transform = timm.data.create_transform(**timm.data.resolve_model_data_config(model), is_training=False)
                self.names = [name for name, index in sorted(mapping.items(), key=lambda row: row[1])]
                self.transform = transform
                self.model = model
            except Exception:
                raise ServiceError(503, 'VISION_002', '이미지 인식 모델을 사용할 수 없습니다.') from None

    # 추론 모드로 Top-3 확률을 계산하고 원본 이미지는 저장하지 않음.
    def predict(self, image):
        self.load()
        try:
            import torch

            with torch.inference_mode():
                logits = self.model(self.transform(image).unsqueeze(0))
                if logits.shape != (1, 51) or not torch.isfinite(logits).all():
                    raise ValueError('예측 출력 오류')
                values, indices = logits.softmax(1).topk(3, dim=1)
            return {'modelVersion': self.version, 'candidates': [
                {'className': self.names[index], 'confidence': float(value)}
                for value, index in zip(values[0].tolist(), indices[0].tolist())]}
        except Exception:
            raise ServiceError(500, 'VISION_003', '이미지 인식에 실패했습니다. 다시 시도해 주세요.') from None
