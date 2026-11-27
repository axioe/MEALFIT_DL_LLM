"""비기능 테스트 — AI 서비스 (pytest·unittest 양쪽에서 실행).

성능: 요청·응답 검증 처리 시간 (LLM 호출 제외, 서버 몫의 처리 비용)
가용성: LLM이 꺼져 있거나(설정 없음)·연결이 안 되거나·응답이 멈췄을 때 제한 시간 안에 안전한 오류로 끝나는지
보안: 본문 크기 제한, 오류 응답·로그에 내부 주소·요청 원문이 남지 않는지
결과 수치는 환경 변수 NF_REPORT가 있으면 그 경로에 JSON으로 남긴다 (테스트 보고서용).
"""
import json
import os
import socket
import statistics
import threading
import time
import unittest
from datetime import date

from app import create_app
from mealfit_ai.clients.ollama_client import generate
from mealfit_ai.schemas.validation import validate_request as validate_quick_request
from mealfit_ai.services import meal_plan_service
from mealfit_ai.services.quick_recipe_service import validate_response as validate_quick_response

TODAY = date(2026, 10, 22)
QUICK_BODY = {'ingredients': [{'name': '달걀', 'quantity': 4, 'unit': '개', 'expirationDate': '2026-10-25'},
                              {'name': '양파', 'quantity': '0.3', 'unit': 'kg'}],
              'selectedIngredients': ['달걀'], 'maxCookingMinutes': 15, 'recommendationCount': 3}
QUICK_RESPONSE = {'recipes': [{'title': f'달걀 양파 볶음 {n}', 'description': '간단한 볶음 요리', 'cookingMinutes': 10,
                               'servings': 1, 'ingredients': [{'name': '달걀', 'quantity': '2', 'unit': '개'},
                                                             {'name': '양파', 'quantity': '50', 'unit': 'g'}],
                               'steps': ['양파를 썰어 주세요.', '달걀과 함께 충분히 익혀 주세요.'], 'reason': '보유 재료 활용'}
                              for n in range(3)]}
MEAL_BODY = {'planDate': '2026-10-23', 'mealTypes': ['BREAKFAST', 'LUNCH', 'DINNER'], 'servings': 1, 'goal': 'LOSE',
             'cookTimeMin': 20, 'mealBudget': 8000, 'allergies': ['땅콩'], 'excludedIngredients': ['새우'], 'keptMeals': [],
             'recentMeals': [], 'inventory': [{'ingredientName': '두부', 'quantity': 300, 'unit': 'g',
                                               'expiryDate': '2026-10-23', 'expirationStatus': 'IMMINENT'}]}
MEAL_RESPONSE = [{'mealType': k, 'recipeName': k + ' 두부 요리', 'description': '보유 재료 활용', 'servingSize': 1,
                  'cookTimeMin': 15, 'calories': '600', 'proteinG': '40.1', 'carbsG': '50', 'fatG': '20',
                  'ingredients': [{'name': '두부', 'quantity': '150', 'unit': 'g'}],
                  'steps': ['두부를 준비하고 충분히 익힘.'], 'reason': '임박 재료 활용'} for k in ['BREAKFAST', 'LUNCH', 'DINNER']]

RESULTS = {}


def p95(samples):
    ordered = sorted(samples)
    return ordered[max(0, int(len(ordered) * 0.95) - 1)]


def measure(label, fn, runs=1000):
    for _ in range(50):
        fn()
    ms = []
    for _ in range(runs):
        start = time.perf_counter()
        fn()
        ms.append((time.perf_counter() - start) * 1000)
    RESULTS[label] = {'runs': runs, 'p50_ms': round(statistics.median(ms), 3), 'p95_ms': round(p95(ms), 3),
                      'max_ms': round(max(ms), 3)}
    return RESULTS[label]


def hung_server():
    """연결은 받지만 응답하지 않는 서버 (LLM이 멈춘 상황)."""
    server = socket.socket()
    server.bind(('127.0.0.1', 0))
    server.listen(5)
    conns = []

    def accept():
        try:
            while True:
                conn, _ = server.accept()
                conns.append(conn)
        except OSError:
            pass

    threading.Thread(target=accept, daemon=True).start()
    return server, conns


class PerformanceTests(unittest.TestCase):
    """요청·응답 검증 처리 시간: 1,000회 p95 ≤ 5ms (LLM 생성 시간 18초 제한에 비해 무시할 수준이어야 함)."""

    def test_15분_요리_요청_응답_검증_p95(self):
        def run():
            req = validate_quick_request(json.loads(json.dumps(QUICK_BODY)), TODAY)
            validate_quick_response(json.dumps(QUICK_RESPONSE, ensure_ascii=False), req)
        self.assertLessEqual(measure('15분 요리 요청·응답 검증', run)['p95_ms'], 5)

    def test_하루_세_끼_요청_응답_검증_p95(self):
        def run():
            req = meal_plan_service.validate_request(json.loads(json.dumps(MEAL_BODY)), TODAY)
            meal_plan_service.validate_response(json.dumps(MEAL_RESPONSE, ensure_ascii=False), req)
        self.assertLessEqual(measure('하루 세 끼 요청·응답 검증', run)['p95_ms'], 5)


