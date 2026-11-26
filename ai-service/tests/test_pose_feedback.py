import unittest

from mealfit_ai.services.pose_feedback import ISSUES, TIPS, feedback

NAME = '손목의 중립'
ISSUE = '손목이 꺾인 것으로 보여요.'
TIP = TIPS[NAME]


class PoseFeedbackTest(unittest.TestCase):
    # 모두 올바르면 횟수만 알려 준다 (팁 없음)
    def test_all_correct(self):
        self.assertEqual(feedback(NAME, 3, 3), '3회 모두 잘 지켜졌어요.')
        self.assertEqual(feedback(NAME, 1, 1), '잘 지켜졌어요.')

    # 기준과 다른 반복이 있으면 "무엇이 틀려 보이는지" + 교정 팁
    def test_issue_and_tip(self):
        self.assertEqual(feedback(NAME, 0, 1), f'{ISSUE} {TIP}')
        self.assertEqual(feedback(NAME, 0, 3), f'3회 모두 {ISSUE} {TIP}')
        self.assertEqual(feedback(NAME, 2, 5), f'5회 중 3회는 {ISSUE} {TIP}')

    # 문장·팁이 없는 조건은 일반 문장만
    def test_unknown_condition(self):
        self.assertEqual(feedback('없는 조건', 1, 2), '2회 중 1회는 기준과 달라 보여요.')

    # 측정 실패로 읽히는 "확인이 필요" 문구와 조건 이름 반복을 쓰지 않는다
    def test_wording(self):
        for correct in range(4):
            text = feedback(NAME, correct, 3)
            self.assertNotIn('확인이 필요', text)
            self.assertFalse(text.startswith(NAME))

    # 모든 조건에 문장과 팁이 짝으로 있고, 문장은 단정하지 않는 "~것으로 보여요."
    def test_sentences(self):
        self.assertGreaterEqual(len(ISSUES), 97)
        self.assertEqual(set(ISSUES), set(TIPS))
        for name in ISSUES:
            with self.subTest(name=name):
                self.assertTrue(ISSUES[name].endswith('것으로 보여요.'))
                self.assertTrue(TIPS[name].endswith('요.'))


if __name__ == '__main__':
    unittest.main()
