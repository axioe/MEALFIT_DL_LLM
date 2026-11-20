-- 테스트 전용 (운영 마이그레이션 아님). application-test.yml의 flyway.locations에서만 읽는다.
-- 일부 테스트(TestUserFixture)가 users에 고정 ID를 직접 넣는다. PostgreSQL의 IDENTITY는
-- MariaDB AUTO_INCREMENT와 달리 직접 넣은 ID만큼 다음 값을 올리지 않으므로,
-- 회원가입으로 생기는 ID가 고정 ID와 겹치지 않게 시작 값을 띄워 둔다.
ALTER TABLE users ALTER COLUMN id RESTART WITH 1000000;
