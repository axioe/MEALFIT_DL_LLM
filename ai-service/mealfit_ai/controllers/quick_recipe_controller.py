from flask import Blueprint, current_app, jsonify

from mealfit_ai.controllers.request_body import read_json_body
from mealfit_ai.schemas.validation import validate_request
from mealfit_ai.services.quick_recipe_service import validate_response

quick_recipe_bp = Blueprint('quick_recipe', __name__)


@quick_recipe_bp.post('/ai/quick-recipes')
def recommend():
    """15분 요리 추천: 선택 재료로 레시피 초안을 만든다 (Spring이 최종 검증)."""
    config = current_app.config
    validated = validate_request(read_json_body(), config['TODAY']())
    raw = config['GENERATOR'](validated, config['GEMINI_API_KEY'], config['GEMINI_MODEL'])
    return jsonify(validate_response(raw, validated))
