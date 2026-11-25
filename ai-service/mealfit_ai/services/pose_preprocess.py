"""운동 자세 판별 전처리: 관절 좌표 → 반복 구간 → 모델 입력.

학습 코드(MealFit_pose/train_pose.py: load·fix_lr·normalize·angle_series·features·sequences)와
같은 계산을 그대로 옮겼다. 학습과 달라지면 예측이 틀어지므로, 이 파일을 고치면
학습 환경 예측과의 차이(1e-4 이하)를 다시 확인한다 (ml/pose 비교 스크립트).

입력 좌표: 브라우저 MediaPipe Pose Landmarker(heavy)의 프레임별 world 좌표 33개 (x, y, z, visibility).
"""
import numpy as np

# MediaPipe 33점 인덱스
NOSE, L_SH, R_SH, L_EL, R_EL, L_WR, R_WR = 0, 11, 12, 13, 14, 15, 16
L_IDX, R_IDX, L_HIP, R_HIP, L_KN, R_KN, L_AN, R_AN = 19, 20, 23, 24, 25, 26, 27, 28
L_FT, R_FT, L_EAR, R_EAR = 31, 32, 7, 8
LR_PAIRS = [(1, 4), (2, 5), (3, 6), (7, 8), (9, 10), (11, 12), (13, 14), (15, 16), (17, 18), (19, 20),
            (21, 22), (23, 24), (25, 26), (27, 28), (29, 30), (31, 32)]
SWAP = np.arange(33)
for _a, _b in LR_PAIRS:
    SWAP[_a], SWAP[_b] = _b, _a
BODY = [NOSE, L_SH, R_SH, L_EL, R_EL, L_WR, R_WR, L_IDX, R_IDX, L_HIP, R_HIP, L_KN, R_KN, L_AN, R_AN, L_FT, R_FT,
        L_EAR, R_EAR]
ANGLES = [  # (a, b, c): b 에서의 각도
    (L_SH, L_EL, L_WR), (R_SH, R_EL, R_WR),      # 팔꿈치
    (L_EL, L_WR, L_IDX), (R_EL, R_WR, R_IDX),    # 손목 꺾임
    (L_EL, L_SH, L_HIP), (R_EL, R_SH, R_HIP),    # 어깨(팔-몸통)
    (L_SH, L_HIP, L_KN), (R_SH, R_HIP, R_KN),    # 엉덩이
    (L_HIP, L_KN, L_AN), (R_HIP, R_KN, R_AN),    # 무릎
    (L_KN, L_AN, L_FT), (R_KN, R_AN, R_FT),      # 발목
    (L_EAR, L_SH, L_HIP), (R_EAR, R_SH, R_HIP),  # 목-몸통
]

T = 32                   # 학습 샘플 프레임 수 (AI Hub 클립 1개 = 반복 1회, 32프레임)
MIN_OK_RATIO = 0.75      # 학습과 같은 기준: 사람이 잡힌 프레임이 75% 미만인 구간은 판정하지 않는다
MAX_REPS = 30
REP_MIN_SECONDS = 0.7    # 반복 1회의 최소 길이
STATIC_RANGE = 0.5       # 움직임 신호 폭이 이보다 작으면 버티기 운동처럼 보고 전체를 1회로 판정
HIGH, LOW = 0.65, 0.35   # 반복 분할 히스테리시스 (신호 폭 대비)


def interpolate(arr, ok):
    """사람을 못 찾은 프레임을 앞뒤 프레임으로 선형 보간 (train_pose.load 와 같은 방식, 양 끝은 가장 가까운 값)"""
    arr = arr.astype(np.float32).copy()
    if ok.all():
        return arr
    idx = np.arange(len(arr))
    for j in range(arr.shape[1]):
        for c in range(arr.shape[2]):
            arr[~ok, j, c] = np.interp(idx[~ok], idx[ok], arr[ok, j, c])
    return arr


def resample(arr):
    """프레임 수를 32로 맞춘다 (train_pose.load 와 같은 선형 보간)"""
    n = len(arr)
    if n == T:
        return arr.astype(np.float32)
    idx = np.arange(n)
    src = np.linspace(0, n - 1, T)
    return np.stack([np.stack([np.interp(src, idx, arr[:, j, c]) for c in range(arr.shape[2])], -1)
                     for j in range(arr.shape[1])], 1).astype(np.float32)


def fix_lr(X):
    """직전 프레임 기준 좌우 연속성 보정 (시퀀스마다)"""
    X = X.copy()
    for i in range(len(X)):
        for t in range(1, X.shape[1]):
            cur, prev = X[i, t, :, :3], X[i, t - 1, :, :3]
            d0 = np.linalg.norm(cur[BODY] - prev[BODY], axis=1).sum()
            d1 = np.linalg.norm(cur[SWAP][BODY] - prev[BODY], axis=1).sum()
            if d1 < 0.7 * d0:
                X[i, t] = X[i, t][SWAP]
    return X


def normalize(X):
    """골반 중심·몸통 길이로 정규화하고, 클립 평균 엉덩이 선(R→L)이 +x 가 되도록 수직축 회전"""
    P = X[..., :3].astype(np.float64)
    hip = (P[:, :, L_HIP] + P[:, :, R_HIP]) / 2
    sh = (P[:, :, L_SH] + P[:, :, R_SH]) / 2
    P = P - hip[:, :, None]
    torso = np.linalg.norm(sh - hip, axis=2).mean(1)[:, None, None, None] + 1e-6
    P = P / torso
    hv = (P[:, :, L_HIP] - P[:, :, R_HIP]).mean(1)
    ang = np.arctan2(hv[:, 2], hv[:, 0])
    c, s = np.cos(-ang), np.sin(-ang)
    # 주의: x·z 는 P 의 view 라 아래 둘째 줄의 x 는 이미 바뀐 값이다 (순수 회전이 아님).
    # 학습 코드가 이렇게 계산해 모델이 이 입력으로 학습됐으므로 그대로 둔다. 고치려면 재학습이 필요하다.
    x, z = P[..., 0], P[..., 2]
    P[..., 0] = x * c[:, None, None] - z * s[:, None, None]
    P[..., 2] = x * s[:, None, None] + z * c[:, None, None]
    return P


