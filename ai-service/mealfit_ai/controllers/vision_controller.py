import time

from flask import Blueprint, current_app, jsonify, request

from mealfit_ai.errors import ServiceError
from mealfit_ai.services.ingredient_classifier import IngredientClassifier, MAX_IMAGE_BYTES, read_image

from mealfit_ai.services.label_ocr_service import LabelOcrService

vision_bp = Blueprint('vision', __name__)


@vision_bp.post('/ai/vision/ingredients')
# 이미지 후보만 반환하며 회원·재고 등록 요청은 처리하지 않음.
def recognize_ingredients():
    request.max_content_length = MAX_IMAGE_BYTES + 1024**2
    if (set(request.files) != {'image'} or len(request.files.getlist('image')) != 1 or request.form):
        raise ServiceError(400, 'VISION_001', 'image 파일 한 장을 입력해 주세요.', 'image')
    image = read_image(request.files['image'].read(MAX_IMAGE_BYTES + 1))
    predictor = current_app.config.get('VISION_PREDICTOR')
    if predictor is None:
        # 모델은 이미지 요청이 있을 때만 앱 단위로 생성함.
        with current_app.extensions['vision_lock']:
            predictor = current_app.extensions.get('vision_classifier')
            if predictor is None:
                predictor = IngredientClassifier(current_app.config)
                current_app.extensions['vision_classifier'] = predictor
    started = time.perf_counter()
    result = dict(predictor.predict(image))
    dl_ms = round((time.perf_counter() - started) * 1000)
    ocr = current_app.config.get('OCR_PREDICTOR')
    if ocr is None:
        with current_app.extensions['vision_lock']:
            ocr = current_app.extensions.get('label_ocr')
            if ocr is None:
                ocr = LabelOcrService(current_app.config)
                current_app.extensions['label_ocr'] = ocr
    try:
        result['ocr'] = ocr.recognize(image)
    except Exception:
        result['ocr'] = {'status': 'ERROR', 'candidates': [], 'elapsedMs': 0}
    # 이미지·텍스트 대신 처리 시간만 기록함.
    current_app.logger.info('vision timings dlMs=%d ocrMs=%d', dl_ms, result['ocr'].get('elapsedMs', 0))
    return jsonify(result)
