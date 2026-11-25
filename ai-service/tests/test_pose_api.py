import json
import os
import sys
import tempfile
import types
import unittest
from unittest.mock import patch

import numpy as np

from mealfit_ai import create_app
from mealfit_ai.clients.pose_model_client import PoseModelClient
from tests.pose_fixtures import front_raise, hold, to_frames, write_json, write_logreg_model_dir

URL = '/ai/pose/analyze'
EXERCISE = '프런트 레이즈'


class PoseApiTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        write_logreg_model_dir(self.tmp.name, EXERCISE,
                               accuracy=[{'cv': 0.8954, 'external': None}, {'cv': 0.81, 'external': 0.7712}])
        self.client = self.app().test_client()

    def tearDown(self):
        self.tmp.cleanup()

    def app(self, **config):
        with patch('mealfit_ai.load_dotenv'):
            return create_app({'TESTING': True, 'OCR_PREDICTOR': object(), 'POSE_MODEL_DIR': self.tmp.name,
                               'POSE_MODEL_VERSION': 'pose-test', **config})

    def body(self, arr=None, exercise=EXERCISE, fps=15, missing=()):
        arr = front_raise() if arr is None else arr
        return {'exercise': exercise, 'fps': fps, 'frames': to_frames(arr, missing)}

    # 반복 3회 영상 → 반복별·조건별 판정, 조건 요약, 정확도, 안내 문구
    def test_success(self):
        with self.assertLogs('mealfit_ai', level='INFO') as logs:
            response = self.client.post(URL, json=self.body())
        self.assertEqual(response.status_code, 200)
        data = response.json
        self.assertEqual(set(data), {'exercise', 'status', 'retakeCode', 'modelVersion', 'repCount', 'reps',
                                     'conditions', 'notice'})
        self.assertEqual((data['status'], data['retakeCode'], data['modelVersion']), ('OK', None, 'pose-test'))
        self.assertEqual(data['repCount'], 3)
        self.assertEqual([r['index'] for r in data['reps']], [1, 2, 3])
        for rep in data['reps']:
            self.assertEqual([c['name'] for c in rep['conditions']], ['팔꿈치 고정', '어깨 으쓱 없음'])
            for c in rep['conditions']:
                self.assertTrue(0 <= c['probability'] <= 1)
                self.assertEqual(c['correct'], c['probability'] >= 0.5)
        first, second = data['conditions']
        self.assertEqual((first['accuracy'], first['accuracyBasis']), (0.895, 'CV'))
        self.assertEqual((second['accuracy'], second['accuracyBasis']), (0.771, 'EXTERNAL'))
        # 가짜 모델의 절편: 첫 조건은 올바름(0.4), 두 번째는 확인 필요(-0.4) 쪽
        self.assertEqual((first['correctReps'], first['totalReps']), (3, 3))
        self.assertEqual(first['feedback'], '팔꿈치 고정: 잘 지켜졌어요.')
        self.assertEqual(second['feedback'], '어깨 으쓱 없음: 모든 반복에서 확인이 필요해요.')
        self.assertIn('참고용', data['notice'])
        # 로그에는 운동·반복 수·시간·모델 버전만 (좌표 없음)
        self.assertTrue(any('reps=3' in line and 'pose-test' in line for line in logs.output))
        self.assertFalse(any('[' in line for line in logs.output))

    # 정확도가 manifest 에 없으면 null
    def test_accuracy_missing(self):
        tmp = tempfile.TemporaryDirectory()
        self.addCleanup(tmp.cleanup)
        write_logreg_model_dir(tmp.name, EXERCISE)
        client = self.app(POSE_MODEL_DIR=tmp.name).test_client()
        cond = client.post(URL, json=self.body()).json['conditions'][0]
        self.assertEqual((cond['accuracy'], cond['accuracyBasis']), (None, None))

    # 버티기처럼 움직임이 거의 없으면 1회로 판정, 일부 프레임 누락은 보간
    def test_static_and_missing_frames(self):
        data = self.client.post(URL, json=self.body(hold(), missing={3, 4, 40})).json
        self.assertEqual((data['status'], data['repCount']), ('OK', 1))
        self.assertEqual((data['reps'][0]['startFrame'], data['reps'][0]['endFrame']), (0, 74))
        self.assertEqual(data['conditions'][1]['feedback'], '어깨 으쓱 없음: 확인이 필요해요.')

    # 사람이 없거나 프레임이 부족하면 판정 대신 재촬영 안내
    def test_retake(self):
        arr = front_raise()
        cases = [(self.body(arr, missing=set(range(len(arr)))), 'POSE_NO_PERSON'),
                 (self.body(arr, missing=set(range(0, len(arr), 2)) | {1}), 'POSE_NO_PERSON'),
                 (self.body(arr[:10]), 'POSE_TOO_FEW_FRAMES')]
        for body, code in cases:
            data = self.client.post(URL, json=body).json
            self.assertEqual((data['status'], data['retakeCode'], data['repCount'], data['reps'], data['conditions']),
                             ('RETAKE', code, 0, [], []))

    # 형식 오류는 400 POSE_001
    def test_invalid_requests(self):
        good = self.body(front_raise(seconds=2))
        frame = good['frames'][0]

        def with_frame(f):
            return {**good, 'frames': [f] + good['frames'][1:]}

        cases = [{}, {**good, 'extra': 1}, {**good, 'exercise': ''}, {**good, 'exercise': 3},
                 {**good, 'fps': 2}, {**good, 'fps': 31}, {**good, 'fps': True}, {**good, 'fps': '15'},
                 {**good, 'frames': []}, {**good, 'frames': 'x'},
                 {**good, 'fps': 5, 'frames': good['frames'] * 11},  # 66초
                 with_frame(frame[:32]), with_frame([p[:3] for p in frame]),
                 with_frame([[True, 0, 0, 1]] + frame[1:]), with_frame([['0.1', 0, 0, 1]] + frame[1:]),
                 with_frame([[0, 0, 0, 1.5]] + frame[1:]), with_frame([[11, 0, 0, 1]] + frame[1:]),
                 with_frame([[None, 0, 0, 1]] + frame[1:])]
        for body in cases:
            response = self.client.post(URL, json=body)
            self.assertEqual((response.status_code, response.json['code']), (400, 'POSE_001'), body.keys())
        nan = json.dumps(good).replace('0.95', 'NaN', 1)
        response = self.client.post(URL, data=nan, content_type='application/json')
        self.assertEqual((response.status_code, response.json['code']), (400, 'POSE_001'))
        self.assertEqual(self.client.post(URL, data='{', content_type='application/json').status_code, 400)

    # 900프레임(30fps·30초)은 받고, 3MB를 넘는 본문은 막는다
    def test_size_limits(self):
        body = self.body(front_raise(seconds=30, fps=30, cycles=10), fps=30)
        self.assertEqual(len(body['frames']), 900)
        self.assertEqual(self.client.post(URL, json=body).status_code, 200)
        big = json.dumps(body).encode() + b' ' * (3 * 1024 * 1024)
        self.assertEqual(self.client.post(URL, data=big, content_type='application/json').status_code, 413)

    def test_unsupported_exercise(self):
        response = self.client.post(URL, json=self.body(exercise='없는 운동'))
        self.assertEqual((response.status_code, response.json['code']), (400, 'POSE_002'))
        response = self.client.post(URL, json=self.body(exercise='_replaced'))
        self.assertEqual(response.json['code'], 'POSE_002')

    # 모델 폴더가 없거나 onnxruntime 이 없으면 503 POSE_003, 다른 기능은 그대로
    def test_model_unavailable(self):
        client = self.app(POSE_MODEL_DIR='').test_client()
        response = client.post(URL, json=self.body())
        self.assertEqual((response.status_code, response.json['code']), (503, 'POSE_003'))
        self.assertEqual(client.get('/health').status_code, 200)
        with patch.dict(sys.modules, {'mealfit_ai.services.pose_service': None}):
            response = self.client.post(URL, json=self.body())
        self.assertEqual((response.status_code, response.json['code']), (503, 'POSE_003'))

    # manifest 의 sha256 과 파일 내용이 다르면 열지 않는다
    def test_sha256_check(self):
        import hashlib
        manifest_path = os.path.join(self.tmp.name, 'manifest.json')
        with open(manifest_path, encoding='utf-8') as f:
            manifest = json.load(f)
        entry = manifest[EXERCISE]
        with open(os.path.join(self.tmp.name, 'ex99', 'logreg_c0.json'), 'rb') as f:
            good = hashlib.sha256(f.read()).hexdigest()
        entry['sha256'] = {'logreg_c0.json': good.upper()}
        write_json(manifest_path, manifest)
        self.assertEqual(self.app().test_client().post(URL, json=self.body()).status_code, 200)
        entry['sha256'] = {'logreg_c0.json': '0' * 64}
        write_json(manifest_path, manifest)
        response = self.app().test_client().post(URL, json=self.body())
        self.assertEqual((response.status_code, response.json['code']), (503, 'POSE_003'))

    # 모델 결과 모양이 조건 수와 다르면 500 POSE_004
    def test_bad_model_output(self):
        class Broken(PoseModelClient):
            def predict(self, exercise, x):
                return np.zeros((len(x), 5))
        client = self.app(POSE_CLIENT=Broken(self.tmp.name)).test_client()
        response = client.post(URL, json=self.body())
        self.assertEqual((response.status_code, response.json['code']), (500, 'POSE_004'))


