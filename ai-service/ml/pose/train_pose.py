#!/usr/bin/env python3
r"""MediaPipe(heavy) 관절 좌표 → 운동 자세 조건 판별 학습·평가

입력: raw_extract_par.py 결과 (npz + _clips.json) 여러 개
샘플 단위: (클립, 시점) = 카메라 1대 영상 하나. 라벨은 클립의 조건값. 그룹(수행자)은 Z 코드.
전처리:
  1) 프레임 순서 정렬, 검출 실패 프레임은 앞뒤 보간 (실패 비율 25% 넘으면 샘플 제외)
  2) 좌우 바로잡기(--fix-lr): 직전 프레임과 비교해 좌우 관절을 바꾼 쪽이 더 가까우면 바꿈
  3) world 좌표(미터, 엉덩이 중심)를 골반 중심·몸통 길이로 정규화하고, 엉덩이 선이 x축이 되도록 수직축 회전
특징: 정규화 좌표 요약(평균·표준편차·범위) + 관절각 시계열 요약 + 속도 요약 (+ 시점 원-핫, 선택)
모델: logreg / hgb (조건별 이진 분류), cnn / gru (조건 전체 다중 라벨, 시드 앙상블)
평가: 수행자 단위 GroupKFold, 조건별 balanced accuracy·AUROC, 시점별 결과. --test 로 외부 평가셋 지정 가능.

사용:
  python -X utf8 -I train_pose.py --data <heavy 폴더>/body_04.npz --out <결과 폴더>/body_04 --models logreg,hgb,cnn --fix-lr [--test <heavy 폴더>/valid_body.npz]
"""
import argparse, json, os, time
from collections import defaultdict
import numpy as np

# MediaPipe 33점 인덱스
NOSE, L_SH, R_SH, L_EL, R_EL, L_WR, R_WR = 0, 11, 12, 13, 14, 15, 16
L_IDX, R_IDX, L_HIP, R_HIP, L_KN, R_KN, L_AN, R_AN = 19, 20, 23, 24, 25, 26, 27, 28
L_HEEL, R_HEEL, L_FT, R_FT, L_EAR, R_EAR = 29, 30, 31, 32, 7, 8
LR_PAIRS = [(1, 4), (2, 5), (3, 6), (7, 8), (9, 10), (11, 12), (13, 14), (15, 16), (17, 18), (19, 20),
            (21, 22), (23, 24), (25, 26), (27, 28), (29, 30), (31, 32)]
SWAP = np.arange(33)
for a, b in LR_PAIRS:
    SWAP[a], SWAP[b] = b, a
BODY = [NOSE, L_SH, R_SH, L_EL, R_EL, L_WR, R_WR, L_IDX, R_IDX, L_HIP, R_HIP, L_KN, R_KN, L_AN, R_AN, L_FT, R_FT, L_EAR, R_EAR]
ANGLES = [  # (a, b, c): b 에서의 각도
    (L_SH, L_EL, L_WR), (R_SH, R_EL, R_WR),      # 팔꿈치
    (L_EL, L_WR, L_IDX), (R_EL, R_WR, R_IDX),    # 손목 꺾임
    (L_EL, L_SH, L_HIP), (R_EL, R_SH, R_HIP),    # 어깨(팔-몸통)
    (L_SH, L_HIP, L_KN), (R_SH, R_HIP, R_KN),    # 엉덩이
    (L_HIP, L_KN, L_AN), (R_HIP, R_KN, R_AN),    # 무릎
    (L_KN, L_AN, L_FT), (R_KN, R_AN, R_FT),      # 발목
    (L_EAR, L_SH, L_HIP), (R_EAR, R_SH, R_HIP),  # 목-몸통
]


