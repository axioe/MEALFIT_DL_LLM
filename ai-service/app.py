"""실행 진입점: python app.py

앱 구성은 mealfit_ai 패키지(create_app)에 있다. 테스트와 기존 호출부를 위해 create_app·generate_meals를 다시 내보낸다.
"""
import os

from mealfit_ai import create_app
from mealfit_ai.services.meal_plan_service import generate_meals

__all__ = ['create_app', 'generate_meals', 'get_port']


def get_port():
    try:
        port = int(os.getenv('PORT', '8000'))
        if not 1 <= port <= 65535:
            raise ValueError()
        return port
    except ValueError:
        raise ValueError('PORT는 1~65535 사이의 정수로 설정해 주세요.') from None


if __name__ == '__main__':
    app = create_app()
    # 로컬은 127.0.0.1, 운영 컨테이너는 HOST=0.0.0.0 (docker-compose.prod.yml)으로 backend가 접근한다
    app.run(host=os.getenv('HOST', '127.0.0.1'), port=get_port(), debug=False)
