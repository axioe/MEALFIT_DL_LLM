"""자체 LLM(Ollama) 호출. 외부 AI API를 쓰지 않는다 (D14: gemma4:e2b · CPU · Ollama).

Ollama /api/chat 에 JSON 스키마(format)를 넘겨 구조화된 응답을 받는다.
LLM_BASE_URL 이 비어 있으면 호출하지 않고 503을 준다 → Spring이 검수 레시피로 대체한다.
"""
import json
import logging
import os
import socket
import time
import urllib.error
import urllib.request

from mealfit_ai.errors import ServiceError
from mealfit_ai.services.quick_recipe_service import RESPONSE_SCHEMA, SYSTEM_PROMPT

logger = logging.getLogger(__name__)

# 생성 옵션: 같은 입력이면 비슷한 결과가 나오도록 낮은 온도를 쓴다
OPTIONS = {'temperature': 0.3, 'num_ctx': 4096, 'num_predict': 2048}


def record_failure(error, started):
    # 요청 본문·응답 원문·서버 주소는 기록하지 않는다.
    logger.warning('LLM 호출 실패: exception=%s status=%s elapsed_ms=%d',
                   type(error).__name__, getattr(error, 'code', None), int((time.monotonic() - started) * 1000))


def build_body(request, model, system_prompt, response_schema):
    return {'model': model, 'stream': False, 'format': response_schema, 'think': False, 'keep_alive': '10m',
            'options': OPTIONS,
            'messages': [{'role': 'system', 'content': system_prompt},
                         {'role': 'user', 'content': json.dumps(request, ensure_ascii=False)}]}


def post(url, body, timeout):
    req = urllib.request.Request(url, json.dumps(body, ensure_ascii=False).encode('utf-8'),
                                 {'Content-Type': 'application/json'})
    with urllib.request.urlopen(req, timeout=timeout) as response:
        return json.loads(response.read().decode('utf-8'))


def generate(request, base_url, model, *, system_prompt=SYSTEM_PROMPT, response_schema=RESPONSE_SCHEMA,
             timeout=None):
    """요청 JSON을 자체 LLM에 보내고 응답 본문(JSON 문자열)을 돌려준다."""
    if timeout is None:
        # Spring 읽기 제한(AI_READ_TIMEOUT, 기본 20초)보다 짧게 둔다
        timeout = float(os.getenv('LLM_TIMEOUT_SECONDS', '18'))
    if not base_url:
        raise ServiceError(503, 'AI_002', '자체 LLM 서버(LLM_BASE_URL)가 설정되지 않았습니다.')
    started = time.monotonic()
    try:
        data = post(base_url.rstrip('/') + '/api/chat', build_body(request, model, system_prompt, response_schema),
                    timeout)
        content = (data.get('message') or {}).get('content')
        if not content:
            raise ValueError('empty content')
        return content
    except (TimeoutError, socket.timeout) as error:
        record_failure(error, started)
        raise ServiceError(504, 'AI_005', 'AI 추천 응답 시간이 초과되었습니다. 다시 시도해 주세요.') from None
    except urllib.error.URLError as error:
        if isinstance(getattr(error, 'reason', None), (TimeoutError, socket.timeout)):
            record_failure(error, started)
            raise ServiceError(504, 'AI_005', 'AI 추천 응답 시간이 초과되었습니다. 다시 시도해 주세요.') from None
        record_failure(error, started)
        raise ServiceError(502, 'AI_003', 'AI 추천 서비스 호출에 실패했습니다. 잠시 후 다시 시도해 주세요.') from None
    except Exception as error:
        record_failure(error, started)
        raise ServiceError(502, 'AI_003', 'AI 추천 서비스 호출에 실패했습니다. 잠시 후 다시 시도해 주세요.') from None