def load(paths):
    """npz 들을 (샘플, 32, 33, 4[x,y,z,vis]) world 좌표와 메타로 묶는다"""
    X, meta = [], []
    for p in paths:
        z = np.load(p)
        clips = json.load(open(os.path.splitext(p)[0] + "_clips.json", encoding="utf-8"))
        tag = os.path.basename(os.path.splitext(p)[0])
        clip, view, frame, ok, world, img = z["clip"], z["view"], z["frame"], z["ok"], z["world"], z["img"]
        order = np.lexsort((frame, view, clip))
        clip, view, frame, ok, world, img = clip[order], view[order], frame[order], ok[order], world[order], img[order]
        key = clip * 5 + view
        starts = np.r_[0, np.where(np.diff(key) != 0)[0] + 1, len(key)]
        for s, e in zip(starts[:-1], starts[1:]):
            n = e - s
            if n < 16:
                continue
            arr = np.concatenate([world[s:e], img[s:e, :, 3:4]], axis=2)  # x,y,z,visibility
            good = ok[s:e]
            if good.mean() < 0.75:
                continue
            idx = np.arange(n)
            for j in range(33):  # 실패 프레임 보간
                for c in range(4):
                    v = arr[:, j, c]
                    if (~good).any():
                        arr[~good, j, c] = np.interp(idx[~good], idx[good], v[good])
            T = 32
            if n != T:  # 프레임 수를 32로 맞춤
                src = np.linspace(0, n - 1, T)
                arr = np.stack([np.stack([np.interp(src, idx, arr[:, j, c]) for c in range(4)], -1) for j in range(33)], 1)
            c = int(clip[s])
            m = clips[c]
            meta.append(dict(src=tag, clip=c, view=int(view[s]), exercise=m["exercise"], z=m["z"] or f"?{tag}{c}",
                             names=m["names"], vals=m["vals"]))
            X.append(arr.astype(np.float32))
    return np.stack(X), meta


def fix_lr(X):
    """직전 프레임 기준 좌우 연속성 보정 (시퀀스마다)"""
    X = X.copy()
    n_fix = 0
    for i in range(len(X)):
        for t in range(1, X.shape[1]):
            cur, prev = X[i, t, :, :3], X[i, t - 1, :, :3]
            d0 = np.linalg.norm(cur[BODY] - prev[BODY], axis=1).sum()
            d1 = np.linalg.norm(cur[SWAP][BODY] - prev[BODY], axis=1).sum()
            if d1 < 0.7 * d0:
                X[i, t] = X[i, t][SWAP]
                n_fix += 1
    return X, n_fix


def normalize(X):
    P = X[..., :3].astype(np.float64)
    hip = (P[:, :, L_HIP] + P[:, :, R_HIP]) / 2
    sh = (P[:, :, L_SH] + P[:, :, R_SH]) / 2
    P = P - hip[:, :, None]
    torso = np.linalg.norm(sh - hip, axis=2).mean(1)[:, None, None, None] + 1e-6
    P = P / torso
    # 수직축(y) 기준 회전: 클립 평균 엉덩이 선(R→L)을 +x 로
    hv = (P[:, :, L_HIP] - P[:, :, R_HIP]).mean(1)
    ang = np.arctan2(hv[:, 2], hv[:, 0])
    c, s = np.cos(-ang), np.sin(-ang)
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
    return np.stack(out, -1)  # (N, T, A)


def summarize(S):
    return np.concatenate([S.mean(1), S.std(1), S.max(1) - S.min(1), S.min(1), S.max(1)], 1)


def features(X, views=None, use_view=False):
    P = normalize(X)
    coords = P[:, :, BODY].reshape(len(P), P.shape[1], -1)
    A = angle_series(P)
    vel = np.linalg.norm(np.diff(P[:, :, BODY], axis=1), axis=-1)
    vis = X[:, :, BODY, 3]
    F = [summarize(coords), summarize(A), np.concatenate([vel.mean(1), vel.max(1)], 1), vis.mean(1)]
    if use_view and views is not None:
        F.append(np.eye(5)[views])
    return np.concatenate(F, 1).astype(np.float32)


def sequences(X):
    """시퀀스 모델 입력: 프레임별 정규화 좌표 + 관절각 (N, T, F)"""
    P = normalize(X)
    coords = P[:, :, BODY].reshape(len(P), P.shape[1], -1)
    A = angle_series(P) / 180.0
    return np.concatenate([coords, A], -1).astype(np.float32)


