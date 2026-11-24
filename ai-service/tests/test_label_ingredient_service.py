import unittest

from mealfit_ai.services.label_ingredient_service import extract_label_candidates


class LabelIngredientTest(unittest.TestCase):
    # 원산지와 별칭을 제거하되 수량을 추정하지 않는지 검사함.
    def test_origin_and_aliases(self):
        for text, name in [('국내산 당근 500g', '당근'), ('국내산당근', '당근'),
                           ('방울토마토 1.5kg', '토마토'), ('대추방울토마토', '토마토')]:
            with self.subTest(text=text):
                self.assertEqual(extract_label_candidates([{'text': text, 'confidence': .9}]),
                                 [{'ingredientName': name, 'textConfidence': .9}])

    # 한 줄과 여러 줄의 복수 재료를 각각 보존하는지 검사함.
    def test_multiple_ingredients(self):
        for lines in ([{'text': '상추·깻잎', 'confidence': .8}],
                      [{'text': '상추', 'confidence': .8}, {'text': '깻잎', 'confidence': .9}]):
            self.assertEqual([row['ingredientName'] for row in extract_label_candidates(lines)], ['상추', '깻잎'])

    # 브랜드·가공품·원재료 문장에서 부분 문자열을 확정하지 않는지 검사함.
    def test_not_product_evidence(self):
        for text in ['당근마켓', '토마토케첩', '햄버거', '고추장', '무지개', '국내산',
                     '500g 1+1', '원재료명 토마토', '당근 함유', '토마토맛있게', '브랜드 햄']:
            with self.subTest(text=text):
                self.assertEqual(extract_label_candidates([{'text': text, 'confidence': .99}]), [])

    # 기존 모델에 없는 재료도 OCR 후보로 유지하는지 검사함.
    def test_outside_model_classes(self):
        self.assertEqual(extract_label_candidates([{'text': '우유', 'confidence': .75}]),
                         [{'ingredientName': '우유', 'textConfidence': .75}])

    # 반복된 후보는 문자 신뢰도 최댓값만 보존하고 모델 확률과 결합하지 않음.
    def test_duplicate_candidates(self):
        self.assertEqual(extract_label_candidates([{'text': '방울토마토', 'confidence': .7},
                                                   {'text': '토마토', 'confidence': .95}]),
                         [{'ingredientName': '토마토', 'textConfidence': .95}])

    # 손상된 OCR 출력과 과도한 입력을 안전하게 무시하는지 검사함.
    def test_invalid_lines(self):
        for value in [None, {}, '당근', [None], [{'text': '당근', 'confidence': True}],
                      [{'text': '당근', 'confidence': float('nan')}],
                      [{'text': '당근', 'confidence': 1.1}],
                      [{'text': '당근', 'confidence': -1}],
                      [{'text': '당근' * 257, 'confidence': .9}],
                      [{'text': '당근', 'confidence': .9}] * 129]:
            with self.subTest(value_type=type(value).__name__):
                self.assertEqual(extract_label_candidates(value), [])

    # 문자 정규화를 적용하되 알 수 없는 식재료를 임의 생성하지 않음.
    def test_unicode_and_unknown(self):
        self.assertEqual(extract_label_candidates([{'text': '토마토　５００ｇ', 'confidence': .8}])[0]['ingredientName'], '토마토')
        self.assertEqual(extract_label_candidates([{'text': '모르는상품', 'confidence': .8}]), [])


if __name__ == '__main__':
    unittest.main()

