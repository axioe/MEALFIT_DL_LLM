from flask import Blueprint, current_app, jsonify

from mealfit_ai.controllers.request_body import read_json_body
from mealfit_ai.services import meal_plan_service

meal_plan_bp = Blueprint('meal_plan', __name__)


@meal_plan_bp.post('/ai/meal-plans')
def recommend_meals():
    """하루 식단 추천: 요청한 끼니마다 식단 초안을 만든다 (Spring이 최종 검증)."""
    config = current_app.config
    validated = meal_plan_service.validate_request(read_json_body(), config['TODAY']())
    raw = config['MEAL_GENERATOR'](validated, config['GEMINI_API_KEY'], config['GEMINI_MODEL'])
    return jsonify(meal_plan_service.validate_response(raw, validated))
