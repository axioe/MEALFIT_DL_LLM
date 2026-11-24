import base64
import io
import os
import queue
import tempfile
import unittest
from unittest.mock import Mock, patch

from PIL import Image
from mealfit_ai import create_app
from mealfit_ai.services.label_ocr_service import LabelOcrService
from tests.test_vision_api import image_bytes


class LabelOcrServiceTest(unittest.TestCase):
    # 실제 OCR 패키지 없이 검증된 이미지와 워커 대역을 준비함.
    def setUp(self):
        self.image = Image.new('RGB', (16, 16), 'white')
        self.service = LabelOcrService({'OCR_DET_MODEL_DIR': 'det', 'OCR_REC_MODEL_DIR': 'rec'})
        self.service._start = Mock()
        self.service.close = Mock()
        self.service.ready = True
        self.service.process = Mock()
        self.service.process.poll.return_value = None
        self.service.responses = Mock()

    # 워커 결과를 주입하며 이미지·텍스트 파일 저장이 없는지 검사함.
    def recognize(self, message):
        self.service.responses.get.return_value = message
        with patch('mealfit_ai.services.label_ocr_service.Path.is_dir', return_value=True):
            return self.service.recognize(self.image)

    # 모델 클래스 외 재료와 복수 재료가 독립 후보로 반환되는지 검사함.
    def test_success_and_separate_confidence(self):
        response = self.recognize({'status': 'SUCCESS', 'lines': [
            {'text': '상추·깻잎', 'confidence': .9}, {'text': '우유', 'confidence': .8}]})
        self.assertEqual(response['status'], 'SUCCESS')
        self.assertEqual([c['ingredientName'] for c in response['candidates']], ['상추', '깻잎', '우유'])
        self.assertNotIn('text', response)
        self.assertGreaterEqual(response['elapsedMs'], 0)

    # 글자 없음과 식재료명 없음 및 워커 장애를 구분함.
    def test_non_success_statuses(self):
        for message, status in [
            ({'status': 'SUCCESS', 'lines': []}, 'NO_TEXT'),
            ({'status': 'SUCCESS', 'lines': [{'text': '국내산 500g', 'confidence': .9}]}, 'NO_MATCH'),
            ({'status': 'UNAVAILABLE'}, 'UNAVAILABLE'), ({'status': 'ERROR'}, 'ERROR'), (None, 'ERROR')]:
            with self.subTest(status=status):
                response = self.recognize(message)
                self.assertEqual(response['status'], status)
                self.assertEqual(response['candidates'], [])

    # OCR 시간 초과가 별도 상태로 반환되고 워커가 종료되는지 검사함.
    def test_timeout_stops_worker(self):
        self.service.responses.get.side_effect = queue.Empty
        with patch('mealfit_ai.services.label_ocr_service.Path.is_dir', return_value=True):
            self.assertEqual(self.service.recognize(self.image)['status'], 'TIMEOUT')
        self.service.close.assert_called_once()
        self.assertTrue(self.service.lock.acquire(blocking=False))
        self.service.lock.release()

    # 동시에 들어온 OCR 요청은 쌓지 않고 빠르게 복귀함.
    def test_busy_returns_without_queueing(self):
        self.service.lock.acquire()
        try:
            with patch('mealfit_ai.services.label_ocr_service.Path.is_dir', return_value=True):
                self.assertEqual(self.service.recognize(self.image)['status'], 'TIMEOUT')
            self.service._start.assert_not_called()
        finally:
            self.service.lock.release()

    # 로컬 모델이 없으면 다운로드나 워커 실행 없이 복귀함.
    def test_missing_models(self):
        service = LabelOcrService({})
        with patch('mealfit_ai.services.label_ocr_service.subprocess.Popen') as start:
            self.assertEqual(service.recognize(self.image)['status'], 'UNAVAILABLE')
            start.assert_not_called()

    # 살아 있는 워커를 재사용하고 요청마다 모델을 새로 로드하지 않음.
    def test_existing_worker_reused(self):
        service = LabelOcrService({})
        service.process = Mock()
        service.process.poll.return_value = None
        with patch('mealfit_ai.services.label_ocr_service.subprocess.Popen') as start:
            service._start()
            start.assert_not_called()

    # 준비 중 요청은 대기하지 않고 기존 사진 분류로 복귀함.
    def test_warming_returns_immediately(self):
        self.service.ready = False
        self.service.warmup = Mock()
        with patch('mealfit_ai.services.label_ocr_service.Path.is_dir', return_value=True):
            result = self.service.recognize(self.image)
        self.assertEqual(result['status'], 'UNAVAILABLE')
        self.service.warmup.assert_called_once()
        self.service.responses.get.assert_not_called()

    # 준비 신호를 받은 뒤에만 OCR 모델을 사용할 수 있게 함.
    def test_warmup_ready_and_failure(self):
        for message, ready in [({'status': 'READY'}, True), ({'status': 'UNAVAILABLE'}, False)]:
            self.service.ready = False
            self.service.warming = True
            self.service.responses.get.return_value = message
            self.service._warm()
            self.assertEqual(self.service.ready, ready)
            self.assertFalse(self.service.warming)


