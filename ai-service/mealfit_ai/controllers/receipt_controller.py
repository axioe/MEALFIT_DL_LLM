from flask import Blueprint, current_app, jsonify, request

from mealfit_ai.errors import ServiceError
from mealfit_ai.services.ingredient_classifier import MAX_IMAGE_BYTES, read_image

receipt_bp = Blueprint('receipt', __name__)


# 이미지·개인정보를 저장하지 않고 확인 전 구매 품목 후보만 반환함
@receipt_bp.post('/ai/ocr/receipt')
def recognize_receipt():
    request.max_content_length = MAX_IMAGE_BYTES + 1024**2
    if set(request.files) != {'image'} or len(request.files.getlist('image')) != 1 or request.form:
        raise ServiceError(400, 'RECEIPT_001', 'image에 JPEG·PNG 영수증 한 장을 입력해 주세요.', 'image')
    image = read_image(request.files['image'].read(MAX_IMAGE_BYTES + 1))
    predictor = current_app.config.get('RECEIPT_PREDICTOR') or current_app.extensions['receipt_ocr']
    return jsonify(predictor.recognize(image))
