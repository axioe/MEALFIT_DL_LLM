"""운동 자세 판별 (FR-WORK-05, TRD AI-05, SDD 5.9·7.6).

관절 좌표 → 반복 분할 → 반복마다 학습과 같은 전처리 → 운동별 모델 → 조건별 판정·문구.
- 판정은 모두 '참고'다 (D20, 2026-11-24): 정확도와 상관없이 모든 조건을 보여 주고 판정 보류는 없다.
- 사람을 못 찾았거나 프레임이 부족하면 판정 대신 재촬영 안내(status RETAKE)를 돌려준다.
- 학습 데이터에 없는 촬영 방향이면 판정이 틀리기 쉬워 판정 대신 재촬영을 안내한다 (pose_camera, 2026-11-26).
- 좌표는 저장하지 않고, 로그에는 운동·반복 수·처리 시간·모델 버전만 남긴다 (PRD NFR-SEC-05).
"""
import numpy as np

from mealfit_ai.errors import ServiceError
from mealfit_ai.services import pose_camera
from mealfit_ai.services import pose_preprocess as pp
from mealfit_ai.services.pose_feedback import feedback
from mealfit_ai.services.posture_features_v2 import extract_sequence_features

MIN_FRAMES = 16          # 학습 샘플의 최소 프레임 수와 같다
MIN_PERSON_RATIO = 0.5   # 사람이 잡힌 프레임이 절반도 안 되면 다시 촬영
NOTICE = '운동 종류와 촬영 각도에 따라 정확도에 차이가 있을 수 있어요. 판정은 참고용이며 의학적 진단이 아니에요.'
RETAKE_NO_PERSON = 'POSE_NO_PERSON'
RETAKE_TOO_FEW_FRAMES = 'POSE_TOO_FEW_FRAMES'
RETAKE_CAMERA_ANGLE = 'POSE_CAMERA_ANGLE'


def to_array(frames):
    """프레임 목록 → (T, 33, 4) 배열과 사람 검출 여부"""
    ok = np.array([f is not None for f in frames])
    arr = np.zeros((len(frames), 33, 4), np.float32)
    for i, f in enumerate(frames):
        if f is not None:
            arr[i] = f
    return arr, ok


def accuracy_of(spec, j):
    """manifest 의 조건별 정확도 (외부 평가가 있으면 외부, 없으면 교차검증). 값이 없으면 None"""
    items = spec.get('accuracy') or []
    item = items[j] if j < len(items) and isinstance(items[j], dict) else {}
    if item.get('external') is not None:
        return round(float(item['external']), 3), 'EXTERNAL'
    if item.get('cv') is not None:
        return round(float(item['cv']), 3), 'CV'
    return None, None


def retake(exercise, version, code):
    return {'exercise': exercise, 'status': 'RETAKE', 'retakeCode': code, 'modelVersion': version,
            'repCount': 0, 'reps': [], 'conditions': [], 'notice': NOTICE}


def model_input(kind, frames, ok, reps):
    if kind == 'choi_features':  # 최원석 v2: 구간 원본 프레임에서 자체 보간·32프레임·좌우 보정을 한다
        return np.stack([extract_sequence_features(frames[a:b + 1, :, :3], frames[a:b + 1, :, 3], ok[a:b + 1])
                         for a, b in reps])
    X = np.stack([pp.rep_tensor(frames, ok, a, b) for a, b in reps])
    return pp.sequences(X) if kind == 'seq' else pp.features(X)


def analyze(client, exercise, fps, frame_list, version):
    spec = client.spec(exercise)
    if spec is None:
        raise ServiceError(400, 'POSE_002', '자세 판별을 지원하지 않는 운동입니다.', 'exercise')
    frames, ok = to_array(frame_list)
    if not ok.any() or ok.mean() < MIN_PERSON_RATIO:
        return retake(exercise, version, RETAKE_NO_PERSON)
    if ok.sum() < MIN_FRAMES:
        return retake(exercise, version, RETAKE_TOO_FEW_FRAMES)
    if not pose_camera.in_training_range(exercise, pose_camera.camera_yaw(frames, ok)):
        return retake(exercise, version, RETAKE_CAMERA_ANGLE)
    reps = [(a, b) for a, b in pp.segment_reps(frames, ok, fps)
            if b - a + 1 >= 2 and ok[a:b + 1].mean() >= pp.MIN_OK_RATIO]
    if not reps:
        return retake(exercise, version, RETAKE_TOO_FEW_FRAMES)
    probs = np.asarray(client.predict(exercise, model_input(spec['input'], frames, ok, reps)), np.float64)
    names = spec['conditions']
    if probs.shape != (len(reps), len(names)) or not np.isfinite(probs).all():
        raise ServiceError(500, 'POSE_004', '자세 판별 결과를 만들지 못했습니다.')
    correct = probs >= 0.5
    rep_items = [{'index': i + 1, 'startFrame': int(a), 'endFrame': int(b),
                  'conditions': [{'name': n, 'probability': round(float(probs[i, j]), 4), 'correct': bool(correct[i, j])}
                                 for j, n in enumerate(names)]}
                 for i, (a, b) in enumerate(reps)]
    conditions = []
    for j, n in enumerate(names):
        good = int(correct[:, j].sum())
        acc, basis = accuracy_of(spec, j)
        conditions.append({'name': n, 'correctReps': good, 'totalReps': len(reps), 'accuracy': acc,
                           'accuracyBasis': basis, 'feedback': feedback(n, good, len(reps))})
    return {'exercise': exercise, 'status': 'OK', 'retakeCode': None, 'modelVersion': version,
            'repCount': len(reps), 'reps': rep_items, 'conditions': conditions, 'notice': NOTICE}
