"""Shared 3D pose sequence preprocessing and feature extraction (v2).

Used identically by both offline training (`ml/train_posture_v2.py`) and
online inference (`services/posture_service.py`) to avoid train/serve skew.

MealFit: 최원석 v2 모델(스텝 포워드 다이나믹 런지, 바이시클 크런치)의 특징 추출 코드를
작성자 동의(2026-11-24)를 받아 그대로 복사했다. 모델이 이 계산으로 학습됐으므로 본문을 고치지 않는다.
"""

from __future__ import annotations

import numpy as np

TARGET_FRAMES = 32

KEY_JOINTS = [
    ("nose", 0),
    ("l_shoulder", 11),
    ("r_shoulder", 12),
    ("l_elbow", 13),
    ("r_elbow", 14),
    ("l_wrist", 15),
    ("r_wrist", 16),
    ("l_hip", 23),
    ("r_hip", 24),
    ("l_knee", 25),
    ("r_knee", 26),
    ("l_ankle", 27),
    ("r_ankle", 28),
]

LR_SWAP_PAIRS = [
    (1, 4), (2, 5), (3, 6),       # eyes
    (7, 8), (9, 10),              # ears, mouth
    (11, 12), (13, 14), (15, 16), # arms
    (17, 18), (19, 20), (21, 22), # hands
    (23, 24), (25, 26), (27, 28), # legs
    (29, 30), (31, 32),           # feet
]
LR_LEFT_IDX = np.array([p[0] for p in LR_SWAP_PAIRS], dtype=np.int32)
LR_RIGHT_IDX = np.array([p[1] for p in LR_SWAP_PAIRS], dtype=np.int32)
LIMB_TRACK_LEFT = np.array([11, 13, 15, 23, 25, 27], dtype=np.int32)
LIMB_TRACK_RIGHT = np.array([12, 14, 16, 24, 26, 28], dtype=np.int32)


def _interpolate_missing_frames(
    world: np.ndarray,
    vis: np.ndarray,
    ok: np.ndarray,
) -> tuple[np.ndarray, np.ndarray]:
    """Fill ok=False frames by linear interpolation (edge-clamped) across time."""
    n = len(ok)
    if n == 0:
        return world, vis
    valid_idx = np.flatnonzero(ok)
    if len(valid_idx) == 0:
        return np.zeros_like(world), np.zeros_like(vis)
    if len(valid_idx) == n:
        return world.copy(), vis.copy()

    t_all = np.arange(n, dtype=np.float32)
    out_w = world.copy()
    out_v = vis.copy()
    bad_mask = ~ok

    for j in range(world.shape[1]):
        for c in range(3):
            out_w[bad_mask, j, c] = np.interp(
                t_all[bad_mask], valid_idx.astype(np.float32), world[valid_idx, j, c]
            )
        out_v[bad_mask, j] = np.interp(
            t_all[bad_mask], valid_idx.astype(np.float32), vis[valid_idx, j]
        )
    return out_w, out_v


def _resample_sequence(arr: np.ndarray, target_len: int = TARGET_FRAMES) -> np.ndarray:
    """Resample (T, ...) array along axis 0 to fixed `target_len` via linear interpolation."""
    t_len = arr.shape[0]
    if t_len == target_len:
        return arr
    if t_len == 1:
        return np.repeat(arr, target_len, axis=0)

    src_x = np.linspace(0.0, 1.0, t_len, dtype=np.float32)
    dst_x = np.linspace(0.0, 1.0, target_len, dtype=np.float32)
    flat = arr.reshape(t_len, -1)
    out = np.empty((target_len, flat.shape[1]), dtype=np.float32)
    for col in range(flat.shape[1]):
        out[:, col] = np.interp(dst_x, src_x, flat[:, col])
    return out.reshape((target_len, *arr.shape[1:]))


