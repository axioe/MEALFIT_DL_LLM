import io
import unittest
from unittest.mock import Mock, patch
from PIL import Image

from mealfit_ai import create_app
from mealfit_ai.services.receipt_parser import parse_receipt, ordered_rows


# 사진이나 개인정보 없이 가상의 OCR 행을 생성함
def lines(*values):
    return [{'text': value, 'confidence': .99} for value in values]


class ReceiptParserTest(unittest.TestCase):
    # 수량과 가격의 산술 관계가 맞는 표 형식만 해석함
    def test_quantity_price_and_date(self):
        result = parse_receipt(lines('2026-11-26', '당근 1000 2 2000', '방울토마토 3000 1 3000'))
        self.assertEqual(result['purchaseDate'], '2026-11-26')
        self.assertEqual(len(result['items']), 2)
        self.assertEqual(result['items'][0]['quantity'], '2')
        self.assertEqual(result['items'][0]['price'], '2000')
        self.assertTrue(result['items'][0]['requiresConfirmation'])

    # 가격만 보이는 경우 수량과 중량을 추정하지 않음
    def test_price_is_not_quantity(self):
        item = parse_receipt(lines('토마토 5000'))['items'][0]
        self.assertIsNone(item['quantity'])
        self.assertIsNone(item['unit'])
        self.assertEqual(item['price'], '5000')

    # 상품 중량과 구매 포장 수량을 분리함
    def test_package_and_weight(self):
        item = parse_receipt(lines('닭가슴살 1kg 2팩 8000'))['items'][0]
        self.assertEqual((item['quantity'], item['unit']), (None, None))
        self.assertEqual((item['netQuantity'], item['netUnit']), ('1', 'kg'))

    # 결제·개인정보·비식품·할인·반품 행은 저장 후보에서 제외함
    def test_excluded_rows(self):
        for text in ['합계 10000', '할인 토마토 1000', '반품 당근 1000', '취소 닭가슴살 5000',
                     '회원 토마토 123456789', '카드 1234567890123456', '세제 1000', '비누 2000', '봉투 100', '당근 1000 -1 -1000']:
            with self.subTest(text=text):
                self.assertEqual(parse_receipt(lines(text))['items'], [])

    # 알려진 세부 식재료는 상위명으로 합치지 않음
    def test_detailed_names(self):
        for text, expected in [('대추방울토마토 3000', '방울토마토'), ('국내산 삼겹살 8000', '삼겹살'),
                               ('딸기맛 우유 2000', '딸기우유'), ('목살 5000', '목살')]:
            self.assertEqual(parse_receipt(lines(text))['items'][0]['ingredientName'], expected)

    # 줄바꿈된 상품명과 다음 수량 표를 제한적으로 연결함
    def test_multiline(self):
        item = parse_receipt(lines('방울토마토', '3000 2 6000'))['items'][0]
        self.assertEqual((item['ingredientName'], item['quantity']), ('방울토마토', '2'))

    # 같은 이름의 실제 구매 행은 임의로 합치지 않음
    def test_repeated_products_are_preserved(self):
        self.assertEqual(len(parse_receipt(lines('당근 1000', '당근 1000'))['items']), 2)

    # 위치가 같은 중복 검출만 제거하고 좌우 문자 조각을 정렬함
    def test_boxes(self):
        def box(text, x):
            return {'text': text, 'confidence': .99, 'box': [[x, 0], [x+20, 0], [x+20, 12], [x, 12]]}
        result = ordered_rows([box('1000 2 2000', 50), box('당근', 0), box('당근', 0)])
        self.assertEqual(result, [('당근 1000 2 2000', .99)])

    # 낮은 신뢰도와 불확실한 일반 상품명은 확인된 식재료로 취급하지 않음
    def test_uncertain_and_empty(self):
        self.assertEqual(parse_receipt([])['status'], 'NO_TEXT')
        self.assertEqual(parse_receipt(lines('알수없는상품 1000'))['status'], 'NO_ITEMS')
        self.assertEqual(parse_receipt([{'text':'당근 1000', 'confidence':.1}])['items'], [])

    # 여러 날짜가 보이거나 잘못된 날짜는 구매일로 확정하지 않음
    def test_uncertain_date(self):
        self.assertIsNone(parse_receipt(lines('2026-02-30', '당근 1000'))['purchaseDate'])
        self.assertIsNone(parse_receipt(lines('2026-11-25', '2026-11-26'))['purchaseDate'])

    # 한국어 상품명과 영어 중량·숫자를 함께 처리함
    def test_mixed_text(self):
        item = parse_receipt(lines('닭가슴살 500g 1팩 3000'))['items'][0]
        self.assertEqual(item['netQuantity'], '500')

    # 상품 유형은 맛 이름보다 우선하며 사진 라벨 사전은 변경하지 않음
    def test_product_type_priority(self):
        for text, expected in [('신라면 5개입', '라면'), ('불닭볶음면 치즈맛', '라면'),
                               ('치즈 라면', '라면'), ('치즈맛 라면', '라면'),
                               ('서울우유 딸기우유', '딸기우유')]:
            with self.subTest(text=text):
                self.assertEqual(parse_receipt(lines(text))['items'][0]['ingredientName'], expected)

    # 명시된 규격과 구매 묶음만 곱하고 포장만 보이면 미확정으로 반환함
    def test_explicit_stock_proposals(self):
        examples = [('삼겹살 600g', '600', 'g'), ('방울토마토 500g', '500', 'g'),
                    ('사과 3개', '3', '개'), ('우유 1L × 2개', '2', 'L'),
                    ('신라면 5개입 × 2봉', '10', '개'), ('계란 10구 × 2판', '20', '개'),
                    ('삼겹살 600g × 2팩', '1200', 'g'), ('우유 500mL × 3개', '1500', 'mL'), ('우유 500mL × 3개 6000', '1500', 'mL')]
        for text, quantity, unit in examples:
            with self.subTest(text=text):
                item = parse_receipt(lines(text))['items'][0]
                self.assertEqual((item['quantity'], item['unit']), (quantity, unit))
                self.assertEqual(item['quantityStatus'], 'PROPOSED')
        for text in ['신라면 5개입', '닭가슴살 1kg 2팩 8000', '우유 1L 2개', '우유 1L 500mL', '우유 1 × 2개']:
            with self.subTest(text=text):
                item = parse_receipt(lines(text))['items'][0]
                self.assertIsNone(item['quantity'])
                self.assertEqual(item['quantityStatus'], 'UNCERTAIN')

    # 가격표 구매 수량과 상품 규격을 분리해 계산함
    def test_specification_with_price_table(self):
        item = parse_receipt(lines('신라면 5개입 4000 2 8000'))['items'][0]
        self.assertEqual((item['packageCount'], item['purchaseQuantity'], item['quantity']), ('5', '2', '10'))
        self.assertEqual(item['price'], '8000')

    # 수량이 없는 상품명이 연속해도 앞의 품목을 유실하지 않음
    def test_consecutive_product_names(self):
        result = parse_receipt(lines('불닭볶음면 치즈맛', '서울우유 딸기우유'))
        self.assertEqual([item['ingredientName'] for item in result['items']], ['라면', '딸기우유'])


    # 수량·금액 검산을 통과한 상품만 미확인 후보로 보존함
    def test_unmapped_verified_product(self):
        item = parse_receipt(lines('마트자체상품 1500 2 3000'))['items'][0]
        self.assertEqual(item['ingredientName'], '')
        self.assertEqual(item['quantity'], '2')
        self.assertEqual(parse_receipt(lines('마트자체상품 1500'))['items'], [])
        self.assertEqual(parse_receipt(lines('카드 승인 1500 2 3000'))['items'], [])


