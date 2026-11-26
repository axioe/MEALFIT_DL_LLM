"""운동 자세 판별 촬영 방향 검사 (FR-WORK-05).

학습 데이터(AI Hub 「피트니스 자세 이미지」)에 없는 방향에서 찍은 영상은 판정이 틀리기 쉬워서
판정 대신 재촬영을 안내한다 (2026-11-26 휴대폰 시연 영상 분석: 학습 방향 밖 풀업은 판정이 반대로 나옴).

촬영 방향(yaw): 카메라 기준 엉덩이 선(오른쪽 → 왼쪽 엉덩이) world 좌표의 수평 각도 atan2(z, x).
학습 범위는 ml/pose/camera_ranges.py 가 만든 pose_camera_ranges.json (운동 → 시점별 중심·5~95% 범위)이다.
"""
import json
import os

import numpy as np

L_HIP, R_HIP = 23, 24
MARGIN_DEG = 10.0  # 학습 범위 밖으로 이만큼까지는 허용한다
RANGES_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'pose_camera_ranges.json')
_ranges = None


def ranges():
    """운동 → 시점 → {center, lo, hi}. 파일을 한 번만 읽는다"""
    global _ranges
    if _ranges is None:
        with open(RANGES_PATH, encoding='utf-8') as f:
            _ranges = json.load(f)['exercises']
    return _ranges


def camera_yaw(frames, ok):
    """사람이 잡힌 프레임의 촬영 방향 원형 평균(도). 계산할 수 없으면 None"""
    if not ok.any():
        return None
    hip = frames[ok, L_HIP, :3] - frames[ok, R_HIP, :3]
    ang = np.arctan2(hip[:, 2], hip[:, 0])
    s, c = np.sin(ang).mean(), np.cos(ang).mean()
    if np.hypot(s, c) < 1e-6:
        return None
    return float(np.degrees(np.arctan2(s, c)))


def in_training_range(exercise, yaw):
    """학습 데이터에 있는 촬영 방향인가. 범위 정보가 없는 운동이나 방향을 못 구한 경우는 검사하지 않는다(True)"""
    views = ranges().get(exercise)
    if not views or yaw is None:
        return True
    for v in views.values():
        d = (yaw - v['center'] + 180) % 360 - 180
        if v['lo'] - MARGIN_DEG <= d <= v['hi'] + MARGIN_DEG:
            return True
    return False
