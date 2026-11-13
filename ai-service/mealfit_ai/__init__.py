"""MealFit AI 서비스 (Flask + Gemini).

구조
- controllers/  HTTP 라우트(Blueprint)와 오류 응답 — Controller
- services/     추천 프롬프트·응답 검증 — Model(비즈니스 로직)
- schemas/      요청 본문 검증 — Model(입력 규칙)
- clients/      Gemini 호출
"""
import os
from datetime import datetime, timedelta, timezone
from pathlib import Path

from dotenv import load_dotenv
from flask import Flask

from mealfit_ai.clients.gemini_client import generate
from mealfit_ai.controllers.error_handlers import register_error_handlers
from mealfit_ai.controllers.health_controller import health_bp
from mealfit_ai.controllers.meal_plan_controller import meal_plan_bp
from mealfit_ai.controllers.quick_recipe_controller import quick_recipe_bp
from mealfit_ai.services.meal_plan_service import generate_meals

KST = timezone(timedelta(hours=9))


def create_app(config=None):
    # ai-service/.env (루트 .env는 읽지 않는다). 프로세스 환경 변수가 우선한다
    load_dotenv(Path(__file__).resolve().parent.parent / '.env', override=False)
    app = Flask(__name__)
    app.json.ensure_ascii = False
    app.config.update(MAX_CONTENT_LENGTH=1024 * 1024, GEMINI_API_KEY=os.getenv('GEMINI_API_KEY', ''),
                      GEMINI_MODEL=os.getenv('GEMINI_MODEL', 'gemini-3.5-flash-lite'),
                      # 테스트는 GENERATOR·MEAL_GENERATOR·TODAY를 바꿔 끼워 Gemini 없이 검증한다
                      GENERATOR=generate, MEAL_GENERATOR=generate_meals,
                      TODAY=lambda: datetime.now(KST).date())
    app.config.update(config or {})

    app.register_blueprint(health_bp)
    app.register_blueprint(quick_recipe_bp)
    app.register_blueprint(meal_plan_bp)
    register_error_handlers(app)
    return app
