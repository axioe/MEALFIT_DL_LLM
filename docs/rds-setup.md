# Amazon RDS for PostgreSQL 준비 절차

운영 DB를 EC2 안의 컨테이너에서 Amazon RDS for PostgreSQL 16으로 옮긴다.
기존 MariaDB·컨테이너 데이터는 옮기지 않고 **빈 DB로 새로 시작**한다 (2026-11-20 결정).
테이블과 기본 레시피 데이터는 백엔드가 처음 뜰 때 Flyway(V1–V8)가 만든다.

> 비밀값(RDS 엔드포인트, 비밀번호, 인증서 파일)은 EC2 서버의 `.env`와 `/etc/mealfit/`에만 둔다. 저장소·문서·채팅에 적지 않는다.

## 1. RDS 생성 (AWS 콘솔, 서울 리전)

| 항목 | 값 |
|---|---|
| 엔진 | PostgreSQL 16 (최신 마이너) |
| 템플릿 | 프리 티어 또는 개발/테스트 |
| 인스턴스 | db.t4g.micro (부족하면 db.t4g.small) |
| 스토리지 | gp3 20GB, 자동 확장 최대 50GB |
| DB 이름(초기 데이터베이스) | `mealfit` |
| 마스터 사용자 | 관리용 계정 (앱에서 쓰지 않는다) |
| 퍼블릭 액세스 | 아니요 |
| VPC·보안 그룹 | EC2와 같은 VPC. 인바운드 5432는 **EC2 보안 그룹만** 허용 |
| 백업 보존 | 7일 |
| 다중 AZ | 아니요 (비용) |

pgvector는 RDS PostgreSQL에 기본 포함되어 있어 별도 파라미터 그룹이 필요 없다.

## 2. 관리 계정으로 한 번 실행 (EC2에서 psql 또는 SSH 터널 DBeaver)

```sql
-- mealfit DB에 접속해서 실행
CREATE EXTENSION IF NOT EXISTS vector;          -- V8(recipe_embeddings)에 필요. 앱 계정은 만들 권한이 없다

CREATE ROLE mealfit LOGIN;                      -- 앱 전용 계정
\password mealfit                               -- 비밀번호는 화면에만 입력하고 서버 .env의 DB_PASSWORD에 넣는다

GRANT CONNECT ON DATABASE mealfit TO mealfit;
GRANT USAGE, CREATE ON SCHEMA public TO mealfit; -- PostgreSQL 15부터 public 스키마 CREATE가 기본으로 막혀 있다
```

Flyway가 앱 계정으로 테이블을 만들기 때문에 테이블 소유자는 `mealfit`이 된다. 마스터 계정은 확장·계정 관리에만 쓴다.

## 3. EC2 서버 준비

```bash
# RDS 인증서 번들 (TLS 인증서 검증용)
sudo mkdir -p /etc/mealfit
sudo curl -o /etc/mealfit/rds-global-bundle.pem https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem

# .env (cp .env.prod.example .env 후)
DB_URL=jdbc:postgresql://<RDS 엔드포인트>:5432/mealfit?sslmode=verify-full&sslrootcert=/etc/mealfit/rds-global-bundle.pem
DB_USERNAME=mealfit
DB_PASSWORD=<2단계에서 정한 값>
```

`docker-compose.prod.yml`에는 DB 컨테이너가 없다. `DB_URL`이 비어 있으면 compose가 시작을 거부한다.

## 4. 첫 기동과 확인

```bash
docker compose -f docker-compose.prod.yml up -d --build --remove-orphans   # 옛 mealfit-postgres 컨테이너를 정리한다
docker compose -f docker-compose.prod.yml logs backend | grep -i flyway     # "Successfully applied 8 migrations" 확인
```

- 옛 컨테이너 DB 볼륨(`mealfit-pg`)은 새로 시작하므로 쓰지 않는다. 확인이 끝나면 `docker volume rm mealfit_mealfit-pg`로 지운다
- 자동 배포는 저장소 변수 `DEPLOY_ENABLED=true`일 때만 돈다. RDS·서버 준비가 끝나기 전에는 켜지 않는다

## 5. 비용·운영 메모

- RDS를 **중지**해도 7일이 지나면 AWS가 자동으로 다시 시작한다. 중지 중에도 스토리지·백업 비용은 나간다
- 오래 쓰지 않을 때는 스냅샷을 남기고 삭제한 뒤, 필요할 때 스냅샷에서 복원하는 편이 싸다 (복원하면 엔드포인트가 바뀌므로 `DB_URL` 수정)
- 시각 컬럼은 `TIMESTAMP(6)`(서울 시간 기준)을 유지한다. enum 값 CHECK 제약은 넣지 않는다 (2026-11-20 결정)

## CI와의 관계

CI 통합 검사(develop → main)에는 RDS가 없으므로 `docker-compose.ci.yml`이 PostgreSQL(+pgvector) 컨테이너를 붙여
`docker compose -f docker-compose.prod.yml -f docker-compose.ci.yml up`으로 운영과 같은 구성을 띄운다.
