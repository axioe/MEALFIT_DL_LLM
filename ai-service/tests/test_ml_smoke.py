import os
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

ML = Path(__file__).resolve().parents[1] / 'ml'
sys.path.insert(0, str(ML))
from config import SmokeConfig
from train import choose_indices, estimate_epoch, isolate_runtime, reserve_batch


class SmokeSafetyTest(unittest.TestCase):
    # SDK 설정이 외부 결과 폴더에 저장되도록 부모 경로를 검사함.
    def test_isolated_settings_parent(self):
        with tempfile.TemporaryDirectory() as directory, patch.dict(os.environ):
            config = SmokeConfig('yolo', output=Path(directory))
            isolate_runtime(config)
            self.assertTrue(Path(os.environ['YOLO_CONFIG_DIR']).is_dir())
            self.assertEqual(os.environ['YOLO_AUTOINSTALL'], 'false')
            self.assertEqual(os.environ['YOLO_OFFLINE'], 'true')

    # 승인된 배치와 스레드 범위를 검사함.
    def test_approved_limits(self):
        for batches in (0, 6):
            with self.assertRaises(ValueError):
                SmokeConfig('yolo', batches=batches).validate()
        with self.assertRaises(ValueError):
            SmokeConfig('yolo', threads=5).validate()

    # 결과가 데이터 내부에 저장되지 않는지 검사함.
    def test_protected_output(self):
        with self.assertRaises(ValueError):
            SmokeConfig('yolo', output=SmokeConfig('yolo').dataset / 'runs').validate()

    # 재실행 누적 배치 제한을 검사함.
    def test_cumulative_batch_budget(self):
        with tempfile.TemporaryDirectory() as directory:
            config = SmokeConfig('efficientnet', output=Path(directory))
            self.assertEqual([reserve_batch(config) for _ in range(5)], [1, 2, 3, 4, 5])
            with self.assertRaises(RuntimeError):
                reserve_batch(config)

    # 같은 시드의 train 표본 순서가 유지되는지 검사함.
    def test_fixed_seed_sampling(self):
        selected = choose_indices(100, 10, 42)
        self.assertEqual(selected, choose_indices(100, 10, 42))
        self.assertEqual(len(set(selected)), 10)
        with self.assertRaises(ValueError):
            choose_indices(2, 3, 42)

    # 에포크 외삽이 검증 시간을 포함하지 않는지 검사함.
    def test_epoch_estimate(self):
        result = estimate_epoch([2, 4], 17, 8)
        self.assertEqual(result['batches_per_epoch'], 3)
        self.assertEqual(result['train_compute_seconds_per_epoch'], 9)
        self.assertFalse(result['includes_validation_or_checkpointing'])

    # 모델별 입력 크기와 로컬 가중치 경로를 검사함.
    def test_model_dimensions(self):
        self.assertEqual(SmokeConfig('efficientnet').dimensions(), (8, 224))
        self.assertEqual(SmokeConfig('yolo').dimensions(), (2, 640))
        self.assertEqual(SmokeConfig('yolo').weight_path().name, 'yolov8n.pt')


if __name__ == '__main__':
    unittest.main()