class ReceiptApiTest(unittest.TestCase):
    # 외부 OCR과 실제 환경변수를 사용하지 않는 앱을 준비함
    def setUp(self):
        self.predictor = Mock()
        self.predictor.recognize.return_value = parse_receipt(lines('당근 1000 2 2000')) | {'elapsedMs': 12}
        with patch('mealfit_ai.load_dotenv'):
            self.app = create_app({'TESTING':True, 'RECEIPT_PREDICTOR':self.predictor, 'OCR_PREDICTOR':Mock()})
        buffer = io.BytesIO()
        Image.new('RGB', (30, 40), 'white').save(buffer, format='PNG')
        self.image = buffer.getvalue()

    # 이미지 분석은 사용자 확인 후보만 반환함
    def test_success(self):
        response = self.app.test_client().post('/ai/ocr/receipt', data={'image':(io.BytesIO(self.image),'receipt.png')})
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json['items'][0]['ingredientName'], '당근')
        self.assertNotIn('storeName', response.json)

    # 파일 누락·손상·불필요한 필드를 거부함
    def test_invalid_files(self):
        for body in [{}, {'image':(io.BytesIO(b'bad'),'x.jpg')},
                     {'image':(io.BytesIO(self.image),'x.png'), 'userId':'1'}]:
            self.assertEqual(self.app.test_client().post('/ai/ocr/receipt', data=body).status_code, 400)

    # 한도를 넘는 파일은 OCR 호출 전에 차단함
    def test_large(self):
        response = self.app.test_client().post('/ai/ocr/receipt', data={'image':(io.BytesIO(b'x'*(10*1024**2+1)),'x.jpg')})
        self.assertEqual(response.status_code, 400)
        self.predictor.recognize.assert_not_called()