def fit_predict_seq(kind, Str, Ytr, groups_tr, Ste, seeds=(0, 100, 200)):
    """DL_Project 와 같은 구조의 1D-CNN / GRU (다중 라벨, 수행자 15% 검증 조기 종료), 시드 앙상블 확률 평균"""
    import tensorflow as tf
    from tensorflow import keras
    from keras import layers
    mu, sd = Str.reshape(-1, Str.shape[-1]).mean(0), Str.reshape(-1, Str.shape[-1]).std(0) + 1e-6
    A, B = (Str - mu) / sd, (Ste - mu) / sd
    ug = np.unique(groups_tr)
    probs = []
    for seed in seeds:
        rng = np.random.default_rng(seed)
        val_g = rng.choice(ug, max(1, int(round(len(ug) * 0.15))), replace=False)
        vm = np.isin(groups_tr, val_g)
        keras.utils.set_random_seed(seed)
        inp = keras.Input(A.shape[1:])
        x = layers.GaussianNoise(0.05)(inp)
        if kind == "cnn":
            for _ in range(2):
                x = layers.Conv1D(64, 3, padding="same")(x); x = layers.BatchNormalization()(x); x = layers.ReLU()(x)
            x = layers.Concatenate()([layers.GlobalAveragePooling1D()(x), layers.GlobalMaxPooling1D()(x)])
        else:
            x = layers.GRU(64)(x)
        x = layers.Dropout(0.3)(x)
        out = layers.Dense(Ytr.shape[1], activation="sigmoid")(x)
        m = keras.Model(inp, out)
        m.compile(keras.optimizers.Adam(1e-3), "binary_crossentropy")
        m.fit(A[~vm], Ytr[~vm], validation_data=(A[vm], Ytr[vm]), epochs=150, batch_size=32, verbose=0,
              callbacks=[keras.callbacks.EarlyStopping(patience=15, restore_best_weights=True)])
        probs.append(m.predict(B, verbose=0))
        keras.backend.clear_session()
    return np.mean(probs, 0)


def make_model(name, seed=0):
    from sklearn.pipeline import make_pipeline
    from sklearn.preprocessing import StandardScaler
    if name == "logreg":
        from sklearn.linear_model import LogisticRegression
        return make_pipeline(StandardScaler(), LogisticRegression(C=0.1, max_iter=3000, class_weight="balanced"))
    if name == "hgb":
        from sklearn.ensemble import HistGradientBoostingClassifier
        return HistGradientBoostingClassifier(max_iter=300, learning_rate=0.05, max_leaf_nodes=15,
                                              l2_regularization=1.0, class_weight="balanced", random_state=seed)
    raise ValueError(name)


