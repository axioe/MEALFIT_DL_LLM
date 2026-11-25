"""운동 자세 판별 요청 검증 (POST /ai/pose/analyze).

본문: {"exercise": "푸시업", "fps": 15, "frames": [[[x, y, z, visibility] × 33] | null, ...]}
- exercise: 자세 판별 운동명 (exercise_catalog.pose_exercise_key, 모델 manifest 키)
- frames: 프레임마다 MediaPipe world 좌표 33개와 visibility. 사람을 못 찾은 프레임은 null
numpy 없이 검증만 한다 (기본 이미지에서도 오류 응답이 나가도록).
"""
import math

from mealfit_ai.errors import ServiceError

MAX_BYTES = 3 * 1024 * 1024
MIN_FPS, MAX_FPS = 5, 30
MAX_SECONDS = 60
MAX_FRAMES = 900
JOINTS = 33
MAX_COORD = 10.0  # world 좌표(미터, 골반 중심). 사람 크기를 크게 넘는 값은 잘못된 입력


def invalid(message, field):
    raise ServiceError(400, 'POSE_001', message, field)


def _number(value):
    return type(value) in (int, float) and math.isfinite(value)


def _frame(frame):
    if frame is None:
        return None
    if not isinstance(frame, list) or len(frame) != JOINTS:
        invalid('프레임마다 관절 33개를 입력해 주세요.', 'frames')
    for point in frame:
        if (not isinstance(point, list) or len(point) != 4 or not all(_number(v) for v in point)
                or not all(-MAX_COORD <= v <= MAX_COORD for v in point[:3]) or not 0 <= point[3] <= 1):
            invalid('관절 좌표는 [x, y, z, visibility] 숫자로 입력해 주세요.', 'frames')
    return frame


def validate_pose_request(body):
    """(운동명, fps, 프레임 목록) 반환. 프레임은 33×4 목록 또는 None"""
    if not isinstance(body, dict) or set(body) != {'exercise', 'fps', 'frames'}:
        invalid('exercise, fps, frames 를 입력해 주세요.', 'body')
    exercise = body['exercise']
    if not isinstance(exercise, str) or not exercise.strip() or len(exercise) > 50:
        invalid('운동 이름을 확인해 주세요.', 'exercise')
    fps = body['fps']
    if not _number(fps) or not MIN_FPS <= fps <= MAX_FPS:
        invalid(f'fps는 {MIN_FPS}~{MAX_FPS} 사이로 입력해 주세요.', 'fps')
    frames = body['frames']
    if not isinstance(frames, list) or not frames:
        invalid('frames를 입력해 주세요.', 'frames')
    if len(frames) > MAX_FRAMES or len(frames) / fps > MAX_SECONDS:
        invalid(f'영상은 {MAX_SECONDS}초, {MAX_FRAMES}프레임 이하로 보내 주세요.', 'frames')
    return exercise.strip(), float(fps), [_frame(f) for f in frames]
