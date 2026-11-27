"""final_fit.py 모델 폴더 → ONNX (TensorFlow 없이 onnx/onnxruntime 만 쓰는 별도 환경 requirements-export.txt 에서 실행).
- CNN: 저장한 층별 가중치로 그래프를 직접 만든다. 입력 정규화(mu/sd)와 시드 3개 평균을 그래프 안에 넣는다.
  입력 'seq' (N,32,F) = train_pose.sequences 결과, 출력 'prob' (N,조건 수) = 조건별 '올바름' 확률.
- HGB: skl2onnx. 입력 'feat' (N,D) = train_pose.features 결과, 출력 조건별 확률 → 한 파일에 조건마다 하나씩.
- LogReg: 계수 JSON 그대로 쓴다 (ONNX 불필요). 검증만 한다.
각 변환은 저장해 둔 Keras/sklearn 예측과 onnxruntime 예측의 최대 오차로 확인한다.
사용: export_onnx.py --models <모델 폴더>"""
import os, re, json, glob, argparse, numpy as np
import onnx
from onnx import helper, numpy_helper, TensorProto
import onnxruntime as ort

# skl2onnx 1.20 + onnx 1.23: HGB 트리의 결측값 방향 플래그(numpy bool 목록)를 정수로 바꿔 넘긴다
_make_attr = helper.make_attribute
def _make_attr_bool_safe(key, value, *a, **k):
    if isinstance(value, (list, tuple)) and any(isinstance(v, (bool, np.bool_)) for v in value):
        value = [int(v) for v in value]
    return _make_attr(key, value, *a, **k)
helper.make_attribute = _make_attr_bool_safe

BN_EPS = 1e-3  # Keras BatchNormalization 기본값


def layer_weights(npz):
    W = dict(np.load(npz))
    layers = {}
    for k, v in W.items():
        lname, wname = k.split('__')[-2], k.split('__')[-1]
        layers.setdefault(lname, {})[wname] = v
    nat = lambda s: [int(t) if t.isdigit() else t for t in re.split(r'(\d+)', s)]
    convs = sorted([n for n in layers if n.startswith('conv1d')], key=nat)
    bns = sorted([n for n in layers if n.startswith('batch_normalization')], key=nat)
    dense = [n for n in layers if n.startswith('dense')]
    assert len(convs) == 2 and len(bns) == 2 and len(dense) == 1, layers.keys()
    return [layers[n] for n in convs], [layers[n] for n in bns], layers[dense[0]]


