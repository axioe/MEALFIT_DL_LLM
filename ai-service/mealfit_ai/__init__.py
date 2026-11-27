"""MealFit AI 서비스 (Flask + 자체 LLM(Ollama)).

구조
- controllers/  HTTP 라우트(Blueprint)와 오류 응답 — Controller
- services/     추천 프롬프트·응답 검증 — Model(비즈니스 로직)
- schemas/      요청 본문 검증 — Model(입력 규칙)
- clients/      자체 LLM(Ollama) 호출, 자세 판별 모델(ONNX) 호출
"""
import os
import sys
import threading
from datetime import datetime, timedelta, timezone
from pathlib import Path

from dotenv import load_dotenv
from flask import Flask

from mealfit_ai.clients.ollama_client import generate
from mealfit_ai.controllers.error_handlers import register_error_handlers
from mealfit_ai.controllers.health_controller import health_bp
from mealfit_ai.controllers.vision_controller import vision_bp
from mealfit_ai.controllers.receipt_controller import receipt_bp
from mealfit_ai.services.receipt_ocr_service import ReceiptOcrService
from mealfit_ai.services.label_ocr_service import LabelOcrService
from mealfit_ai.controllers.meal_plan_controller import meal_plan_bp
from mealfit_ai.controllers.pose_controller import pose_bp
from mealfit_ai.controllers.quick_recipe_controller import quick_recipe_bp
from mealfit_ai.services.meal_plan_service import generate_meals

KST = timezone(timedelta(hours=9))


# 설정과 Blueprint를 등록해 앱을 생성함.
def create_app(config=None):
    # ai-service/.env (루트 .env는 읽지 않는다). 프로세스 환경 변수가 우선한다
    load_dotenv(Path(__file__).resolve().parent.parent / '.env', override=False)
    app = Flask(__name__)
    app.json.ensure_ascii = False
    # 자체 LLM(D14): 비어 있으면 503 → Spring이 검수 레시피로 대체한다 (운영 EC2는 LLM을 돌리지 않는다)
    app.config.update(MAX_CONTENT_LENGTH=1024 * 1024, LLM_BASE_URL=os.getenv('LLM_BASE_URL', ''),
                      LLM_MODEL=os.getenv('LLM_MODEL', 'gemma4:e2b'),
                      # 테스트는 GENERATOR·MEAL_GENERATOR·TODAY를 바꿔 끼워 LLM 없이 검증한다
                      GENERATOR=generate, MEAL_GENERATOR=generate_meals,
                      TODAY=lambda: datetime.now(KST).date())
    app.config.update(VISION_MODEL_PATH=os.getenv('VISION_MODEL_PATH', ''),
                      VISION_MODEL_SHA256=os.getenv('VISION_MODEL_SHA256', ''),
                      VISION_MODEL_VERSION=os.getenv('VISION_MODEL_VERSION', 'efficientnet-b0-stage3-epoch19'))
    app.config.update(OCR_PYTHON=os.getenv('OCR_PYTHON', sys.executable),
                      OCR_DET_MODEL_DIR=os.getenv('OCR_DET_MODEL_DIR', ''),
                      OCR_REC_MODEL_DIR=os.getenv('OCR_REC_MODEL_DIR', ''),
                      OCR_TIMEOUT_SECONDS=8)
    # 자세 판별 모델 폴더(manifest.json). 비어 있으면 판정 요청에 503 POSE_003
    app.config.update(POSE_MODEL_DIR=os.getenv('POSE_MODEL_DIR', ''),
                      POSE_MODEL_VERSION=os.getenv('POSE_MODEL_VERSION', 'pose-20261123-41'))
    app.config.update(config or {})
    app.extensions['vision_lock'] = threading.Lock()
    app.extensions['pose_lock'] = threading.Lock()
    if 'OCR_PREDICTOR' not in app.config:
        app.extensions['label_ocr'] = LabelOcrService(app.config)
        app.extensions['label_ocr'].warmup()
    if 'RECEIPT_PREDICTOR' not in app.config:
        app.extensions['receipt_ocr'] = ReceiptOcrService(app.config, worker=app.extensions.get('label_ocr'))
        app.extensions['receipt_ocr'].warmup()
    app.register_blueprint(receipt_bp)
    app.register_blueprint(vision_bp)
    app.register_blueprint(health_bp)
    app.register_blueprint(quick_recipe_bp)
    app.register_blueprint(meal_plan_bp)
    app.register_blueprint(pose_bp)
    register_error_handlers(app)
    return app
