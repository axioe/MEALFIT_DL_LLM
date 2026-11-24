import json
import os
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import MagicMock, patch

ML = Path(__file__).resolve().parents[1] / 'ml'
sys.path.insert(0, str(ML))
from config import GpuConfig
from train import atomic_checkpoint, classification_metrics, detector_data_path, gpu_smoke, prepare_gpu, train_detector


class ColabTrainingTest(unittest.TestCase):
    # 탐지 학습과 최적 모델 검증이 valid 전용 계약을 유지하는지 검사함.
    def test_detector_contract_with_mock(self):
        fake_yolo, fake_settings, fake_torch = MagicMock(), MagicMock(), MagicMock()
        metrics = fake_yolo.return_value.val.return_value
        metrics.box.map50, metrics.box.map, metrics.box.mp, metrics.box.mr = .8, .6, .7, .9
        with tempfile.TemporaryDirectory() as directory, patch.dict(sys.modules, {
                'ultralytics': MagicMock(YOLO=fake_yolo, settings=fake_settings), 'torch': fake_torch}):
            root = Path(directory)
            data = root / 'data'
            (data / 'yolo').mkdir(parents=True)
            names = [f'ingredient_{index}' for index in range(51)]
            (data / 'class_indices.json').write_text(json.dumps({'yolo': dict(zip(names, range(51)))}))
            (data / 'validation_report.json').write_text('{}')
            (data / 'yolo/colab_data.yaml').write_text(json.dumps({'path': str(data / 'yolo'),
                'train': 'train/images', 'val': 'valid/images', 'nc': 51, 'names': names}))
            config = GpuConfig('yolo', dataset=data, weights=root / 'weights', output=root / 'runs')
            callback = MagicMock()
            result = train_detector(config, None, callback)
            args = fake_yolo.return_value.train.call_args.kwargs
            self.assertEqual(args['split'], 'val')
            self.assertFalse(args['amp'])
            self.assertEqual(args['batch'], 8)
            self.assertEqual(fake_yolo.return_value.val.call_args.kwargs['split'], 'val')
            self.assertEqual(result['map50_95'], .6)
            self.assertFalse(result['test_evaluated'])
            fake_yolo.return_value.add_callback.call_args.args[1](MagicMock(epoch=4))
            callback.assert_called_once_with('yolo', 5, config.output / 'yolo')

    # 저장 실패 시 기존 체크포인트가 보존되는지 검사함.
    def test_atomic_checkpoint_failure_preserves_previous(self):
        with tempfile.TemporaryDirectory() as directory, patch.dict(sys.modules, {'torch': MagicMock()}) as modules:
            path = Path(directory) / 'best.pt'
            path.write_bytes(b'previous checkpoint')
            modules['torch'].save.side_effect = OSError('fixture write failure')
            with self.assertRaises(OSError):
                atomic_checkpoint({}, path)
            self.assertEqual(path.read_bytes(), b'previous checkpoint')

    # T4 기본 배치와 기존 사전학습 경로 재사용을 검사함.
    def test_gpu_defaults(self):
        self.assertEqual(GpuConfig('efficientnet').dimensions(), (32, 224))
        self.assertEqual(GpuConfig('yolo').dimensions(), (8, 640))
        self.assertEqual(GpuConfig('yolo').weight_path().name, 'yolov8n.pt')

    # 잘못된 배치·학습 길이와 원본 내부 결과 경로를 차단함.
    def test_invalid_config(self):
        for config in (GpuConfig('yolo', batch_size=0), GpuConfig('yolo', epochs=0),
                       GpuConfig('yolo', epochs=101), GpuConfig('unknown'),
                       GpuConfig('yolo', output=Path('/content/mealfit/data/runs'))):
            with self.assertRaises(ValueError):
                config.validate()

    # Linux Colab 경로가 저장소 경로로 오인되지 않는지 검사함.
    def test_colab_paths(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            config = GpuConfig('yolo', dataset=root / 'data', weights=root / 'weights', output=root / 'runs')
            self.assertIs(config.validate(), config)

    # Top-k와 클래스별 F1을 고정 표본으로 검사함.
    def test_classification_metrics(self):
        result = classification_metrics([0, 1, 2], [0, 0, 2], [[0, 1], [0, 1], [2, 0]], 3)
        self.assertAlmostEqual(result['top1'], 2 / 3)
        self.assertEqual(result['top3'], 1)
        self.assertAlmostEqual(result['macro_f1'], (2 / 3 + 0 + 1) / 3)
        with self.assertRaises(ValueError):
            classification_metrics([], [], [])

    # GPU 점검이 5배치 승인 범위를 넘지 않는지 검사함.
    def test_gpu_smoke_limit(self):
        for batches in (0, 6):
            with self.assertRaises(ValueError):
                gpu_smoke(GpuConfig('yolo'), batches)

    # CUDA 미지원 시 모델 생성 전에 실행을 중단하는지 검사함.
    def test_no_cuda_fails_before_model(self):
        fake_torch = MagicMock()
        fake_torch.cuda.is_available.return_value = False
        with tempfile.TemporaryDirectory() as directory, patch.dict(os.environ), \
                patch.dict(sys.modules, {'torch': fake_torch, 'numpy': MagicMock()}):
            root = Path(directory)
            config = GpuConfig('yolo', dataset=root / 'data', weights=root / 'weights', output=root / 'runs')
            with self.assertRaisesRegex(RuntimeError, 'CUDA'):
                prepare_gpu(config)
            fake_torch.manual_seed.assert_not_called()

    # test와 다운로드 경로가 추가된 탐지 설정을 거부함.
    def test_detection_train_valid_only(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'yolo').mkdir()
            names = [f'ingredient_{index}' for index in range(51)]
            (root / 'class_indices.json').write_text(json.dumps({'yolo': dict(zip(names, range(51)))}))
            data = {'path': str(root / 'yolo'), 'train': 'train/images', 'val': 'valid/images',
                    'nc': 51, 'names': names}
            path = root / 'yolo/colab_data.yaml'
            path.write_text(json.dumps(data))
            config = GpuConfig('yolo', dataset=root)
            self.assertEqual(detector_data_path(config), path)
            for field in ('test', 'download'):
                path.write_text(json.dumps({**data, field: 'forbidden'}))
                with self.assertRaises(ValueError):
                    detector_data_path(config)


if __name__ == '__main__':
    unittest.main()
