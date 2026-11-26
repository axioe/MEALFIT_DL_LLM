import unittest

from mealfit_ai.services.label_ingredient_service import extract_label_candidates


class LabelIngredientTest(unittest.TestCase):
    # 원산지와 별칭을 제거하되 수량을 추정하지 않는지 검사함.
    def test_origin_and_aliases(self):
        for text, name in [('국내산 당근 500g', '당근'), ('국내산당근', '당근'),
                           ('방울토마토 1.5kg', '방울토마토'), ('대추방울토마토', '방울토마토')]:
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
        self.assertEqual(extract_label_candidates([{'text': '대추방울토마토', 'confidence': .7},
                                                   {'text': '방울토마토', 'confidence': .95}]),
                         [{'ingredientName': '방울토마토', 'textConfidence': .95}])

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


    # 토마토는 두 종류만 유지하고 대추방울은 방울토마토 별칭으로 처리함.
    def test_only_regular_and_cherry_tomato(self):
        result = extract_label_candidates([{'text': '토마토·방울토마토·대추방울토마토', 'confidence': .9}])
        self.assertEqual([row['ingredientName'] for row in result], ['토마토', '방울토마토'])
        for text in ['방울 토마토', '대추방울 토마토']:
            self.assertEqual(extract_label_candidates([{'text': text, 'confidence': .8}])[0]['ingredientName'], '방울토마토')

    # 라벨의 맛별 우유를 각각 유지하며 브랜드와 원재료 설명은 제외함.
    def test_explicit_milk_types(self):
        for text, expected in [('흰우유', '흰우유'), ('백색우유', '흰우유'),
                               ('딸기우유', '딸기우유'), ('딸기맛 우유', '딸기우유'), ('딸기  우유', '딸기우유'),
                               ('초콜릿우유', '초코우유'), ('바나나 우유', '바나나우유')]:
            with self.subTest(text=text):
                self.assertEqual(extract_label_candidates([{'text': text, 'confidence': .9}]),
                                 [{'ingredientName': expected, 'textConfidence': .9}])
        for text in ['서울우유', '딸기우유맛과자', '원재료명 딸기우유', '초코우유 함유']:
            self.assertEqual(extract_label_candidates([{'text': text, 'confidence': .9}]), [])

    # 명시된 닭·돼지·소 부위명만 보존하고 식재료 ID를 추가하지 않음.
    def test_explicit_meat_cuts(self):
        for text, expected in [('닭가슴살', '닭가슴살'), ('닭 다리살', '닭다리살'),
                               ('닭날개', '닭날개'), ('닭안심', '닭안심'),
                               ('삼겹살', '삼겹살'), ('돼지고기 삼겹살', '삼겹살'), ('돼지목살', '목살'), ('닭고기 가슴살', '닭가슴살'),
                               ('돼지 등심', '돼지등심'), ('돼지갈비', '돼지갈비'),
                               ('소고기 등심', '소등심'), ('소안심', '소안심'),
                               ('앞다리살', '앞다리살'), ('소고기 양지', '양지')]:
            with self.subTest(text=text):
                result = extract_label_candidates([{'text': text, 'confidence': .9}])
                self.assertEqual(result, [{'ingredientName': expected, 'textConfidence': .9}])
                self.assertNotIn('ingredientId', result[0])

    # 일반명과 축종 불명 부위명에서 세부 종류를 만들어내지 않음.
    def test_general_names_never_infer_subtypes(self):
        for text in ['우유', '닭고기', '돼지고기', '소고기', '토마토']:
            self.assertEqual(extract_label_candidates([{'text': text, 'confidence': .8}]),
                             [{'ingredientName': text, 'textConfidence': .8}])
        for text in ['등심', '안심', '딸기맛', '닭가슴살맛과자', '원재료 닭가슴살']:
            self.assertEqual(extract_label_candidates([{'text': text, 'confidence': .8}]), [])

    # 복수 세부명도 별도 후보로 유지하고 문자 신뢰도를 합산하지 않음.
    def test_multiple_specific_types(self):
        rows = extract_label_candidates([{'text': '딸기우유·초코우유 / 닭가슴살·닭다리살', 'confidence': .88}])
        self.assertEqual([row['ingredientName'] for row in rows], ['딸기우유', '초코우유', '닭가슴살', '닭다리살'])
        self.assertTrue(all(row['textConfidence'] == .88 for row in rows))


if __name__ == '__main__':
    unittest.main()

