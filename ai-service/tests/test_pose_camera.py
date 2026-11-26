import math
import tempfile
import unittest
from unittest.mock import patch

import numpy as np

from mealfit_ai import create_app
from mealfit_ai.services import pose_camera
from tests.pose_fixtures import front_raise, to_frames, write_logreg_model_dir

URL = '/ai/pose/analyze'
EXERCISE = '프런트 레이즈'
# 가짜 학습 범위: 정면(0°) 근처와 뒤쪽 대각선(140°) 근처만 있음
RANGES = {EXERCISE: {'C': {'center': 0.0, 'lo': -10.0, 'hi': 10.0}, 'A': {'center': 140.0, 'lo': -10.0, 'hi': 10.0}}}


def turn(arr, deg):
    """사람을 수직축 둘레로 돌린다 (카메라가 다른 방향에서 찍은 효과). 엉덩이 선 각도가 deg 만큼 바뀐다"""
    a = math.radians(deg)
    out = arr.copy()
    x, z = arr[..., 0], arr[..., 2]
    out[..., 0] = x * math.cos(a) - z * math.sin(a)
    out[..., 2] = x * math.sin(a) + z * math.cos(a)
    return out


def yaw_of(arr):
    return pose_camera.camera_yaw(arr, np.ones(len(arr), bool))


class PoseCameraTest(unittest.TestCase):
    # 엉덩이 선 방향으로 촬영 방향을 구한다 (정면 0°, 돌린 만큼 바뀜, ±180° 경계도 원형 평균)
    def test_camera_yaw(self):
        arr = front_raise(noise=0)
        self.assertAlmostEqual(yaw_of(arr), 0.0, places=6)
        self.assertAlmostEqual(yaw_of(turn(arr, 90)), 90.0, places=6)
        self.assertAlmostEqual(abs(yaw_of(turn(arr, 180))), 180.0, places=6)
        self.assertIsNone(pose_camera.camera_yaw(arr, np.zeros(len(arr), bool)))

    # 학습 범위 ±여유(10°) 안이면 통과, 밖이면 실패, 범위 정보가 없으면 검사하지 않음
    def test_in_training_range(self):
        with patch.object(pose_camera, '_ranges', RANGES):
            self.assertTrue(pose_camera.in_training_range(EXERCISE, 0))
            self.assertTrue(pose_camera.in_training_range(EXERCISE, 19.9))
            self.assertTrue(pose_camera.in_training_range(EXERCISE, -200))  # 160° 와 같은 방향 (140 + 범위 10 + 여유 10)
            self.assertFalse(pose_camera.in_training_range(EXERCISE, -165))  # 195° 는 범위 밖
            self.assertFalse(pose_camera.in_training_range(EXERCISE, 90))
            self.assertFalse(pose_camera.in_training_range(EXERCISE, -60))
            self.assertTrue(pose_camera.in_training_range('없는 운동', 90))
            self.assertTrue(pose_camera.in_training_range(EXERCISE, None))

    # 실제 범위 파일: 운동마다 시점 범위가 있고 값이 올바름
    def test_ranges_file(self):
        data = pose_camera.ranges()
        self.assertGreaterEqual(len(data), 41)
        for exercise, views in data.items():
            with self.subTest(exercise=exercise):
                self.assertTrue(views)
                for v in views.values():
                    self.assertTrue(-180 <= v['center'] <= 180)
                    self.assertLessEqual(v['lo'], 0)
                    self.assertGreaterEqual(v['hi'], 0)


class PoseCameraApiTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        write_logreg_model_dir(self.tmp.name, EXERCISE)
        with patch('mealfit_ai.load_dotenv'):
            app = create_app({'TESTING': True, 'OCR_PREDICTOR': object(), 'POSE_MODEL_DIR': self.tmp.name,
                              'POSE_MODEL_VERSION': 'pose-test'})
        self.client = app.test_client()
        patcher = patch.object(pose_camera, '_ranges', RANGES)
        patcher.start()
        self.addCleanup(patcher.stop)

    def tearDown(self):
        self.tmp.cleanup()

    def post(self, arr):
        return self.client.post(URL, json={'exercise': EXERCISE, 'fps': 15, 'frames': to_frames(arr)}).json

    # 학습에 없는 방향(옆 90°)이면 판정 대신 재촬영 안내
    def test_camera_angle_retake(self):
        data = self.post(turn(front_raise(), 90))
        self.assertEqual((data['status'], data['retakeCode'], data['repCount'], data['reps'], data['conditions']),
                         ('RETAKE', 'POSE_CAMERA_ANGLE', 0, [], []))
        self.assertIn('참고용', data['notice'])

    # 학습에 있는 방향이면 그대로 판정
    def test_camera_angle_ok(self):
        for deg in (0, 145):
            with self.subTest(deg=deg):
                data = self.post(turn(front_raise(), deg))
                self.assertEqual(data['status'], 'OK')
                self.assertEqual(data['repCount'], 3)


if __name__ == '__main__':
    unittest.main()