class ReceiptWorkerTest(unittest.TestCase):
    # 상품 라벨과 영수증은 같은 워커를 사용하며 영수증에만 좌표 모드를 요청함
    def test_shared_worker_and_receipt_mode(self):
        import json
        from mealfit_ai.services.receipt_ocr_service import ReceiptOcrService
        worker = Mock(ready=True)
        worker.lock.acquire.return_value = True
        worker.process.poll.return_value = None
        worker.responses.get.return_value = {'status': 'SUCCESS', 'lines': lines('당근 3개')}
        result = ReceiptOcrService({}, worker=worker).recognize(Image.new('RGB', (40, 40), 'white'))
        self.assertEqual(result['items'][0]['quantity'], '3')
        payload = json.loads(worker.process.stdin.write.call_args.args[0])
        self.assertEqual(payload['mode'], 'receipt')
        worker.lock.release.assert_called_once()

    # 시간 초과는 워커를 정리하고 저장 성공이나 빈 결과로 바꾸지 않음
    def test_worker_timeout_and_busy(self):
        import queue
        from mealfit_ai.errors import ServiceError
        from mealfit_ai.services.receipt_ocr_service import ReceiptOcrService
        worker = Mock(ready=True)
        worker.lock.acquire.return_value = True
        worker.process.poll.return_value = None
        worker.responses.get.side_effect = queue.Empty
        service = ReceiptOcrService({}, worker=worker)
        with self.assertRaises(ServiceError):
            service.recognize(Image.new('RGB', (30, 30), 'white'))
        worker.close.assert_called_once()
        worker.lock.release.assert_called_once()
        worker.lock.acquire.return_value = False
        with self.assertRaises(ServiceError):
            service.recognize(Image.new('RGB', (30, 30), 'white'))

    # 흰 여백만 제거하고 비흰색 내용 및 빈 이미지 크기는 보존함
    def test_white_margin_crop(self):
        from mealfit_ai.services.receipt_ocr_service import prepare_receipt_image
        image = Image.new('RGB', (200, 200), 'white')
        self.assertEqual(prepare_receipt_image(image).size, (200, 200))
        image.putpixel((100, 100), (0, 0, 0))
        result = prepare_receipt_image(image)
        self.assertEqual(result.getpixel((16, 16)), (0, 0, 0))
        self.assertEqual(image.size, (200, 200))


class ReceiptRuntimeRegressionTest(unittest.TestCase):
    # 브랜드가 붙은 우유는 맛 이름을 보존해 상품 유형으로 분류함
    def test_branded_milk(self):
        for product, expected in [('서울우유 1L × 2개', '우유'), ('매일우유 500mL', '우유'),
                                  ('서울우유 딸기우유', '딸기우유'), ('연세우유 초코우유', '초코우유')]:
            with self.subTest(product=product):
                self.assertEqual(parse_receipt(lines(product))['items'][0]['ingredientName'], expected)

    # 진단 정보에는 문자 원문이나 결제 번호 대신 건수만 남김
    def test_diagnostics_contain_only_counts(self):
        diagnostics = {}
        result = parse_receipt(lines('당근 2개', '합계 2000', '세제 1000', '알수없는상품 3000'), diagnostics)
        self.assertEqual(len(result['items']), 1)
        self.assertEqual(diagnostics['excluded_private_or_financial'], 1)
        self.assertEqual(diagnostics['excluded_nonfood'], 1)
        self.assertTrue(all(isinstance(value, int) for value in diagnostics.values()))

    # 승인된 로컬 OCR 모델과 CPU 가속만 사용하며 다운로드 설정은 만들지 않음
    def test_cpu_acceleration_uses_existing_models(self):
        import sys
        from mealfit_ai.services.label_ocr_worker import load_engine
        paddle = Mock()
        with patch.dict(sys.modules, {'paddleocr': paddle}), patch.dict('os.environ', {
                'MEALFIT_OCR_DET_DIR': 'local-det', 'MEALFIT_OCR_REC_DIR': 'local-rec'}), \
                patch('pathlib.Path.is_file', return_value=True):
            load_engine()
        self.assertTrue(paddle.PaddleOCR.call_args.kwargs['enable_mkldnn'])
        self.assertEqual(paddle.PaddleOCR.call_args.kwargs['text_recognition_model_dir'], 'local-rec')

    # Windows의 실제 소켓에서도 같은 포트로 두 번째 서버 생성을 거부함
    def test_windows_port_collision_rejected(self):
        import contextlib
        import app as entry
        from flask import Flask
        from werkzeug.serving import BaseWSGIServer, make_server
        with patch.object(BaseWSGIServer, 'allow_reuse_address', True), patch('app.os.name', 'nt'):
            entry.configure_local_server()
            self.assertFalse(BaseWSGIServer.allow_reuse_address)
            server = make_server('127.0.0.1', 0, Flask('port-test'))
            try:
                with contextlib.redirect_stderr(io.StringIO()), self.assertRaises(SystemExit):
                    make_server('127.0.0.1', server.server_port, Flask('duplicate-test'))
            finally:
                server.server_close()


if __name__ == '__main__':
    unittest.main()
