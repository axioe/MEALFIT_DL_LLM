import math
import unittest

import numpy as np

from mealfit_ai.services import pose_preprocess as pp
from mealfit_ai.services.posture_features_v2 import extract_sequence_features
from tests.pose_fixtures import BASE, front_raise, hold


def rotate_y(arr, deg):
    th = math.radians(deg)
    out = arr.copy()
    x, z = arr[..., 0], arr[..., 2]
    out[..., 0] = x * math.cos(th) - z * math.sin(th)
    out[..., 2] = x * math.sin(th) + z * math.cos(th)
    return out


class PosePreprocessTest(unittest.TestCase):
    def rep(self, arr=None):
        arr = front_raise(cycles=1, seconds=2) if arr is None else arr
        return pp.rep_tensor(arr.astype(np.float32), np.ones(len(arr), bool), 0, len(arr) - 1)

    # 모델 입력 차원이 학습과 같은지 (CNN 32×74, LogReg·HGB 427, 최원석 v2 317)
    def test_input_shapes(self):
        x = self.rep()[None]
        self.assertEqual(x.shape, (1, 32, 33, 4))
        self.assertEqual(pp.sequences(x).shape, (1, 32, 74))
        self.assertEqual(pp.features(x).shape, (1, 427))
        arr = front_raise(cycles=1, seconds=2).astype(np.float32)
        self.assertEqual(extract_sequence_features(arr[..., :3], arr[..., 3], np.ones(len(arr), bool)).shape, (317,))

    # 정규화: 골반 중심이 원점, 엉덩이 선이 +x, 사람 크기가 달라도 특징이 같다
    def test_normalize(self):
        x = self.rep()[None]
        P = pp.normalize(x)
        hip = (P[:, :, pp.L_HIP] + P[:, :, pp.R_HIP]) / 2
        self.assertLess(np.abs(hip).max(), 1e-6)
        hv = (P[:, :, pp.L_HIP] - P[:, :, pp.R_HIP]).mean(1)[0]
        self.assertGreater(hv[0], 0)
        self.assertAlmostEqual(hv[2], 0, places=6)
        np.testing.assert_allclose(pp.features(x * np.array([1.7, 1.7, 1.7, 1])), pp.features(x), atol=1e-4)

    # 학습 코드와 같은 계산인지: 회전 단계는 x 를 먼저 바꾼 뒤 그 값으로 z 를 구한다 (순수 회전 아님, 학습과 동일하게 유지)
    def test_normalize_matches_training_rotation(self):
        x = self.rep()[None].astype(np.float64)
        x[..., :3] = rotate_y(x[..., :3], 40)
        P = x[..., :3].copy()
        hip = (P[:, :, pp.L_HIP] + P[:, :, pp.R_HIP]) / 2
        sh = (P[:, :, pp.L_SH] + P[:, :, pp.R_SH]) / 2
        P = (P - hip[:, :, None]) / (np.linalg.norm(sh - hip, axis=2).mean(1)[:, None, None, None] + 1e-6)
        hv = (P[:, :, pp.L_HIP] - P[:, :, pp.R_HIP]).mean(1)[0]
        c, s = math.cos(-math.atan2(hv[2], hv[0])), math.sin(-math.atan2(hv[2], hv[0]))
        new_x = P[..., 0] * c - P[..., 2] * s
        new_z = new_x * s + P[..., 2] * c
        out = pp.normalize(x)
        np.testing.assert_allclose(out[..., 0], new_x, atol=1e-9)
        np.testing.assert_allclose(out[..., 2], new_z, atol=1e-9)

    # 한 프레임만 좌우가 뒤바뀌면 되돌린다
    def test_fix_lr(self):
        x = self.rep()[None]
        flipped = x.copy()
        flipped[0, 10] = flipped[0, 10][pp.SWAP]
        np.testing.assert_allclose(pp.fix_lr(flipped), x)

    # 사람을 못 찾은 프레임은 앞뒤 값으로 채운다
    def test_interpolate(self):
        arr = np.arange(5 * 33 * 4, dtype=np.float32).reshape(5, 33, 4)
        ok = np.array([True, False, True, True, False])
        filled = pp.interpolate(arr, ok)
        np.testing.assert_allclose(filled[1], (arr[0] + arr[2]) / 2)
        np.testing.assert_allclose(filled[4], arr[3])

    # 32프레임이 아닌 구간도 32프레임으로 맞춘다 (처음·끝 프레임 유지)
    def test_resample(self):
        arr = front_raise(cycles=1, seconds=3).astype(np.float32)
        out = pp.resample(arr)
        self.assertEqual(out.shape, (32, 33, 4))
        np.testing.assert_allclose(out[0], arr[0], atol=1e-6)
        np.testing.assert_allclose(out[-1], arr[-1], atol=1e-6)

    # 시작 자세에서 3번 반복하면 반복 3개, 경계는 시작 자세 근처
    def test_segment_reps(self):
        fps = 15
        arr = front_raise(seconds=6, fps=fps, cycles=3).astype(np.float32)
        reps = pp.segment_reps(arr, np.ones(len(arr), bool), fps)
        self.assertEqual(len(reps), 3)
        for a, b in reps:
            self.assertTrue(25 <= b - a <= 35, (a, b))
        self.assertLessEqual(reps[0][0], 3)

    # 거의 움직이지 않으면 영상 전체를 1회로 본다 (버티기 운동)
    def test_segment_static(self):
        arr = hold().astype(np.float32)
        self.assertEqual(pp.segment_reps(arr, np.ones(len(arr), bool), 15), [(0, len(arr) - 1)])

    # 반복 수 상한
    def test_segment_cap(self):
        fps = 30
        arr = front_raise(seconds=60, fps=fps, cycles=40).astype(np.float32)
        self.assertEqual(len(pp.segment_reps(arr, np.ones(len(arr), bool), fps)), pp.MAX_REPS)

    def test_base_pose_is_upright(self):
        self.assertLess(BASE[11][1], BASE[23][1])


if __name__ == '__main__':
    unittest.main()