def _fix_lr_flips(world: np.ndarray, vis: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    """Undo frame-to-frame left/right landmark swaps common in floor poses."""
    if len(world) < 2:
        return world, vis

    w = world.copy()
    v = vis.copy()
    for t in range(1, len(w)):
        prev_l = w[t - 1, LIMB_TRACK_LEFT]
        prev_r = w[t - 1, LIMB_TRACK_RIGHT]
        curr_l = w[t, LIMB_TRACK_LEFT]
        curr_r = w[t, LIMB_TRACK_RIGHT]

        keep_cost = np.linalg.norm(curr_l - prev_l, axis=1).sum() + np.linalg.norm(curr_r - prev_r, axis=1).sum()
        swap_cost = np.linalg.norm(curr_r - prev_l, axis=1).sum() + np.linalg.norm(curr_l - prev_r, axis=1).sum()
        if swap_cost < keep_cost * 0.85:
            tmp_w = w[t, LR_LEFT_IDX].copy()
            w[t, LR_LEFT_IDX] = w[t, LR_RIGHT_IDX]
            w[t, LR_RIGHT_IDX] = tmp_w

            tmp_v = v[t, LR_LEFT_IDX].copy()
            v[t, LR_LEFT_IDX] = v[t, LR_RIGHT_IDX]
            v[t, LR_RIGHT_IDX] = tmp_v
    return w, v


def _normalize_pose_sequence(world: np.ndarray) -> np.ndarray:
    """Center at pelvis midpoint, scale by median torso length, and yaw-align to +x."""
    hip_mid = 0.5 * (world[:, 23, :] + world[:, 24, :])
    centered = world - hip_mid[:, None, :]

    shoulder_mid = 0.5 * (centered[:, 11, :] + centered[:, 12, :])
    torso_len = np.linalg.norm(shoulder_mid, axis=1)
    scale = float(np.median(torso_len))
    if scale < 0.1:
        scale = 0.5
    scaled = centered / scale

    # Yaw alignment: rotate around Y so clip-median (left->right) hip/shoulder vector points along +X.
    lr_hip = scaled[:, 24, :] - scaled[:, 23, :]
    lr_sh = scaled[:, 12, :] - scaled[:, 11, :]
    lr_vec = np.median(0.5 * (lr_hip + lr_sh), axis=0)
    horiz_norm = float(np.hypot(lr_vec[0], lr_vec[2]))
    if horiz_norm > 1e-4:
        # Rotate (x, z) by -theta around Y so (x', z') has z' ~ 0 and x' > 0.
        cos_a = float(lr_vec[0] / horiz_norm)
        sin_a = float(lr_vec[2] / horiz_norm)
        x = scaled[:, :, 0].copy()
        z = scaled[:, :, 2].copy()
        scaled[:, :, 0] = cos_a * x + sin_a * z
        scaled[:, :, 2] = -sin_a * x + cos_a * z

    return scaled.astype(np.float32)


def _angle_3d_seq(a: np.ndarray, b: np.ndarray, c: np.ndarray) -> np.ndarray:
    """Compute angle ABC in degrees for shape (T, 3) sequences."""
    ba = a - b
    bc = c - b
    norm_ba = np.linalg.norm(ba, axis=1)
    norm_bc = np.linalg.norm(bc, axis=1)
    denom = np.maximum(norm_ba * norm_bc, 1e-6)
    cos_val = np.clip(np.sum(ba * bc, axis=1) / denom, -1.0, 1.0)
    return np.degrees(np.arccos(cos_val)).astype(np.float32)


def _torso_lean_seq(norm_w: np.ndarray) -> np.ndarray:
    """Angle in degrees between pelvis->shoulder vector and vertical up (0, -1, 0)."""
    sh_mid = 0.5 * (norm_w[:, 11, :] + norm_w[:, 12, :])
    hip_mid = 0.5 * (norm_w[:, 23, :] + norm_w[:, 24, :])
    vec = sh_mid - hip_mid
    norm = np.maximum(np.linalg.norm(vec, axis=1), 1e-6)
    # In MediaPipe world coords, -Y is up.
    cos_val = np.clip(-vec[:, 1] / norm, -1.0, 1.0)
    return np.degrees(np.arccos(cos_val)).astype(np.float32)


def get_feature_names() -> list[str]:
    """Return deterministic ordered list of v2 clip feature names."""
    names: list[str] = []
    for jname, _ in KEY_JOINTS:
        for axis in ("x", "y", "z"):
            for stat in ("min", "max", "mean", "std", "range"):
                names.append(f"pos_{jname}_{axis}_{stat}")

    angle_names = [
        "l_knee", "r_knee", "l_hip", "r_hip", "l_elbow", "r_elbow",
        "l_sh_abd", "r_sh_abd", "torso_lean",
        "knee_sym", "hip_sym", "elbow_sym",
    ]
    for aname in angle_names:
        for stat in ("min", "max", "mean", "std", "range"):
            names.append(f"ang_{aname}_{stat}")

    for jname, _ in KEY_JOINTS[1:]:  # 12 body joints (exclude nose)
        for stat in ("mean", "max", "std"):
            names.append(f"vel_{jname}_{stat}")

    for jname, _ in KEY_JOINTS:
        names.append(f"vis_{jname}_mean")
        names.append(f"vis_{jname}_min")

    return names


FEATURE_NAMES_V2 = get_feature_names()


def extract_sequence_features(
    world: np.ndarray,
    vis: np.ndarray,
    ok: np.ndarray,
) -> np.ndarray:
    """Preprocess a raw (T, 33, 3) sequence and return 1D float32 feature vector."""
    w_interp, v_interp = _interpolate_missing_frames(world, vis, ok)
    w_res = _resample_sequence(w_interp, TARGET_FRAMES)
    v_res = _resample_sequence(v_interp, TARGET_FRAMES)
    w_fixed, v_fixed = _fix_lr_flips(w_res, v_res)
    w_norm = _normalize_pose_sequence(w_fixed)

    feats: list[float] = []

    # 1. Normalized joint coordinates (13 * 3 * 5 = 195)
    for _, idx in KEY_JOINTS:
        coords = w_norm[:, idx, :]  # (32, 3)
        cmin = np.min(coords, axis=0)
        cmax = np.max(coords, axis=0)
        cmean = np.mean(coords, axis=0)
        cstd = np.std(coords, axis=0)
        crange = cmax - cmin
        for axis in range(3):
            feats.extend((
                float(cmin[axis]),
                float(cmax[axis]),
                float(cmean[axis]),
                float(cstd[axis]),
                float(crange[axis]),
            ))

    # 2. Joint angles + symmetries (12 * 5 = 60)
    l_knee = _angle_3d_seq(w_norm[:, 23], w_norm[:, 25], w_norm[:, 27])
    r_knee = _angle_3d_seq(w_norm[:, 24], w_norm[:, 26], w_norm[:, 28])
    l_hip = _angle_3d_seq(w_norm[:, 11], w_norm[:, 23], w_norm[:, 25])
    r_hip = _angle_3d_seq(w_norm[:, 12], w_norm[:, 24], w_norm[:, 26])
    l_elbow = _angle_3d_seq(w_norm[:, 11], w_norm[:, 13], w_norm[:, 15])
    r_elbow = _angle_3d_seq(w_norm[:, 12], w_norm[:, 14], w_norm[:, 16])
    l_sh_abd = _angle_3d_seq(w_norm[:, 23], w_norm[:, 11], w_norm[:, 13])
    r_sh_abd = _angle_3d_seq(w_norm[:, 24], w_norm[:, 12], w_norm[:, 14])
    torso_lean = _torso_lean_seq(w_norm)
    knee_sym = np.abs(l_knee - r_knee)
    hip_sym = np.abs(l_hip - r_hip)
    elbow_sym = np.abs(l_elbow - r_elbow)

    for seq in (
        l_knee, r_knee, l_hip, r_hip, l_elbow, r_elbow,
        l_sh_abd, r_sh_abd, torso_lean, knee_sym, hip_sym, elbow_sym,
    ):
        smin = float(np.min(seq))
        smax = float(np.max(seq))
        feats.extend((smin, smax, float(np.mean(seq)), float(np.std(seq)), smax - smin))

    # 3. Frame-to-frame joint velocities (12 * 3 = 36)
    diffs = np.linalg.norm(np.diff(w_norm, axis=0), axis=2)  # (31, 33)
    for _, idx in KEY_JOINTS[1:]:
        d = diffs[:, idx]
        feats.extend((float(np.mean(d)), float(np.max(d)), float(np.std(d))))

    # 4. Landmark visibility summary (13 * 2 = 26)
    for _, idx in KEY_JOINTS:
        vs = v_fixed[:, idx]
        feats.extend((float(np.mean(vs)), float(np.min(vs))))

    return np.asarray(feats, dtype=np.float32)
