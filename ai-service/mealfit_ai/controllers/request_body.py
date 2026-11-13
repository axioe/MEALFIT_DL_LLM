import json
from decimal import Decimal

from flask import request

from mealfit_ai.errors import ServiceError


def read_json_body():
    """요청 본문을 JSON으로 읽는다. 수량 정밀도를 지키려고 소수는 Decimal로 받는다."""
    if not request.is_json:
        raise ServiceError(415, 'AI_001', 'Content-Type을 application/json으로 설정해 주세요.')
    try:
        return json.loads(request.get_data(), parse_float=Decimal, parse_constant=lambda _: None)
    except (ValueError, UnicodeError):
        raise ServiceError(400, 'AI_001', '올바른 JSON 요청을 입력해 주세요.') from None
