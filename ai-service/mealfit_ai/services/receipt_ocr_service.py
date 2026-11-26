"""기존 로컬 OCR 워커를 공유해 재사용하며 영수증 원문은 저장하지 않음."""
import base64
import io
import json
import logging
import queue
import time

from mealfit_ai.errors import ServiceError
from mealfit_ai.services.label_ocr_service import LabelOcrService
from mealfit_ai.services.receipt_parser import parse_receipt


# 완전히 흰 바깥 여백만 제거하고 글자와 비흰색 픽셀은 그대로 유지함
def prepare_receipt_image(image):
    from PIL import Image, ImageChops

    bounds = ImageChops.difference(image, Image.new('RGB', image.size, 'white')).getbbox()
    if bounds is None:
        return image
    left, top, right, bottom = bounds
    bounds = (max(0, left-16), max(0, top-16), min(image.width, right+16), min(image.height, bottom+16))
    return image.crop(bounds)


class ReceiptOcrService:
    # 라벨 인식과 같은 프로세스·잠금을 사용해 모델 중복 로딩을 피함
    def __init__(self, config, worker=None):
        self.worker = worker if worker is not None else LabelOcrService(config)

    # 공용 OCR 워커의 준비 상태를 반환함
    @property
    def ready(self):
        return self.worker.ready

    # 공용 OCR 워커의 준비 진행 여부를 반환함
    @property
    def warming(self):
        return self.worker.warming

    # 기존 워커의 준비 제한과 재시도 간격을 유지함
    def warmup(self):
        self.worker.warmup()

    # 검증 도구에서 사용한 워커를 정리함
    def close(self):
        self.worker.close()

    # 공용 잠금과 기존 시간 제한 안에서 좌표 포함 문자만 일시 처리함
    def recognize(self, image):
        worker = self.worker
        if not worker.ready:
            self.warmup()
            raise ServiceError(503, 'RECEIPT_002', '영수증 인식 준비 중입니다. 잠시 후 다시 시도해 주세요.')
        if not worker.lock.acquire(blocking=False):
            raise ServiceError(503, 'RECEIPT_002', '다른 영수증을 처리 중입니다. 잠시 후 다시 시도해 주세요.')
        started = time.perf_counter()
        try:
            if worker.process is None or worker.process.poll() is not None:
                self.close()
                raise ServiceError(503, 'RECEIPT_002', '영수증 인식 서비스를 사용할 수 없습니다.')
            buffer = io.BytesIO()
            prepare_receipt_image(image).save(buffer, format='PNG')
            payload = {'image': base64.b64encode(buffer.getvalue()).decode('ascii'), 'mode': 'receipt'}
            worker.process.stdin.write(json.dumps(payload) + '\n')
            worker.process.stdin.flush()
            message = worker.responses.get(timeout=worker.timeout)
            if not isinstance(message, dict) or message.get('status') != 'SUCCESS':
                raise ServiceError(503, 'RECEIPT_002', '영수증의 글자를 읽지 못했습니다. 다시 촬영해 주세요.')
            diagnostics = {}
            result = parse_receipt(message.get('lines'), diagnostics)
            logging.getLogger(__name__).info(
                'receipt OCR fragments=%s rows=%s items=%s excluded_private_or_financial=%s nonfood=%s low_confidence=%s unmatched=%s',
                diagnostics['fragments'], diagnostics['rows'], len(result['items']),
                diagnostics['excluded_private_or_financial'], diagnostics['excluded_nonfood'],
                diagnostics['excluded_low_confidence'], diagnostics['unmatched_rows'])
            result['elapsedMs'] = round((time.perf_counter() - started) * 1000)
            return result
        except queue.Empty:
            self.close()
            raise ServiceError(504, 'RECEIPT_003', '영수증 인식 시간이 초과되었습니다.') from None
        except (OSError, ValueError):
            self.close()
            raise ServiceError(503, 'RECEIPT_002', '영수증 인식에 실패했습니다. 다시 시도해 주세요.') from None
        finally:
            worker.lock.release()
