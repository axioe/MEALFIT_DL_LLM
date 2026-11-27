r"""최원석 v2(HGB) 모델이 더 나은 운동(스텝 포워드 다이나믹 런지, 바이시클 크런치)을 final_fit.py 모델 폴더에 합친다.
2026-11-19 최종 모델 확정 때 쓴 절차를 그대로 옮겼다 (작성자 동의 2026-11-24).
- 조건별 HGB 를 joblib 로 나눠 저장하고, 특징 추출 코드(posture_features_v2.py)를 모델 폴더 features/ 에 복사한다.
  특징 코드는 서비스가 쓰는 ai-service/mealfit_ai/services/posture_features_v2.py 와 같은 파일을 쓴다.
- ONNX 변환 검증용 특징(features_check_x.npy)은 heavy 좌표에서 해당 운동 시퀀스 64개로 만든다.
- 기존(유지훈) 항목은 manifest['_replaced'] 에 보관한다.
최원석 모델 파일(posture_ml_models_v2.joblib)과 지표(model_metrics.json)는 git 에 없다 (저장 위치는 docs/pose-model-card.md).

사용: merge_choi.py --choi <최원석 모델 폴더> --models <모델 폴더> --heavy <heavy 폴더>
"""
import argparse
import importlib.util
import json
import os
import shutil

import joblib
import numpy as np

FEATURES = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'mealfit_ai', 'services',
                        'posture_features_v2.py')
TAKE = {'스텝 포워드 다이나믹 런지': ['body_04', 'body_01'], '바이시클 크런치': ['body_08', 'body_09']}


def load_features():
    """서비스 패키지(Flask 등)를 불러오지 않고 특징 추출 파일만 읽는다"""
    spec = importlib.util.spec_from_file_location('posture_features_v2', FEATURES)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod.extract_sequence_features


def check_features(extract, heavy, ex, files, n=64):
    out = []
    for f in files:
        z = np.load(os.path.join(heavy, f + '.npz'))
        clips = json.load(open(os.path.join(heavy, f + '_clips.json'), encoding='utf-8'))
        clip, view, frame, ok, world, vis = z['clip'], z['view'], z['frame'], z['ok'], z['world'], z['img'][:, :, 3]
        o = np.lexsort((frame, view, clip)); clip, view, ok, world, vis = clip[o], view[o], ok[o], world[o], vis[o]
        key = clip * 5 + view; st = np.r_[0, np.where(np.diff(key) != 0)[0] + 1, len(key)]
        for s, e in zip(st[:-1], st[1:]):
            if clips[int(clip[s])]['exercise'] == ex and ok[s:e].mean() >= 0.3:
                out.append(extract(world[s:e], vis[s:e], ok[s:e]))
                if len(out) >= n:
                    return np.vstack(out)
    return np.vstack(out)


def main(a):
    extract = load_features()
    bundle = joblib.load(os.path.join(a.choi, 'posture_ml_models_v2.joblib'))
    metrics = json.load(open(os.path.join(a.choi, 'model_metrics.json'), encoding='utf-8'))['exercises']
    mpath = os.path.join(a.models, 'manifest.json')
    man = json.load(open(mpath, encoding='utf-8'))
    os.makedirs(os.path.join(a.models, 'features'), exist_ok=True)
    shutil.copy(FEATURES, os.path.join(a.models, 'features', 'posture_features_v2.py'))
    man.setdefault('_replaced', {})
    for ex, files in TAKE.items():
        ent = bundle['exercises'][ex]
        d = os.path.join(a.models, 'choi_' + ('forward_lunge' if '런지' in ex else 'bicycle')); os.makedirs(d, exist_ok=True)
        names, fl = [], []
        for j, (cname, c) in enumerate(ent['conditions'].items()):
            joblib.dump(c['model'], os.path.join(d, f'hgb_c{j}.joblib')); names.append(cname); fl.append(f'hgb_c{j}.joblib')
        np.save(os.path.join(d, 'features_check_x.npy'), check_features(extract, a.heavy, ex, files))
        if ex in man and man[ex].get('source') != '최원석 v2':
            man['_replaced'][ex] = man[ex]
        man[ex] = dict(dir=os.path.basename(d), model='hgb', features='posture_features_v2', source='최원석 v2',
                       conditions=names, files=fl, performers=None,
                       samples=metrics[ex]['overall']['n_samples'] if metrics[ex].get('overall') else None,
                       note='최원석 posture_features_v2.extract_sequence_features(world, vis, ok) 특징 입력')
        print(ex, '→', d, len(names), '조건')
    json.dump(man, open(mpath, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print('manifest 갱신')


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('--choi', required=True, help='최원석 모델 폴더 (posture_ml_models_v2.joblib, model_metrics.json)')
    ap.add_argument('--models', required=True, help='final_fit.py 모델 폴더')
    ap.add_argument('--heavy', required=True, help='heavy 좌표 폴더 (npz + _clips.json)')
    main(ap.parse_args())
