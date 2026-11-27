"""배포용 최종 모델: 운동마다 교차검증 최고 모델로 학습 데이터 전체를 학습해 저장한다.
- CNN: 시드 3개 각각 .keras + 층별 가중치 npz (ONNX 수작업 변환용), 입력 정규화 mu/sd
- HGB: joblib, LogReg: 계수 JSON (StandardScaler 포함)
- manifest.json: 운동 → 모델 종류, 조건 이름, 파일, 학습 샘플·수행자 수
검증셋(valid_*)은 학습에 넣지 않는다 (보고한 외부 평가 수치를 유지하기 위해).

아래 LOGREG·HGB·BASE16·BAR6 은 2026-11-19~23 최종 모델을 만들 때 쓴 선택이다 (재현용 기록).
사용: final_fit.py --heavy <heavy 폴더> --out <모델 폴더> [--files 묶음,... --exercises 운동,... --best best.json]"""
import os, sys, json, time, argparse, numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import train_pose as tp

LOGREG = {'스텝 백워드 다이나믹 런지', '버피 테스트', '바벨 로우'}
HGB = {'스텝 포워드 다이나믹 런지'}
BARBELL = {'바벨 스쿼트', '바벨 런지', '바벨 로우', '바벨 데드리프트', '덤벨 벤트오버 로우'}
BASE16 = ['body_01', 'body_02', 'body_04', 'body_08', 'body_09', 'body_10', 'body_11', 'body_12', 'body_17',
          'babel_01', 'babel_02', 'babel_03', 'babel_04', 'babel_05', 'babel_07', 'babel_14']
BAR6 = ['babel_02', 'babel_04', 'babel_05', 'babel_06', 'babel_08', 'babel_09']


def fit_cnn(S, Y, groups, outdir, seeds=(0, 100, 200)):
    import keras
    from keras import layers
    mu, sd = S.reshape(-1, S.shape[-1]).mean(0), S.reshape(-1, S.shape[-1]).std(0) + 1e-6
    A = (S - mu) / sd
    ug = np.unique(groups); files = []
    for seed in seeds:  # train_pose.fit_predict_seq 와 같은 구조·조기 종료
        rng = np.random.default_rng(seed)
        vm = np.isin(groups, rng.choice(ug, max(1, int(round(len(ug) * 0.15))), replace=False))
        keras.utils.set_random_seed(seed)
        inp = keras.Input(A.shape[1:]); x = layers.GaussianNoise(0.05)(inp)
        for _ in range(2):
            x = layers.Conv1D(64, 3, padding="same")(x); x = layers.BatchNormalization()(x); x = layers.ReLU()(x)
        x = layers.Concatenate()([layers.GlobalAveragePooling1D()(x), layers.GlobalMaxPooling1D()(x)])
        x = layers.Dropout(0.3)(x); out = layers.Dense(Y.shape[1], activation="sigmoid")(x)
        m = keras.Model(inp, out)
        m.compile(keras.optimizers.Adam(1e-3), "binary_crossentropy")
        m.fit(A[~vm], Y[~vm], validation_data=(A[vm], Y[vm]), epochs=150, batch_size=32, verbose=0,
              callbacks=[keras.callbacks.EarlyStopping(patience=15, restore_best_weights=True)])
        f = f'cnn_seed{seed}'
        m.save(os.path.join(outdir, f + '.keras'))
        W = {}
        for l in m.layers:
            for k, w in zip([v.path for v in l.weights], l.get_weights()):
                W[k.replace('/', '__')] = w
        np.savez(os.path.join(outdir, f + '_weights.npz'), **W)
        # ONNX 검증용: 학습 샘플 앞 64개의 Keras 예측을 같이 저장
        np.savez(os.path.join(outdir, f + '_check.npz'), x=A[:64].astype(np.float32), y=m.predict(A[:64], verbose=0))
        files.append(f); keras.backend.clear_session()
    np.savez(os.path.join(outdir, 'cnn_norm.npz'), mu=mu.astype(np.float32), sd=sd.astype(np.float32))
    return files


