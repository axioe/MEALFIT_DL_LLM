import io
import sys
import unittest
from unittest.mock import MagicMock, Mock, patch
from PIL import Image
from mealfit_ai import create_app
from mealfit_ai.errors import ServiceError
from mealfit_ai.services.ingredient_classifier import IngredientClassifier, read_image


# 작은 정상 이미지를 메모리에서 생성함.
def image_bytes(format='PNG'):
    buffer = io.BytesIO()
    Image.new('RGB', (32, 24), 'red').save(buffer, format=format)
    return buffer.getvalue()


class VisionApiTest(unittest.TestCase):
    # 비밀 설정을 읽지 않고 테스트 앱과 예측 대역을 준비함.
    def setUp(self):
        self.predictor = Mock()
        self.predictor.predict.return_value = {'modelVersion':'test', 'candidates':[
            {'className':name, 'confidence':score} for name,score in [('tomato',.7),('paprika',.2),('pepper',.1)]]}
        with patch('mealfit_ai.load_dotenv'):
            self.app = create_app({'TESTING':True, 'VISION_PREDICTOR':self.predictor})
        self.client = self.app.test_client()

    # 정상 파일 요청이 후보 세 개만 반환하는지 검사함.
    def test_success(self):
        response=self.client.post('/ai/vision/ingredients',data={'image':(io.BytesIO(image_bytes()),'test.png')})
        self.assertEqual(response.status_code,200)
        self.assertEqual(len(response.json['candidates']),3)
        self.assertEqual(set(response.json),{'modelVersion','candidates'})

    # 누락·잘못된 필드·손상 이미지를 차단함.
    def test_bad_requests(self):
        for data in ({},{'file':(io.BytesIO(image_bytes()),'x.png')},
                     {'image':(io.BytesIO(b'bad image'),'x.jpg')}):
            self.assertEqual(self.client.post('/ai/vision/ingredients',data=data).status_code,400)
        self.predictor.predict.assert_not_called()

    # 확장자가 아니라 실제 파일 형식으로 검사함.
    def test_unsupported_format(self):
        with self.assertRaises(ServiceError): read_image(image_bytes('GIF'))

    # 빈 이미지와 허용 크기 초과를 차단함.
    def test_invalid_size(self):
        for data in (b'',b'x'*(10*1024**2+1)):
            with self.assertRaises(ServiceError): read_image(data)

    # 모델 미설정이 서비스 사용 불가 오류로 반환되는지 검사함.
    def test_model_missing(self):
        classifier=IngredientClassifier({})
        with self.assertRaises(ServiceError) as caught: classifier.load()
        self.assertEqual(caught.exception.code,'VISION_002')

    # 예측 실패 시 기존 오류 형식을 유지함.
    def test_prediction_failure(self):
        self.predictor.predict.side_effect=ServiceError(500,'VISION_003','예측 실패')
        response=self.client.post('/ai/vision/ingredients',data={'image':(io.BytesIO(image_bytes()),'x.png')})
        self.assertEqual(response.status_code,500)
        self.assertEqual(response.json['code'],'VISION_003')

    # 기존 공용 업로드 제한은 다른 API에서 유지되는지 검사함.
    def test_existing_limit_unchanged(self):
        self.assertEqual(self.app.config['MAX_CONTENT_LENGTH'],1024**2)
        self.assertEqual(self.client.get('/health').status_code,200)

    # 실제 예측 처리 예외를 서비스 오류로 변환하는지 검사함.
    def test_service_prediction_exception(self):
        classifier=IngredientClassifier({})
        classifier.model=Mock(side_effect=RuntimeError('fixture'))
        classifier.transform=Mock()
        with patch.dict(sys.modules, {'torch': MagicMock()}):
            with self.assertRaises(ServiceError) as caught:
                classifier.predict(read_image(image_bytes()))
        classifier.model.assert_called_once()
        self.assertEqual(caught.exception.code,'VISION_003')

    # 예측 전에 최대 픽셀 수를 검사함.
    def test_large_dimensions(self):
        buffer=io.BytesIO()
        Image.new('L',(4001,4000)).save(buffer,format='PNG')
        with self.assertRaises(ServiceError): read_image(buffer.getvalue())


if __name__=='__main__':
    unittest.main()
