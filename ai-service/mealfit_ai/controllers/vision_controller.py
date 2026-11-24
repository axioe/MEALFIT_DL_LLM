from flask import Blueprint, current_app, jsonify, request

from mealfit_ai.errors import ServiceError
from mealfit_ai.services.ingredient_classifier import IngredientClassifier, MAX_IMAGE_BYTES, read_image

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
    return jsonify(predictor.predict(image))