class OcrVisionApiTest(unittest.TestCase):
    # 기존 분류 결과와 OCR 대역을 각각 준비함.
    def setUp(self):
        self.dl = {'modelVersion': 'test', 'candidates': [
            {'className': n, 'confidence': p} for n, p in [('ham', .9), ('squid', .06), ('carrot', .03)]]}
        self.predictor, self.ocr = Mock(), Mock()
        self.predictor.predict.return_value = self.dl
        with patch('mealfit_ai.load_dotenv'):
            self.app = create_app({'TESTING': True, 'VISION_PREDICTOR': self.predictor, 'OCR_PREDICTOR': self.ocr})
        self.client = self.app.test_client()

    # 같은 파일을 기존 API로 전송하고 이미지 저장은 수행하지 않음.
    def post(self):
        return self.client.post('/ai/vision/ingredients', data={'image': (io.BytesIO(image_bytes()), 'x.png')})

    # OCR과 모델이 충돌해도 각 출처와 확률을 그대로 보존함.
    def test_conflicting_sources(self):
        self.ocr.recognize.return_value = {'status': 'SUCCESS',
            'candidates': [{'ingredientName': '당근', 'textConfidence': .8}], 'elapsedMs': 15}
        response = self.post()
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json['candidates'], self.dl['candidates'])
        self.assertEqual(response.json['ocr']['candidates'][0]['ingredientName'], '당근')
        self.assertNotIn('ocr', self.dl)

    # 오류·시간 초과·글자 없음에서도 Top-3를 그대로 반환함.
    def test_ocr_failures_preserve_dl(self):
        for status in ['TIMEOUT', 'UNAVAILABLE', 'NO_TEXT', 'NO_MATCH', 'ERROR']:
            self.ocr.recognize.return_value = {'status': status, 'candidates': [], 'elapsedMs': 0}
            response = self.post()
            self.assertEqual(response.status_code, 200)
            self.assertEqual(response.json['candidates'], self.dl['candidates'])
        self.ocr.recognize.side_effect = RuntimeError('private text')
        response = self.post()
        self.assertEqual(response.json['ocr']['status'], 'ERROR')
        self.assertNotIn('private', response.get_data(as_text=True))

    # 손상 이미지는 두 모델을 실행하기 전에 차단함.
    def test_invalid_image_never_calls_ocr(self):
        self.assertEqual(self.client.post('/ai/vision/ingredients',
                         data={'image': (io.BytesIO(b'bad'), 'x.jpg')}).status_code, 400)
        self.ocr.recognize.assert_not_called()
        self.predictor.predict.assert_not_called()



class LabelOcrWorkerTest(unittest.TestCase):
    # 빈 모델 폴더는 OCR 라이브러리 로딩과 자동 다운로드 전에 차단함.
    def test_missing_model_files_never_load_engine(self):
        from mealfit_ai.services.label_ocr_worker import load_engine

        with tempfile.TemporaryDirectory() as directory:
            with patch.dict(os.environ, {'MEALFIT_OCR_DET_DIR': directory, 'MEALFIT_OCR_REC_DIR': directory}):
                with self.assertRaises(FileNotFoundError):
                    load_engine()

    # RGB 이미지를 OCR용 BGR로 전달하고 빈 글자를 결과에서 제외함.
    def test_pixels_and_empty_text(self):
        from mealfit_ai.services.label_ocr_worker import read_lines

        engine = Mock()
        engine.predict.return_value = [{'rec_texts': ['당근', '  '], 'rec_scores': [.9, .8]}]
        lines = read_lines(engine, base64.b64encode(image_bytes()).decode())
        self.assertEqual(lines, [{'text': '당근', 'confidence': .9}])
        pixels = engine.predict.call_args.kwargs['input']
        self.assertEqual(pixels.shape, (24, 32, 3))
        self.assertEqual(pixels[0, 0].tolist(), [0, 0, 255])

    # 지나치게 많은 라벨 글자가 워커 통신 한도를 넘지 않게 함.
    def test_bounded_output(self):
        from mealfit_ai.services.label_ocr_worker import read_lines

        engine = Mock()
        engine.predict.return_value = [{'rec_texts': ['가' * 256] * 200, 'rec_scores': [.9] * 200}]
        lines = read_lines(engine, base64.b64encode(image_bytes()).decode())
        self.assertLessEqual(sum(len(line['text']) for line in lines), 8192)
        self.assertLessEqual(len(lines), 128)