def angle_series(P):
    out = []
    for a, b, c in ANGLES:
        v1, v2 = P[:, :, a] - P[:, :, b], P[:, :, c] - P[:, :, b]
        cos = (v1 * v2).sum(-1) / (np.linalg.norm(v1, axis=-1) * np.linalg.norm(v2, axis=-1) + 1e-9)
        out.append(np.degrees(np.arccos(np.clip(cos, -1, 1))))
    sh, hip = (P[:, :, L_SH] + P[:, :, R_SH]) / 2, (P[:, :, L_HIP] + P[:, :, R_HIP]) / 2
    trunk = sh - hip
    out.append(np.degrees(np.arctan2(np.linalg.norm(trunk[..., [0, 2]], axis=-1), trunk[..., 1])))  # 몸통 기울기
    out.append(np.linalg.norm(P[:, :, L_EAR] - P[:, :, L_SH], axis=-1))  # 어깨 으쓱(귀-어깨)
    out.append(np.linalg.norm(P[:, :, R_EAR] - P[:, :, R_SH], axis=-1))
    return np.stack(out, -1)


def summarize(S):
    return np.concatenate([S.mean(1), S.std(1), S.max(1) - S.min(1), S.min(1), S.max(1)], 1)


def features(X):
    """요약 특징 (N, 427): LogReg·HGB(유지훈) 입력"""
    P = normalize(X)
    coords = P[:, :, BODY].reshape(len(P), P.shape[1], -1)
    A = angle_series(P)
    vel = np.linalg.norm(np.diff(P[:, :, BODY], axis=1), axis=-1)
    vis = X[:, :, BODY, 3]
    F = [summarize(coords), summarize(A), np.concatenate([vel.mean(1), vel.max(1)], 1), vis.mean(1)]
    return np.concatenate(F, 1).astype(np.float32)


def sequences(X):
    """시퀀스 입력 (N, 32, 74): 1D-CNN 입력 = 프레임별 정규화 좌표 + 관절각/180"""
    P = normalize(X)
    coords = P[:, :, BODY].reshape(len(P), P.shape[1], -1)
    A = angle_series(P) / 180.0
    return np.concatenate([coords, A], -1).astype(np.float32)


def rep_tensor(frames, ok, start, end):
    """반복 구간 [start, end] → (32, 33, 4). 학습과 같이 구간 안에서 보간한 뒤 32프레임으로 맞추고 좌우를 보정한다"""
    seg, good = frames[start:end + 1], ok[start:end + 1]
    x = resample(interpolate(seg, good))
    return fix_lr(x[None])[0]


def motion_signal(frames, ok):
    """반복 분할용 1차원 움직임 신호: 정규화한 몸 관절 좌표의 제1주성분"""
    full = interpolate(frames, ok)
    P = normalize(full[None])[0][:, BODY].reshape(len(full), -1)
    Q = P - P.mean(0)
    _, _, vt = np.linalg.svd(Q, full_matrices=False)
    return Q @ vt[0]


def smooth(sig, fps):
    w = max(3, int(round(fps * 0.3)) | 1)
    pad = np.pad(sig, w // 2, mode='edge')
    return np.convolve(pad, np.ones(w) / w, mode='valid')


def segment_reps(frames, ok, fps):
    """반복 구간 목록 [(start, end), ...] (끝 프레임 포함).

    학습 클립은 반복 1회를 시작 자세 → 동작 → 시작 자세로 담고 있다. 영상도 시작 자세에서 출발한다고 보고,
    움직임 신호를 시작 자세 쪽이 위가 되게 맞춘 뒤 '위(시작 자세) → 아래 → 위' 한 바퀴를 반복 1회로 자른다.
    경계는 위쪽 구간마다 가장 높은 프레임이다. 한 바퀴도 없거나 움직임이 작으면 영상 전체를 1회로 본다.
    """
    n = len(frames)
    whole = [(0, n - 1)]
    if n < 4:
        return whole
    sig = smooth(motion_signal(frames, ok), fps)
    lo_v, hi_v = np.percentile(sig, [5, 95])
    width = hi_v - lo_v
    if width < STATIC_RANGE:
        return whole
    head = sig[:max(2, int(round(fps * 0.5)))].mean()
    if head < (lo_v + hi_v) / 2:  # 시작 자세 쪽을 위로
        sig, lo_v, hi_v = -sig, -hi_v, -lo_v
    high, low = lo_v + HIGH * width, lo_v + LOW * width
    tops, state, run = [], None, []
    for i, v in enumerate(sig):
        if v >= high:
            if state != 'high':
                state, run = 'high', []
            run.append(i)
        elif v <= low:
            if state == 'high' and run:
                tops.append(max(run, key=lambda k: sig[k]))
            state = 'low'
    if state == 'high' and run:
        tops.append(max(run, key=lambda k: sig[k]))
    min_len = max(2, int(round(fps * REP_MIN_SECONDS)))
    reps = [(a, b) for a, b in zip(tops[:-1], tops[1:]) if b - a >= min_len]
    return reps[:MAX_REPS] or whole