def main(a):
    t0 = time.time()
    os.makedirs(a.out, exist_ok=True)
    mpath = os.path.join(a.out, 'manifest.json')
    manifest = json.load(open(mpath, encoding='utf-8')) if os.path.exists(mpath) else {}
    groups = [('extra', a.files.split(','))] if a.files else [('base', BASE16), ('barbell', BAR6)]
    best = json.load(open(a.best, encoding='utf-8')) if a.best else {}
    only = set(a.exercises.split(',')) if a.exercises else None
    for group, files in groups:
        X, meta = tp.load([os.path.join(a.heavy, f + '.npz') for f in files])
        X, _ = tp.fix_lr(X)
        ex = np.array([m['exercise'] for m in meta])
        if group == 'extra':
            todo = [e for e in sorted(set(ex)) if (only is None or e in only) and e not in manifest]
        else:
            todo = [e for e in sorted(set(ex)) if (e in BARBELL) == (group == 'barbell') and e not in manifest]
        print(f'[{group}] 샘플 {len(X)}, 이번에 학습할 운동 {len(todo)}개, {time.time()-t0:.0f}초', flush=True)
        for e in todo:
            idx = np.where(ex == e)[0]
            Y = np.array([meta[i]['vals'] for i in idx], np.float32); G = np.array([meta[i]['z'] for i in idx])
            names = meta[idx[0]]['names']
            k = len(manifest)
            while os.path.exists(os.path.join(a.out, f'ex{k:02d}')):
                k += 1
            d = os.path.join(a.out, f'ex{k:02d}'); os.makedirs(d, exist_ok=True)
            kind = best.get(e) or ('logreg' if e in LOGREG else 'hgb' if e in HGB else 'cnn')
            if kind == 'gru':
                kind = 'cnn'  # 배포 경로는 CNN 만 지원 (GRU 가 최고여도 CNN 으로)
            if kind == 'cnn':
                files_out = fit_cnn(tp.sequences(X[idx]), Y, G, d)
            else:
                import joblib
                F = tp.features(X[idx]); files_out = []
                for j, n in enumerate(names):
                    m = tp.make_model(kind).fit(F, Y[:, j])
                    joblib.dump(m, os.path.join(d, f'{kind}_c{j}.joblib')); files_out.append(f'{kind}_c{j}.joblib')
                    if kind == 'logreg':
                        sc, lr = m.steps[0][1], m.steps[1][1]
                        json.dump(dict(mean=sc.mean_.tolist(), scale=sc.scale_.tolist(), coef=lr.coef_[0].tolist(),
                                       intercept=float(lr.intercept_[0])),
                                  open(os.path.join(d, f'logreg_c{j}.json'), 'w'))
                np.save(os.path.join(d, 'features_check_x.npy'), F[:64])
            manifest[e] = dict(dir=os.path.basename(d), model=kind, conditions=names, files=files_out,
                               samples=int(len(idx)), performers=int(len(set(G))), data=files)
            json.dump(manifest, open(mpath, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
            print(f'  {e}: {kind}, 샘플 {len(idx)}, 수행자 {len(set(G))}명, 누적 {time.time()-t0:.0f}초', flush=True)
        del X, meta
    print(f'전체 완료 {time.time()-t0:.0f}초', flush=True)


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('--heavy', required=True, help='heavy 좌표 폴더 (npz + _clips.json)')
    ap.add_argument('--out', required=True, help='모델 폴더 (manifest.json, 운동별 exNN/)')
    ap.add_argument('--files', default='', help='이 npz 묶음만 학습 (쉼표, 확장자 없이)')
    ap.add_argument('--exercises', default='', help='이 운동만 (쉼표)')
    ap.add_argument('--best', default='', help='운동→모델 종류 JSON (pick_best.py 결과)')
    main(ap.parse_args())

