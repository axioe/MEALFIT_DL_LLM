from datetime import datetime, timedelta, timezone

from flask import jsonify
from werkzeug.exceptions import HTTPException

from mealfit_ai.errors import ServiceError

KST = timezone(timedelta(hours=9))


def error_body(status, code, message, field=None):
    """Spring ErrorResponse와 같은 모양으로 오류를 돌려준다."""
    return jsonify(status=status, code=code, message=message,
                   errors=[] if field is None else [{'field': field, 'message': message}],
                   timestamp=datetime.now(KST).isoformat()), status


def register_error_handlers(app):
    @app.errorhandler(ServiceError)
    def service_error(error):
        return error_body(error.status, error.code, error.message, error.field)

    @app.errorhandler(HTTPException)
    def http_error(error):
        return error_body(error.code, 'AI_001', '요청 경로·메서드·본문 크기를 확인해 주세요.')

    @app.errorhandler(Exception)
    def unexpected_error(_error):
        return error_body(500, 'AI_006', 'AI 서비스 처리 중 오류가 발생했습니다.')