class AvailabilityTests(unittest.TestCase):
    """LLM 장애 시 정해진 시간 안에 정해진 오류 코드로 끝나야 Spring이 검수 레시피로 대체할 수 있다."""

    def setUp(self):
        self.app = create_app({'TESTING': True, 'TODAY': lambda: TODAY, 'GENERATOR': generate,
                               'OCR_PREDICTOR': object(), 'RECEIPT_PREDICTOR': object()})
        self.client = self.app.test_client()

    def send(self):
        start = time.perf_counter()
        response = self.client.post('/ai/quick-recipes', data=json.dumps(QUICK_BODY, ensure_ascii=False),
                                    content_type='application/json')
        return response, (time.perf_counter() - start) * 1000

    def test_LLM_설정이_없으면_즉시_503(self):
        self.app.config['LLM_BASE_URL'] = ''
        response, ms = self.send()
        RESULTS['LLM 미설정 → 503 응답 시간'] = {'ms': round(ms, 1)}
        self.assertEqual(response.status_code, 503)
        self.assertEqual(response.json['code'], 'AI_002')
        self.assertLess(ms, 200)

    def test_LLM_서버가_꺼져_있으면_빠르게_502(self):
        probe = socket.socket()
        probe.bind(('127.0.0.1', 0))
        port = probe.getsockname()[1]
        probe.close()  # 아무도 듣지 않는 포트
        self.app.config['LLM_BASE_URL'] = f'http://127.0.0.1:{port}'
        response, ms = self.send()
        RESULTS['LLM 연결 거부 → 502 응답 시간'] = {'ms': round(ms, 1)}
        self.assertEqual(response.status_code, 502)
        self.assertEqual(response.json['code'], 'AI_003')
        self.assertLess(ms, 3000)

    def test_LLM이_응답하지_않으면_제한_시간에_504(self):
        server, conns = hung_server()
        try:
            port = server.getsockname()[1]
            self.app.config['LLM_BASE_URL'] = f'http://127.0.0.1:{port}'
            os.environ['LLM_TIMEOUT_SECONDS'] = '1'
            response, ms = self.send()
        finally:
            os.environ.pop('LLM_TIMEOUT_SECONDS', None)
            server.close()
            for c in conns:
                c.close()
        RESULTS['LLM 무응답(제한 1초) → 504 응답 시간'] = {'ms': round(ms, 1)}
        self.assertEqual(response.status_code, 504)
        self.assertEqual(response.json['code'], 'AI_005')
        self.assertGreaterEqual(ms, 900)
        self.assertLess(ms, 2500)


class SecurityTests(unittest.TestCase):

    def setUp(self):
        self.app = create_app({'TESTING': True, 'TODAY': lambda: TODAY, 'GENERATOR': generate,
                               'OCR_PREDICTOR': object(), 'RECEIPT_PREDICTOR': object()})
        self.client = self.app.test_client()

    def test_1MB를_넘는_본문은_413(self):
        big = dict(QUICK_BODY, note='가' * (1024 * 1024))
        response = self.client.post('/ai/quick-recipes', data=json.dumps(big, ensure_ascii=False),
                                    content_type='application/json')
        self.assertEqual(response.status_code, 413)

    def test_알_수_없는_필드는_LLM에_넘기지_않고_400(self):
        body = dict(QUICK_BODY, email='leak@example.test', userId=7)
        response = self.client.post('/ai/quick-recipes', data=json.dumps(body), content_type='application/json')
        self.assertEqual(response.status_code, 400)

    def test_오류_응답과_로그에_내부_주소와_요청_원문이_남지_않는다(self):
        self.app.config['LLM_BASE_URL'] = 'http://internal-llm-host.local:11434'
        with self.assertLogs('mealfit_ai.clients.ollama_client', level='WARNING') as logs:
            response = self.client.post('/ai/quick-recipes', data=json.dumps(QUICK_BODY, ensure_ascii=False),
                                        content_type='application/json')
        body = response.get_data(as_text=True)
        joined = ' '.join(logs.output)
        self.assertIn(response.status_code, (502, 504))
        for secret in ('internal-llm-host', '11434', '달걀', '양파'):
            self.assertNotIn(secret, body)
            self.assertNotIn(secret, joined)


def tearDownModule():
    path = os.environ.get('NF_REPORT')
    if path:
        with open(path, 'w', encoding='utf-8') as fh:
            json.dump(RESULTS, fh, ensure_ascii=False, indent=2)


if __name__ == '__main__':
    unittest.main()