def evaluate(a):
    from sklearn.metrics import balanced_accuracy_score, roc_auc_score
    from sklearn.model_selection import GroupKFold
    t0 = time.time()
    X, meta = load(a.data.split(","))
    print(f"학습 샘플(클립×시점) {len(X)}개, 불러오기 {time.time()-t0:.0f}초", flush=True)
    Xt, mt = (load(a.test.split(",")) if a.test else (None, None))
    if a.fix_lr:
        X, n = fix_lr(X); print(f"좌우 보정 프레임 {n}개 ({n/(X.shape[0]*X.shape[1])*100:.2f}%)", flush=True)
        if Xt is not None:
            Xt, n2 = fix_lr(Xt); print(f"외부 평가셋 좌우 보정 {n2}개", flush=True)
    views = np.array([m["view"] for m in meta])
    F = features(X, views, a.use_view)
    Ft = features(Xt, np.array([m["view"] for m in mt]), a.use_view) if Xt is not None else None
    ex = np.array([m["exercise"] for m in meta]); Z = np.array([m["z"] for m in meta])
    rows, oof_rows = [], []
    si, sn = (int(v) for v in a.shard.split("/"))
    ex_list = sorted(set(ex))
    if a.exercises:
        keep = set(a.exercises.split(","))
        ex_list = [e for e in ex_list if e in keep]
    for ei, e in enumerate(ex_list):
        if ei % sn != si:
            continue
        idx = np.where(ex == e)[0]
        names = meta[idx[0]]["names"]
        Y = np.array([meta[i]["vals"] for i in idx])
        groups = Z[idx]
        ng = len(set(groups))
        k = min(a.folds, ng)
        if k < 2:
            print(f"  {e}: 수행자 {ng}명이라 건너뜀"); continue
        for mname in a.models.split(","):
            P = np.full(Y.shape, np.nan)
            for tr, te in GroupKFold(k).split(F[idx], groups=groups):
                if mname in ("cnn", "gru"):
                    S = sequences(X[idx])
                    P[te] = fit_predict_seq(mname, S[tr], Y[tr].astype(np.float32), groups[tr], S[te],
                                            seeds=tuple(range(0, 100 * a.seeds, 100)))
                    continue
                for j in range(len(names)):
                    if len(set(Y[tr, j])) < 2:
                        P[te, j] = Y[tr, j].mean(); continue
                    mdl = make_model(mname).fit(F[idx][tr], Y[tr, j])
                    P[te, j] = mdl.predict_proba(F[idx][te])[:, 1]
            for j, cn in enumerate(names):
                y, p = Y[:, j], P[:, j]
                auc = roc_auc_score(y, p) if len(set(y)) > 1 else np.nan
                rows.append(dict(exercise=e, condition=cn, model=mname, split="cv", samples=len(y), performers=ng,
                                 bal_acc=balanced_accuracy_score(y, p >= 0.5), auroc=auc))
                for v in range(5):
                    mv = views[idx] == v
                    if mv.sum() and len(set(y[mv])) > 1:
                        rows.append(dict(exercise=e, condition=cn, model=mname, split=f"cv_view{'ABCDE'[v]}", samples=int(mv.sum()),
                                         performers=ng, bal_acc=balanced_accuracy_score(y[mv], p[mv] >= 0.5), auroc=roc_auc_score(y[mv], p[mv])))
            # 외부 평가셋: 같은 운동이면 전체 학습 후 평가 (시퀀스 모델은 아래 별도 처리)
            if Ft is not None and mname in ("cnn", "gru"):
                tid = [i for i, m in enumerate(mt) if m["exercise"] == e]
                if tid:
                    Yt = np.array([mt[i]["vals"] for i in tid])
                    Pt = fit_predict_seq(mname, sequences(X[idx]), Y.astype(np.float32), groups, sequences(Xt[tid]),
                                         seeds=tuple(range(0, 100 * a.seeds, 100)))
                    for j, cn in enumerate(names):
                        rows.append(dict(exercise=e, condition=cn, model=mname, split="external", samples=len(tid),
                                         performers=len({mt[i]['z'] for i in tid}), bal_acc=balanced_accuracy_score(Yt[:, j], Pt[:, j] >= 0.5),
                                         auroc=roc_auc_score(Yt[:, j], Pt[:, j]) if len(set(Yt[:, j])) > 1 else np.nan))
            elif Ft is not None:
                tid = [i for i, m in enumerate(mt) if m["exercise"] == e]
                if tid:
                    Yt = np.array([mt[i]["vals"] for i in tid])
                    for j, cn in enumerate(names):
                        if len(set(Y[:, j])) < 2:
                            pt = np.full(len(tid), float(Y[:, j].mean()))
                        else:
                            pt = make_model(mname).fit(F[idx], Y[:, j]).predict_proba(Ft[tid])[:, 1]
                        rows.append(dict(exercise=e, condition=cn, model=mname, split="external", samples=len(tid),
                                         performers=len({mt[i]['z'] for i in tid}), bal_acc=balanced_accuracy_score(Yt[:, j], pt >= 0.5),
                                         auroc=roc_auc_score(Yt[:, j], pt) if len(set(Yt[:, j])) > 1 else np.nan))
        cv = [r for r in rows if r["exercise"] == e and r["split"] == "cv"]
        print(f"  {e}: 샘플 {len(idx)}, 수행자 {ng}명, " + ", ".join(
            f"{m} {np.mean([r['bal_acc'] for r in cv if r['model'] == m]):.3f}" for m in a.models.split(",")), flush=True)
    import pandas as pd
    R = pd.DataFrame(rows)
    os.makedirs(os.path.dirname(a.out) or ".", exist_ok=True)
    R.to_csv(a.out + "_metrics.csv", index=False, encoding="utf-8-sig")
    s = R.groupby(["split", "model"]).bal_acc.mean().unstack().round(3)
    print("\n평균 balanced accuracy (조건 평균)\n" + s.to_string())
    print(f"\n저장: {a.out}_metrics.csv  ({(time.time()-t0)/60:.1f}분)")


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--data", required=True, help="학습 npz 목록(쉼표)")
    ap.add_argument("--test", help="외부 평가 npz 목록(쉼표)")
    ap.add_argument("--out", required=True)
    ap.add_argument("--models", default="logreg,hgb")
    ap.add_argument("--folds", type=int, default=5)
    ap.add_argument("--fix-lr", action="store_true")
    ap.add_argument("--use-view", action="store_true")
    ap.add_argument("--seeds", type=int, default=3, help="시퀀스 모델 시드 앙상블 개수")
    ap.add_argument("--exercises", default="", help="이 운동만 학습(쉼표). 비우면 전부")
    ap.add_argument("--shard", default="0/1", help="운동 나눠 돌리기 i/n (정렬된 운동 목록에서 i번째 몫만)")
    evaluate(ap.parse_args())
