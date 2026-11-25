import time

from flask import Blueprint, current_app, jsonify, request

from mealfit_ai.clients.pose_model_client import PoseModelClient, UNAVAILABLE
from mealfit_ai.controllers.request_body import read_json_body
from mealfit_ai.errors import ServiceError
from mealfit_ai.schemas.pose import MAX_BYTES, validate_pose_request

pose_bp = Blueprint('pose', __name__)


def pose_client():
    client = current_app.config.get('POSE_CLIENT')
    if client is None:
        # 모델은 판정 요청이 있을 때만 앱 단위로 준비한다
        with current_app.extensions['pose_lock']:
            client = current_app.extensions.get('pose_client')
            if client is None:
                client = PoseModelClient(current_app.config.get('POSE_MODEL_DIR', ''))
                current_app.extensions['pose_client'] = client
    return client


@pose_bp.post('/ai/pose/analyze')
# 관절 좌표만 받아 판정한다. 영상·이미지·회원 정보는 받지 않고 좌표도 저장하지 않는다.
def analyze_pose():
    request.max_content_length = MAX_BYTES
    exercise, fps, frames = validate_pose_request(read_json_body(parse_float=float))
    try:
        from mealfit_ai.services.pose_service import analyze
    except ImportError:  # numpy 가 없는 기본 이미지
        raise ServiceError(503, *UNAVAILABLE) from None
    started = time.perf_counter()
    result = analyze(pose_client(), exercise, fps, frames, current_app.config['POSE_MODEL_VERSION'])
    current_app.logger.info('pose analyze exercise=%s status=%s reps=%d ms=%d model=%s', exercise, result['status'],
                            result['repCount'], round((time.perf_counter() - started) * 1000), result['modelVersion'])
    return jsonify(result)
