"""자세 판별 테스트용 가짜 관절 좌표와 가짜 모델 폴더 (실제 모델·영상 없이 검증)."""
import json
import math
import os

import numpy as np

# 서 있는 사람의 대략적인 MediaPipe world 좌표 (미터, 골반 중심, y 는 아래가 +)
BASE = np.zeros((33, 3))
for idx, xyz in {0: (0, -0.62, -0.05), 7: (0.07, -0.6, 0), 8: (-0.07, -0.6, 0),
                 11: (0.18, -0.45, 0), 12: (-0.18, -0.45, 0), 13: (0.2, -0.2, 0), 14: (-0.2, -0.2, 0),
                 15: (0.2, 0.02, 0), 16: (-0.2, 0.02, 0), 19: (0.2, 0.08, 0), 20: (-0.2, 0.08, 0),
                 23: (0.1, 0, 0), 24: (-0.1, 0, 0), 25: (0.1, 0.42, 0), 26: (-0.1, 0.42, 0),
                 27: (0.1, 0.82, 0), 28: (-0.1, 0.82, 0), 31: (0.1, 0.86, -0.1), 32: (-0.1, 0.86, -0.1)}.items():
    BASE[idx] = xyz
for j in range(33):  # 나머지 관절은 가까운 관절 근처에 둔다
    if j and not BASE[j].any():
        BASE[j] = BASE[0] if j < 11 else BASE[15 if j % 2 else 16]


def front_raise(seconds=6.0, fps=15, cycles=3, noise=0.003, seed=0):
    """팔을 앞으로 들었다 내리는 동작. 팔을 내린 시작 자세에서 출발해 cycles 번 반복한다 → (T, 33, 4)"""
    rng = np.random.default_rng(seed)
    n = int(seconds * fps)
    out = np.zeros((n, 33, 4))
    for t in range(n):
        lift = (1 - math.cos(2 * math.pi * cycles * t / n)) / 2 * math.radians(90)
        P = BASE.copy()
        for sh, joints in ((11, (13, 15, 17, 19, 21)), (12, (14, 16, 18, 20, 22))):
            for j in joints:  # 어깨 기준으로 팔을 x 축 둘레로 회전 (앞으로 들기)
                v = BASE[j] - BASE[sh]
                y = v[1] * math.cos(lift) - v[2] * math.sin(lift)
                z = v[1] * math.sin(lift) + v[2] * math.cos(lift)
                P[j] = BASE[sh] + (v[0], y, -abs(z))
        out[t, :, :3] = P + rng.normal(0, noise, P.shape)
        out[t, :, 3] = 0.95
    return out


def hold(seconds=5.0, fps=15, noise=0.003, seed=1):
    """거의 움직이지 않는 자세 (버티기 운동)"""
    rng = np.random.default_rng(seed)
    n = int(seconds * fps)
    out = np.zeros((n, 33, 4))
    out[:, :, :3] = BASE + rng.normal(0, noise, (n, 33, 3))
    out[:, :, 3] = 0.9
    return out


def to_frames(arr, missing=()):
    return [None if i in missing else [[round(float(v), 4) for v in p] for p in f] for i, f in enumerate(arr)]


def write_json(path, data):
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False)


def write_logreg_model_dir(root, exercise='프런트 레이즈', conditions=('팔꿈치 고정', '어깨 으쓱 없음'), accuracy=None):
    """LogReg 계수 JSON만 있는 가짜 모델 폴더 (onnxruntime 없이 전체 흐름을 검증)"""
    d = os.path.join(root, 'ex99')
    os.makedirs(d)
    rng = np.random.default_rng(7)
    files = []
    for j in range(len(conditions)):
        write_json(os.path.join(d, f'logreg_c{j}.json'), {'mean': [0.0] * 427, 'scale': [1.0] * 427,
                                                           'coef': rng.normal(0, 1e-5, 427).tolist(),
                                                           'intercept': 0.4 - 0.8 * j})
        files.append(f'logreg_c{j}.joblib')
    entry = {'dir': 'ex99', 'model': 'logreg', 'conditions': list(conditions), 'files': files}
    if accuracy is not None:
        entry['accuracy'] = accuracy
    manifest = {exercise: entry, '_replaced': {'옛 모델': {'dir': 'old'}}}
    write_json(os.path.join(root, 'manifest.json'), manifest)
    return root