class PoseModelClientTest(unittest.TestCase):
    """CNN·HGB 는 ONNX 경로를 가짜 onnxruntime 으로 확인한다 (CI에는 onnxruntime 이 없다)."""

    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        for d, files in (('ex00', ['model.onnx']), ('ex38', ['hgb_c0.onnx', 'hgb_c1.onnx']),
                         ('choi', ['hgb_c0.onnx'])):
            os.makedirs(os.path.join(self.tmp.name, d))
            for f in files:
                open(os.path.join(self.tmp.name, d, f), 'wb').close()
        manifest = {'푸시업': {'dir': 'ex00', 'model': 'cnn', 'conditions': ['a', 'b', 'c'], 'onnx': 'model.onnx'},
                    '사이드 런지': {'dir': 'ex38', 'model': 'hgb', 'conditions': ['a', 'b'],
                               'onnx': ['hgb_c0.onnx', 'hgb_c1.onnx']},
                    '바이시클 크런치': {'dir': 'choi', 'model': 'hgb', 'features': 'posture_features_v2',
                                 'conditions': ['a'], 'onnx': ['hgb_c0.onnx']},
                    '나쁜 경로': {'dir': '..', 'model': 'cnn', 'conditions': ['a'], 'onnx': 'manifest.json'}}
        write_json(os.path.join(self.tmp.name, 'manifest.json'), manifest)
        self.calls = []
        calls = self.calls

        class Session:
            def __init__(self, path, sess_options=None, providers=None):
                self.path = path
                calls.append(('open', os.path.basename(path), providers))

            def get_inputs(self):
                return [types.SimpleNamespace(name='seq' if self.path.endswith('model.onnx') else 'X')]

            def run(self, _outputs, feed):
                (name, x), = feed.items()
                calls.append(('run', name, x.dtype, x.shape))
                n = len(x)
                if name == 'seq':
                    return [np.full((n, 3), 0.7, np.float32)]
                return [np.zeros(n), np.tile([[0.2, 0.8]], (n, 1))]

        self.fake_ort = types.SimpleNamespace(InferenceSession=Session, SessionOptions=types.SimpleNamespace)

    def test_specs(self):
        client = PoseModelClient(self.tmp.name)
        self.assertEqual(client.spec('푸시업')['input'], 'seq')
        self.assertEqual(client.spec('사이드 런지')['input'], 'features')
        self.assertEqual(client.spec('바이시클 크런치')['input'], 'choi_features')
        self.assertIsNone(client.spec('없음'))

    def test_onnx_paths(self):
        client = PoseModelClient(self.tmp.name)
        with patch.dict(sys.modules, {'onnxruntime': self.fake_ort}):
            p = client.predict('푸시업', np.zeros((2, 32, 74)))
            np.testing.assert_allclose(p, 0.7)
            p = client.predict('사이드 런지', np.zeros((3, 427)))
            self.assertEqual(p.shape, (3, 2))
            np.testing.assert_allclose(p, 0.8)
            client.predict('푸시업', np.zeros((1, 32, 74)))  # 세션은 한 번만 연다
        self.assertIn(('run', 'seq', np.float32, (2, 32, 74)), self.calls)
        self.assertEqual(sum(1 for c in self.calls if c[:2] == ('open', 'model.onnx')), 1)
        self.assertTrue(all(c[2] == ['CPUExecutionProvider'] for c in self.calls if c[0] == 'open'))

    # 학습 분포에서 먼 입력으로 LogReg z 가 아주 커져도 exp overflow 경고 없이 0~1 확률을 낸다
    def test_logreg_extreme_input_no_overflow(self):
        import warnings
        root = tempfile.mkdtemp(dir=self.tmp.name)
        os.makedirs(os.path.join(root, 'ex99'))
        write_json(os.path.join(root, 'ex99', 'logreg_c0.json'), {'mean': [0.0] * 4, 'scale': [1.0] * 4, 'coef': [1.0] * 4, 'intercept': 0.0})
        write_json(os.path.join(root, 'ex99', 'logreg_c1.json'), {'mean': [0.0] * 4, 'scale': [1.0] * 4, 'coef': [-1.0] * 4, 'intercept': 0.0})
        write_json(os.path.join(root, 'manifest.json'), {'버피 테스트': {'dir': 'ex99', 'model': 'logreg', 'conditions': ['a', 'b'],
                                                               'files': ['logreg_c0.joblib', 'logreg_c1.joblib']}})
        client = PoseModelClient(root)
        x = np.array([[1e3] * 4, [-1e3] * 4, [0.0] * 4])  # z = ±4000, 0
        with warnings.catch_warnings():
            warnings.simplefilter('error')
            p = client.predict('버피 테스트', x)
        self.assertTrue(np.isfinite(p).all() and ((p >= 0) & (p <= 1)).all())
        np.testing.assert_allclose(p[0], [1.0, 0.0], atol=1e-12)
        np.testing.assert_allclose(p[1], [0.0, 1.0], atol=1e-12)
        np.testing.assert_allclose(p[2], [0.5, 0.5])

    def test_unavailable(self):
        from mealfit_ai.errors import ServiceError
        client = PoseModelClient(self.tmp.name)
        with patch.dict(sys.modules, {'onnxruntime': None}):
            with self.assertRaises(ServiceError) as caught:
                client.predict('푸시업', np.zeros((1, 32, 74)))
        self.assertEqual((caught.exception.status, caught.exception.code), (503, 'POSE_003'))
        with patch.dict(sys.modules, {'onnxruntime': self.fake_ort}):
            with self.assertRaises(ServiceError):  # 모델 폴더 밖 경로는 열지 않는다
                client.predict('나쁜 경로', np.zeros((1, 32, 74)))
        with self.assertRaises(ServiceError):
            PoseModelClient('').manifest()


if __name__ == '__main__':
    unittest.main()
