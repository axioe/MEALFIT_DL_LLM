"""운동 자세 판별 모델 호출 (POSE_MODEL_DIR 의 manifest.json + 운동별 폴더).

모델 파일은 git에 없다. 운영은 서버 폴더를 읽기 전용으로 마운트한다.
- cnn: model.onnx (입력 'seq' (N,32,74), 출력 'prob' (N,조건 수))
- hgb: 조건마다 ONNX 하나 (입력 (N,D), 출력 [label, probabilities(N,2)])
- logreg: 조건마다 계수 JSON (StandardScaler 포함) — numpy 로 계산
manifest 의 운동 항목에 sha256 {파일 이름: 값} 이 있으면 파일을 처음 불러올 때 대조한다.
onnxruntime·numpy 는 판정 요청이 처음 올 때 불러온다 (기본 이미지에 없어도 앱은 뜬다).
"""
import hashlib
import json
import os
import threading

from mealfit_ai.errors import ServiceError

UNAVAILABLE = ('POSE_003', '자세 판별 모델을 사용할 수 없습니다.')


def _unavailable():
    return ServiceError(503, *UNAVAILABLE)


def inference_ready():
    """추론 패키지(numpy·onnxruntime)가 설치돼 있는지 (불러오지는 않는다)"""
    import importlib.util
    return all(importlib.util.find_spec(p) is not None for p in ('numpy', 'onnxruntime'))


class PoseModelClient:
    def __init__(self, model_dir):
        self.model_dir = os.path.abspath(model_dir) if model_dir else ''
        self._manifest = None
        self._models = {}
        self._lock = threading.Lock()

    def manifest(self):
        if self._manifest is None:
            path = os.path.join(self.model_dir, 'manifest.json')
            if not self.model_dir or not os.path.isfile(path):
                raise _unavailable()
            try:
                with open(path, encoding='utf-8') as f:
                    data = json.load(f)
            except (OSError, ValueError):
                raise _unavailable() from None
            self._manifest = {k: v for k, v in data.items() if not k.startswith('_')}
        return self._manifest

    def exercises(self):
        """지원 운동 목록 [(운동명, 조건 이름 목록)] (운동명 순). Spring 이 판정 전에 지원 여부를 확인하는 데 쓴다.
        추론 패키지(numpy·onnxruntime)가 없으면 판정을 못 하므로 목록도 503 으로 알린다."""
        if not inference_ready():
            raise _unavailable()
        return [(name, list(m['conditions'])) for name, m in sorted(self.manifest().items())]

    def spec(self, exercise):
        """운동 정보 (모델 종류, 조건 이름, 입력 종류, 조건별 정확도). 지원하지 않는 운동이면 None"""
        m = self.manifest().get(exercise)
        if m is None:
            return None
        if m['model'] == 'cnn':
            kind = 'seq'
        elif m.get('features') == 'posture_features_v2':
            kind = 'choi_features'
        else:
            kind = 'features'
        return {'model': m['model'], 'conditions': list(m['conditions']), 'input': kind,
                'accuracy': m.get('accuracy')}

    def predict(self, exercise, x):
        """조건별 '올바름' 확률 (N, 조건 수)"""
        model = self._load(exercise)
        return model(x)

    def _path(self, m, name):
        """모델 폴더 안의 파일 경로. manifest 에 sha256 {파일 이름: 값} 이 있으면 내용도 대조한다"""
        path = os.path.abspath(os.path.join(self.model_dir, m['dir'], name))
        if os.path.commonpath([path, self.model_dir]) != self.model_dir or not os.path.isfile(path):
            raise _unavailable()
        expected = (m.get('sha256') or {}).get(name)
        if expected:
            digest = hashlib.sha256()
            with open(path, 'rb') as f:
                for chunk in iter(lambda: f.read(1 << 20), b''):
                    digest.update(chunk)
            if digest.hexdigest().lower() != expected.lower():
                raise _unavailable()
        return path

    def _load(self, exercise):
        with self._lock:
            model = self._models.get(exercise)
            if model is None:
                m = self.manifest()[exercise]
                try:
                    import numpy as np
                except ImportError:
                    raise _unavailable() from None
                if m['model'] == 'cnn':
                    sess = self._session(self._path(m, m['onnx']))
                    name = sess.get_inputs()[0].name

                    def model(x, sess=sess, name=name):
                        return sess.run(None, {name: np.asarray(x, np.float32)})[0]
                elif m['model'] == 'hgb':
                    sessions = [self._session(self._path(m, f)) for f in m['onnx']]

                    def model(x, sessions=sessions):
                        x = np.asarray(x, np.float32)
                        return np.stack([s.run(None, {s.get_inputs()[0].name: x})[1][:, 1] for s in sessions], 1)
                elif m['model'] == 'logreg':
                    params = []
                    for f in m['files']:
                        with open(self._path(m, f.replace('.joblib', '.json')), encoding='utf-8') as fp:
                            j = json.load(fp)
                        params.append((np.array(j['mean']), np.array(j['scale']), np.array(j['coef']),
                                       float(j['intercept'])))

                    def model(x, params=params):
                        x = np.asarray(x, np.float64)
                        z = np.stack([((x - mu) / sc) @ coef + b for mu, sc, coef, b in params], 1)
                        # 학습 분포에서 먼 입력은 z 가 매우 커져 exp 가 넘친다(경고). 확률은 0·1 에 붙으므로 범위만 제한한다
                        return 1 / (1 + np.exp(-np.clip(z, -500, 500)))
                else:
                    raise _unavailable()
                self._models[exercise] = model
            return model

    @staticmethod
    def _session(path):
        try:
            import onnxruntime as ort
        except ImportError:
            raise _unavailable() from None
        options = ort.SessionOptions()
        options.intra_op_num_threads = 1
        return ort.InferenceSession(path, sess_options=options, providers=['CPUExecutionProvider'])