def cnn_onnx(d, seeds_files, out_path):
    norm = np.load(os.path.join(d, 'cnn_norm.npz'))
    inits, nodes = [numpy_helper.from_array(norm['mu'], 'mu'), numpy_helper.from_array(norm['sd'], 'sd')], []
    nodes += [helper.make_node('Sub', ['seq', 'mu'], ['xc']), helper.make_node('Div', ['xc', 'sd'], ['xn']),
              helper.make_node('Transpose', ['xn'], ['xt'], perm=[0, 2, 1])]  # (N,F,T)
    outs = []
    for s, f in enumerate(seeds_files):
        convs, bns, dense = layer_weights(os.path.join(d, f + '_weights.npz'))
        h = 'xt'
        for i, (c, b) in enumerate(zip(convs, bns)):
            p = f's{s}_l{i}'
            inits += [numpy_helper.from_array(np.transpose(c['kernel'], (2, 1, 0)).astype(np.float32), p + '_W'),
                      numpy_helper.from_array(c['bias'].astype(np.float32), p + '_B')]
            nodes.append(helper.make_node('Conv', [h, p + '_W', p + '_B'], [p + '_c'], pads=[1, 1], kernel_shape=[3]))
            for nm in ('gamma', 'beta', 'moving_mean', 'moving_variance'):
                inits.append(numpy_helper.from_array(b[nm].astype(np.float32), f'{p}_{nm}'))
            nodes.append(helper.make_node('BatchNormalization', [p + '_c', p + '_gamma', p + '_beta', p + '_moving_mean', p + '_moving_variance'],
                                          [p + '_bn'], epsilon=BN_EPS))
            nodes.append(helper.make_node('Relu', [p + '_bn'], [p + '_r'])); h = p + '_r'
        p = f's{s}'
        nodes += [helper.make_node('ReduceMean', [h], [p + '_avg'], axes=[2], keepdims=0),
                  helper.make_node('ReduceMax', [h], [p + '_max'], axes=[2], keepdims=0),
                  helper.make_node('Concat', [p + '_avg', p + '_max'], [p + '_cat'], axis=1)]
        inits += [numpy_helper.from_array(dense['kernel'].astype(np.float32), p + '_DW'),
                  numpy_helper.from_array(dense['bias'].astype(np.float32), p + '_DB')]
        nodes += [helper.make_node('MatMul', [p + '_cat', p + '_DW'], [p + '_mm']),
                  helper.make_node('Add', [p + '_mm', p + '_DB'], [p + '_z']),
                  helper.make_node('Sigmoid', [p + '_z'], [p + '_prob'])]
        outs.append(p + '_prob')
    nodes.append(helper.make_node('Sum', outs, ['psum']))
    inits.append(numpy_helper.from_array(np.array(len(outs), np.float32), 'nseed'))
    nodes.append(helper.make_node('Div', ['psum', 'nseed'], ['prob']))
    F, C = norm['mu'].shape[0], dense['bias'].shape[0]
    g = helper.make_graph(nodes, 'mealfit_pose_cnn', [helper.make_tensor_value_info('seq', TensorProto.FLOAT, ['N', 32, F])],
                          [helper.make_tensor_value_info('prob', TensorProto.FLOAT, ['N', C])], inits)
    model = helper.make_model(g, opset_imports=[helper.make_opsetid('', 17)], producer_name='mealfit_pose')
    model.ir_version = 9
    onnx.checker.check_model(model); onnx.save(model, out_path)
    # 확인: 시드별 Keras 예측의 평균 vs ONNX (check x 는 정규화 후 값이라 역정규화해서 넣는다)
    sess = ort.InferenceSession(out_path, providers=['CPUExecutionProvider'])
    errs = []
    for f in seeds_files:
        c = np.load(os.path.join(d, f + '_check.npz'))
        errs.append((c['x'], c['y']))
    x_raw = (errs[0][0] * norm['sd'] + norm['mu']).astype(np.float32)
    ys = []
    for f in seeds_files:  # 모든 시드에 같은 x 를 넣어야 평균 비교가 되므로 시드별 단일 그래프로 비교
        ys.append(np.load(os.path.join(d, f + '_check.npz'))['y'])
    same_x = all(np.allclose(e[0], errs[0][0]) for e in errs)
    pred = sess.run(['prob'], {'seq': x_raw})[0]
    err = float(np.abs(pred - np.mean(ys, 0)).max()) if same_x else None
    return err, int(F), int(C)


def hgb_onnx(d, files, out_path):
    import joblib
    from skl2onnx import to_onnx
    X = np.load(os.path.join(d, 'features_check_x.npy')).astype(np.float32)
    models, errs = [], []
    for f in files:
        m = joblib.load(os.path.join(d, f))
        om = to_onnx(m, X[:1], options={id(m): {'zipmap': False}}, target_opset=17)
        p = os.path.join(d, f.replace('.joblib', '.onnx')); onnx.save(om, p)
        sess = ort.InferenceSession(p, providers=['CPUExecutionProvider'])
        prob = sess.run(None, {sess.get_inputs()[0].name: X})[1][:, 1]
        errs.append(float(np.abs(prob - m.predict_proba(X)[:, 1]).max())); models.append(os.path.basename(p))
    return max(errs), models


def logreg_check(d, files):
    import joblib
    X = np.load(os.path.join(d, 'features_check_x.npy'))
    errs = []
    for f in files:
        j = json.load(open(os.path.join(d, f.replace('.joblib', '.json'))))
        z = ((X - np.array(j['mean'])) / np.array(j['scale'])) @ np.array(j['coef']) + j['intercept']
        errs.append(float(np.abs(1 / (1 + np.exp(-z)) - joblib.load(os.path.join(d, f)).predict_proba(X)[:, 1]).max()))
    return max(errs)


if __name__ == '__main__':
    ap = argparse.ArgumentParser(); ap.add_argument('--models', required=True, help='final_fit.py 모델 폴더')
    a = ap.parse_args()
    man = json.load(open(os.path.join(a.models, 'manifest.json'), encoding='utf-8'))
    for ex, m in man.items():
        if ex.startswith('_'):
            continue
        d = os.path.join(a.models, m['dir'])
        if m['model'] == 'cnn':
            err, F, C = cnn_onnx(d, m['files'], os.path.join(d, 'model.onnx'))
            m['onnx'] = 'model.onnx'; m['input'] = dict(name='seq', shape=[32, F]); m['max_abs_err'] = err
        elif m['model'] == 'hgb':
            err, files = hgb_onnx(d, m['files'], None); m['onnx'] = files; m['max_abs_err'] = err
        else:
            m['max_abs_err'] = logreg_check(d, m['files'])
        print(f"{ex}: {m['model']} 최대 오차 {m['max_abs_err']}", flush=True)
    json.dump(man, open(os.path.join(a.models, 'manifest.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)



