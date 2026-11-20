# Flyway 마이그레이션

- **실행 경로: `postgresql/`** (application.yml의 `spring.flyway.locations`). 새 마이그레이션은 여기에 다음 번호로 추가한다.
- 이 폴더 바로 아래의 `V1`–`V7`은 MariaDB 시절 원본이다. 이력·체크섬 보존용으로 남겨 두고 실행하지 않는다. 수정하지 않는다.
- `postgresql/`의 `V1`–`V7`은 위 원본을 PostgreSQL 문법으로 옮긴 것이다 (버전·결과 스키마 동일).
- 테스트 전용 보정은 `src/test/resources/db/testdata/`에 있다 (운영에 적용되지 않음).
