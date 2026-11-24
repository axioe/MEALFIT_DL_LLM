# MealFit (밀핏)

냉장고 재고를 기반으로 AI가 3끼 식단을 추천하고, 장보기 → 조리 → 섭취 기록까지 한 흐름으로 연결하는 식단 관리 웹 서비스.

> **심화 단계 저장소 (MEALFIT_DL_LLM).** 1차 프로젝트 [axioe/MealFit](https://github.com/axioe/MealFit)의 main(2026-11-13, MVC 정리 완료)을 이력째 옮겨 와서 DL·LLM 심화 작업을 이어 간다. 운영 배포 중이며 `main` 머지가 곧 EC2 자동 배포다. AI 도구 작업 규칙은 [AGENTS.md](AGENTS.md)를 따른다.

> 발표: 2026-10-23 (금) · 시연 범위: 회원가입·프로필 → 냉장고 재고 등록 → AI 3끼 추천과 서버 검증 → 확정과 장보기 목록 → 조리 차감·취소 복원 → 섭취 기록 → 대시보드

## 현재 구현 상태 (2026-11-24, `develop` 기준)

회원·마이페이지부터 **재고 → 식단 추천·확정 → 장보기 → 조리**까지 화면과 API가 연결되어 동작한다. 15분 요리 추천은 Flask + Gemini로 연결되어 있고 자체 모델로 전환할 예정이다. **하루 3끼 AI 추천, 섭취 기록, 대시보드 API, 운동 화면 연결, 체중**이 남아 있다.

| 기능 | 백엔드 API | 프론트 화면 | 남은 일 |
|---|---|---|---|
| 회원가입·이메일 인증·로그인·로그아웃·탈퇴 (JWT) | ✅ | ✅ | |
| 마이페이지 (신체·식단·운동 설정·체력 측정) | ✅ | ✅ | |
| 스마트 냉장고 (입고·조정·폐기·이력) | ✅ | ✅ | |
| 식단 추천·재추천·확정·취소 | ✅ (로컬 대체 레시피) | ✅ | 하루 3끼 AI 연결 (`MealPlanAiClient` 구현) |
| 레시피 상세·인분 환산 | ✅ | ✅ | |
| 자동 장보기 (부족분·부분 구매·입고) | ✅ | ✅ | |
| 조리 차감·사용량 수정·식단 없는 조리·취소 복원 | ✅ | ✅ | |
| 15분 요리 AI 추천 (Spring → Flask → Gemini) | ✅ | ✅ | 자체 모델 전환 (운영은 `GEMINI_API_KEY`가 있을 때만 동작) |
| 대시보드 | ❌ | ⚠️ 일부 예시 데이터 (`api/dashboard.js`의 `MOCK`) | `GET /dashboard` |
| 섭취 기록 (먹음/건너뜀) | ❌ (테이블·엔티티만) | ⚠️ 예시 데이터 | `POST /intake-logs` |
| 운동 루틴 (규칙 엔진) | ✅ 추천·현재 루틴 | ⚠️ 화면만 | 화면 연결, 완료 기록 |
| 캘린더·체중 | ❌ | ⚠️ 화면만 | API |

- 대시보드의 예시 데이터는 `frontend/src/api/dashboard.js`의 `MOCK` 값으로 영역별로 끈다. API가 완성되면 `false`로 바꾼다.
- 하루 3끼 추천은 `MealPlanAiClient` 구현 빈이 없어 검증된 로컬 대체 레시피(`V2__seed_fallback_recipes.sql`)를 쓴다. 프로필의 알레르기·제외 재료는 `UserDietProfileProviderImpl`로 식단 확정과 15분 요리 추천 검증에 반영된다.

## 개요서와 달라진 점

| 항목 | 개요서 | 실제 |
|---|---|---|
| AI 엔진 | OpenAI API | **Gemini API** (`google-genai` SDK) |
| AI 서비스 | Python FastAPI | **Python Flask** (`ai-service/`) |
| DB | MySQL 또는 PostgreSQL | **PostgreSQL 16 (+pgvector)**. 운영은 Amazon RDS for PostgreSQL (2026-11 MariaDB에서 전환) |
| 디자인 | Figma | 사용 안 함. AI Studio 프로토타입 화면을 기준으로 바로 구현 |
| 프론트 언어 | React + TypeScript | **React + JavaScript** (`.js` / `.jsx`) |
| Spring Boot | 3.x | 3.5.16 (Java 21) |

## 폴더 구조 (MVC)

세 서비스 모두 **Controller(요청 처리) → Model(비즈니스 로직·데이터) → View(응답·화면)** 로 나눈다.

```
MealFit/
├─ backend/                       Spring Boot (REST API, 도메인 로직, 서버 검증)
│  └─ src/main/java/com/mealfit/
│     ├─ global/                  security(JWT), exception, config, common(BaseTimeEntity, StatusTransition), web(@CurrentUserId)
│     └─ domain/{도메인}/          모든 도메인이 같은 하위 구조
│        ├─ controller/           REST 컨트롤러 (Controller)
│        ├─ service/              비즈니스 로직·검증, 다른 도메인과 맞물리는 인터페이스
│        ├─ repository/           Spring Data JPA
│        ├─ entity/               JPA 엔티티와 상태 enum (Model)
│        ├─ model/                DB에 저장하지 않는 값 객체 (Quantity, CookingPlan, UserDietProfile …)
│        ├─ dto/                  요청·응답 (View로 나가는 모양)
│        └─ client/ config/ exception/   외부 AI 호출, 설정, 도메인 예외 (필요한 도메인만)
│        도메인: auth, user, inventory, mealplan, recipe, shopping, cooking, intake, workout, ai
├─ backend/src/main/resources/db/migration/postgresql/   V1–V7, V9–V11 (V8은 db/vendor/postgresql/)
├─ ai-service/                    Python Flask + Gemini
│  ├─ app.py                      실행 진입점 (python app.py)
│  ├─ mealfit_ai/
│  │  ├─ __init__.py              create_app (설정·Blueprint·오류 처리 등록)
│  │  ├─ controllers/             /health, /ai/quick-recipes, /ai/meal-plans 라우트와 오류 응답 (Controller)
│  │  ├─ services/                15분 요리·하루 식단 프롬프트와 응답 검증 (Model)
│  │  ├─ schemas/                 요청 본문 검증
│  │  ├─ clients/                 Gemini 호출
│  │  └─ errors.py
│  └─ tests/
├─ frontend/                      React + JavaScript + Vite
│  ├─ src/
│  │  ├─ api/                     서버 요청 함수만 (client.js: axios·토큰·401 재발급, queryKeys.js, mocks/) — Model(데이터)
│  │  ├─ models/                  화면 로직·검증 규칙 순수 함수 (조리·장보기·추천·프로필 폼 …) — Model(규칙)
│  │  ├─ stores/                  authStore.js (Zustand, 로그인 세션) — Model(상태)
│  │  ├─ hooks/                   TanStack Query 훅: 불러오기·저장·캐시 갱신 흐름 — Controller
│  │  ├─ pages/                   화면 단위 (Dashboard, Recommend, Fridge, Shopping, MyPage …) — View
│  │  ├─ components/              layout/ common/ dashboard/ profile/ recommend/ shopping/ — View
│  │  │  └─ prototype/            아직 연결하지 않은 디자인 시안 (어디서도 import하지 않음)
│  │  ├─ routes/                  router.jsx (페이지별 지연 로딩), RequireAuth
│  │  └─ lib/                     enums.js, labels.js, 날짜·기한·숫자 형식, queryClient
│  └─ tests/                      Node 기본 테스트 (*.test.mjs, models/ 대상)
├─ AGENTS.md                      AI 도구 작업 규칙
├─ docs/                          보조 문서 (quick-ai.md: 15분 요리 AI 계약, rds-setup.md: RDS 준비)
├─ docker-compose.yml             로컬 PostgreSQL (pgvector/pgvector:pg16)
├─ docker-compose.prod.yml        운영(EC2) 구성 (DB는 RDS)
├─ docker-compose.ci.yml          CI 통합 검사용 (운영 구성 + PostgreSQL 컨테이너)
└─ .env.example, .env.prod.example
```

## 로컬 실행

**준비물:** JDK 17 이상(21이 없으면 Gradle이 자동으로 받음), Node.js 24, Docker Desktop(또는 로컬 PostgreSQL 16). 15분 요리 AI까지 확인하려면 Python 3과 Gemini API 키.

```bash
cp .env.example .env                        # 아래 JWT_SECRET 설정 필수
docker compose up -d                        # PostgreSQL + pgvector (5432)
cd backend && ./gradlew bootRun             # http://localhost:8080  (Windows: gradlew.bat bootRun)
cd frontend && npm install && npm run dev   # http://localhost:5173
```

- **`JWT_SECRET`은 필수다.** `application.yml`에 기본값이 없어서 없으면 Spring이 뜨지 않는다. `.env`의 `# JWT_SECRET=` 주석을 풀고 `openssl rand -base64 48`로 만든 값을 넣는다. Spring은 루트 `.env`를 읽는다.
- 5432 포트를 이미 쓰고 있으면(로컬 PostgreSQL 등) `.env`에서 `DB_PORT=5433`으로 바꾼다.
- **MariaDB 시절 `.env`를 그대로 쓰면 접속이 안 된다.** `DB_PORT=3306` 등이 남아 있으면 `.env.example`을 다시 복사하고 `JWT_SECRET`만 옮긴다 (2026-11 PostgreSQL 전환).
- Docker Desktop은 BIOS 가상화(Intel VT-x/AMD-V)가 켜져 있어야 한다. 끌 수 없는 PC는 아래 **Docker 없이 실행**을 따른다.

**Docker 없이 실행 (Windows에 PostgreSQL 16 직접 설치)**

1. [PostgreSQL 16 Windows 설치 파일](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads)로 설치한다 (포트 5432, Stack Builder는 건너뛰어도 된다).
2. pgAdmin 또는 DBeaver에서 관리 계정(`postgres`)으로 접속해 앱 계정과 DB를 만든다. 값은 `.env`와 같게 맞춘다.
   ```sql
   CREATE ROLE mealfit LOGIN PASSWORD 'mealfit';
   CREATE DATABASE mealfit OWNER mealfit;
   ```
3. Windows용 PostgreSQL에는 pgvector가 없어서 V8(`recipe_embeddings`, 레시피 검색용)이 실패한다. 로컬에서는 `.env`에 아래 한 줄을 넣어 V8만 건너뛴다. 화면 흐름(회원·냉장고·식단·장보기·조리)은 모두 동작한다.
   ```
   spring.flyway.locations=classpath:db/migration/postgresql
   ```
   벡터 검색까지 확인하려면 Docker의 `pgvector/pgvector:pg16`을 쓴다. **V8을 건너뛴 DB에서 이 줄만 지우면 안 된다.** 이미 V9 이후가 적용돼 있어 Flyway 검증 오류로 백엔드가 뜨지 않는다. pgvector가 있는 DB를 새로 만들어 연결하고 이 줄을 지운다.
4. 이후는 위와 같이 `backend`·`frontend`를 실행한다.

**현재 화면에서 예시 데이터인 부분:** 대시보드의 식단·운동·체중·AI 코칭 영역과 섭취 기록(먹었어요/건너뛰었어요)은 아직 API가 없어 예시 데이터다 (`frontend/src/api/dashboard.js`의 `MOCK`). 냉장고·식단 추천·확정·장보기·조리·취소는 실제 DB로 동작한다.
- **회원가입 후 이메일 인증을 해야 로그인된다.** 기본(`MAIL_PROVIDER=log`)은 메일을 보내지 않고 인증 링크를 백엔드 콘솔에 출력한다. 실제 발송이 필요할 때만 `.env`에 SMTP 값을 넣는다.
- **로컬 백엔드를 운영 DB(RDS)에 연결하지 않는다.** 실행만 해도 작업 중인 마이그레이션이 운영에 적용될 수 있다.
- 테이블은 Spring 실행 시 Flyway가 자동으로 만든다. 예전 스키마로 실행한 적이 있어 Flyway 오류가 나면 `docker compose down -v` 후 다시 띄운다.
- **Swagger:** http://localhost:8080/swagger-ui.html (로그인 응답의 `accessToken`을 Authorize에 넣는다)
- 모든 API는 로그인이 필요하다(회원가입·로그인·재발급·로그아웃 제외). 사용자는 JWT의 회원 ID로만 식별한다.
- 프론트는 `/api` 요청을 Vite 프록시로 8080에 넘기므로 CORS 설정이 필요 없다.

**15분 요리 AI (선택)**: 자세한 내용은 [`ai-service/README.md`](ai-service/README.md), [`docs/quick-ai.md`](docs/quick-ai.md)

```bash
cd ai-service
python -m venv .venv && .venv/Scripts/python -m pip install -r requirements.txt   # macOS/Linux: .venv/bin/python
cp .env.example .env                        # GEMINI_API_KEY 입력 (키는 이 파일에만 둔다)
.venv/Scripts/python app.py                 # http://127.0.0.1:8000
```

- Spring은 `AI_SERVICE_URL`(기본 `http://localhost:8000`)로 Flask를 부른다. Flask 포트를 바꾸면 이 값도 같이 바꾼다.
- Flask가 꺼져 있으면 15분 요리 추천은 `QUICK_AI_002`(503) 오류를 낸다. 하루 3끼 추천은 Flask와 관계없이 로컬 대체 레시피로 동작한다.

**테스트**
- 백엔드: `cd backend && ./gradlew test` (H2 메모리 DB). CI는 `PG_TEST_URL`로 실제 PostgreSQL 검증도 하고, 그 테스트가 건너뛰어지면 실패한다
- 프론트: `cd frontend && npm run lint && npm test && npm run build`
- AI 서비스: `cd ai-service && .venv/Scripts/python -m unittest -v` (Gemini SDK를 mock해서 외부 호출 없음)

## 배포 (AWS EC2)

**서비스 주소: http://3.39.100.188**

EC2 한 대에서 Docker Compose로 frontend(nginx) · backend(Spring) · ai-service를 띄우고, DB는 Amazon RDS for PostgreSQL 16(+pgvector)을 쓴다. 외부에 열리는 포트는 80뿐이고, nginx가 `/api`를 Spring으로 넘긴다. RDS 준비 절차는 [docs/rds-setup.md](docs/rds-setup.md).

```
브라우저 ──80──▶ frontend(nginx) ──/api──▶ backend(:8080) ──TLS──▶ Amazon RDS PostgreSQL(:5432)
                                                     └──────▶ ai-service(:8000)
```

### 자동 배포 (GitHub Actions)

> **운영 중 (2026-11-20 재개).** 저장소 변수 `DEPLOY_ENABLED=true`라서 **`main` 머지 = EC2 자동 배포**다. 변수를 끄면 테스트·빌드만 돈다.

`main`에 push(PR 머지 포함)되고 통합 검사까지 통과하면 EC2에 자동 배포된다. 전체 약 10분.

```
main push ─▶ backend (test) ─┐
          ├▶ frontend (lint, build) ─┤
          └▶ ai-service (test) ──────┴▶ integration ─▶ deploy (EC2): git pull → docker compose up --build → 화면·API 응답 확인
```

| 이벤트 | 테스트 | 배포 |
|---|---|---|
| PR (`main` 대상) | ✅ | ❌ |
| `main` push (PR 머지) | ✅ | ✅ (테스트 통과 시) |
| Actions → CI → **Run workflow** (`main`) | ✅ | ✅ 코드 변경 없이 다시 배포할 때 |

- 배포 결과는 Actions 탭의 `deploy (EC2)`에서 본다. **헬스체크가 실패해도 이미 새 컨테이너로 교체된 뒤라, 서버가 직전 버전으로 자동 복구되지는 않는다.** 실패하면 서버 로그를 확인하고 바로 고친다
- **`main`에 머지되는 순간 새 Flyway 마이그레이션이 운영 DB에 적용된다.** 머지 전에 로컬에서 꼭 확인하고, 이미 머지된 `V*.sql`은 수정하지 않는다
- 설정: `.github/workflows/ci.yml`의 `deploy` 작업. 서버 IP는 `EC2_HOST`(파일 안), SSH 키는 Secret `EC2_SSH_KEY`
- 서버의 `.env`(DB 비밀번호, JWT 키 등)는 git이 무시하는 파일이라 배포해도 바뀌지 않는다. 새 환경 변수가 생기면 서버에 직접 추가한다

### 서버 구성

- 파일: `docker-compose.prod.yml`, `docker-compose.ci.yml`(CI 전용), `docs/rds-setup.md`, `backend/Dockerfile`, `frontend/Dockerfile`, `frontend/nginx.conf`, `.env.prod.example`, `application-prod.yml`
- EC2: Ubuntu 24.04, t3.small(2GB + 스왑 2GB), 서울 리전
- 보안 그룹: 22(자동 배포 때문에 전체, 키 파일로만 접속), 80(전체). 8080·8000은 열지 않는다. RDS 보안 그룹은 5432를 EC2 보안 그룹에서만 허용

**최초 1회 (서버에서)**
```bash
sudo apt update && sudo apt install -y docker.io docker-compose-v2 git
sudo usermod -aG docker ubuntu   # 다시 접속해야 적용
git clone https://github.com/axioe/MEALFIT_DL_LLM.git && cd MEALFIT_DL_LLM
sudo mkdir -p /etc/mealfit && sudo curl -o /etc/mealfit/rds-global-bundle.pem https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem
cp .env.prod.example .env        # DB_URL(RDS), DB_PASSWORD, JWT_SECRET 채우기
docker compose -f docker-compose.prod.yml up -d --build --remove-orphans
```

**수동 배포 (자동 배포가 안 될 때만)**
```bash
cd ~/MEALFIT_DL_LLM && git pull && docker compose -f docker-compose.prod.yml up -d --build --remove-orphans
```

- 로그: `docker compose -f docker-compose.prod.yml logs -f backend`
- 운영에서는 Swagger를 끈다(`application-prod.yml`). API 확인은 로컬에서 한다
- DB 접속(DBeaver): SSH 터널(SSH 탭에 EC2 주소·`ubuntu`·키 파일, Main 탭 Host는 RDS 엔드포인트). RDS는 퍼블릭 접속을 열지 않는다

## 담당 영역

| 담당 | 백엔드 | 프론트엔드 |
|---|---|---|
| 김영현 (PL) | `global/*`, 배포·CI, 리뷰 | 공통 구조 (`api/client.js`, `routes`, `components/layout`) |
| 백가연 (PM) | API 명세(Swagger) 관리, QA 시나리오 | |
| 김수현 | **스마트 냉장고** `domain/inventory` | **스마트 냉장고** `pages/FridgePage`, `pages/Recommend·Shopping·RecipeDetail` 화면, `components/common` |
| 박희진 | `ai-service/` (Flask + Gemini), `domain/ai` 연동 | |
| 유지훈 | **운동** (Phase 1), `domain/shopping·cooking·recipe·mealplan`, 서버 검증 | **운동** `pages/WorkoutPage` |
| 최원석 | **로그인·회원가입·마이페이지** `domain/auth`, `domain/user`, `domain/intake`, 대시보드 API | `pages/LoginPage`, `pages/SignupPage`, `pages/MyPage`, `pages/DashboardPage`, (Phase 1) 캘린더·체중 |

## API

브라우저는 Spring `/api/v1/**`만 호출한다. Spring이 내부망으로 Python AI 서비스 `/ai/**`를 부른다. 요청·응답 형식은 Swagger(로컬)에서 본다. 아래 경로는 `/api/v1`을 생략했다.

| 상태 | 영역 | Method | Endpoint | 설명 |
|---|---|---|---|---|
| ✅ | 인증 | POST | `/auth/signup`, `/auth/login` | 회원가입(인증 메일 발송, 자동 로그인 없음), 로그인(이메일 인증 필요) |
| ✅ | 인증 | POST | `/auth/email-verification/confirm`, `/auth/email-verification/resend` | 이메일 인증 완료, 인증 메일 재발송 |
| ✅ | 인증 | POST | `/auth/refresh`, `/auth/logout` | 토큰 재발급(HttpOnly 쿠키, Refresh 1회용), 로그아웃. `X-Requested-With` 헤더 필요 |
| ✅ | 회원 | GET / DELETE | `/me` | 내 계정, 회원 탈퇴(비밀번호 확인) |
| ✅ | 마이페이지 | GET / PUT | `/me/profile` | 목표·알레르기·조리 시간·예산·제외 재료 |
| ✅ | 마이페이지 | GET | `/me/profile/details` | 모든 탭 조회 |
| ✅ | 마이페이지 | PUT | `/me/profile/details/{common, trainer, diet, fitness, tests}` | 탭별 저장 |
| ✅ | 냉장고 | GET / POST | `/inventory/lots` | 재료별 합계와 재고 묶음 조회, 입고 |
| ✅ | 냉장고 | PATCH | `/inventory/lots/{id}` | 수량·정보 조정, 부분·전량 폐기 (이력 자동 기록) |
| ✅ | 냉장고 | GET | `/inventory/transactions?lotId=` | 재고 변경 이력 |
| ✅ | 식단 | GET | `/meal-plans?date=` | 날짜별 식단 |
| ✅ | 식단 | POST | `/meal-plans/recommend` | 하루 세 끼 추천 초안 |
| ✅ | 식단 | POST | `/meal-plans/{id}/regenerate` | 한 끼 재추천 |
| ✅ | 식단 | POST | `/meal-plans/{id}/confirm`, `/{id}/cancel` | 서버 검증 후 확정(부족분 계산), 취소 |
| ✅ | 레시피 | GET | `/recipes/{id}?servings=` | 레시피 상세, 인분 환산 |
| ✅ | 장보기 | GET / PATCH | `/shopping-items` | 부족분(조회 시 재계산), 부분 구매 반영 |
| ✅ | 장보기 | POST | `/shopping-items/stock-in` | 구매분 냉장고 입고 |
| ✅ | 조리 | GET / POST | `/cooking/preview` | 차감 미리보기(GET), 사용량 수정 미리보기(POST) |
| ✅ | 조리 | POST | `/cooking-events`, `/cooking-events/{id}/cancel` | 확정 식단 조리(재고 차감), 취소(원본 복원) |
| ✅ | 조리 | POST | `/cooking/ingredients/preview`, `/cooking-events/ingredients` | 식단 없는 조리 미리보기·완료 |
| ✅ | AI | POST | `/quick-recipes/recommend` | 본인 재고로 15분 요리 추천 (저장·차감 없음) |
| ✅ | 운동 | POST / GET | `/workout-routines/recommend`, `/workout-routines/current` | 루틴 추천(규칙 엔진), 현재 루틴 |
| ❌ | 대시보드 | GET | `/dashboard?date=` | 오늘의 식단, 기한 임박 재료, 부족분 |
| ❌ | 섭취 | POST | `/intake-logs` | 먹음/건너뜀 기록 |
| ✅ | (내부) ai-service | POST / GET | `/ai/quick-recipes`, `/health` | Flask → Gemini 15분 요리 추천, 상태 확인 |
| ❌ | (내부) ai-service | POST | `/ai/meal-plans` | 하루 3끼 AI 식단 |

## 개발 규칙

### 브랜치 · 커밋
```
feature/* ──PR──▶ develop(벽) ──PR──▶ main ──자동──▶ 운영 배포
```
- `main`: 검증이 끝난 코드만 있는 브랜치. **develop 또는 `hotfix/*`에서 온 PR만** 받는다 (CI의 `source branch` 검사가 막는다)
- `develop`: 팀원 작업을 모아 함께 돌려 보는 벽 브랜치. 저장소 기본 브랜치이며 모든 작업 PR은 여기로 보낸다
- 작업 브랜치: `develop`에서 만든다. `feature/{영역}-{내용}` 예) `feature/inventory-stock-in`, `fix/auth-refresh`
- 커밋 메시지: `feat: 재고 입고 API`, `fix: ...`, `refactor: ...`, `docs: ...`
- PR 올리기 전에 `develop`을 작업 브랜치에 먼저 합쳐서(pull) 충돌을 풀고, 로컬에서 실행해 본다
- 둘 다 직접 push 금지, PR로만 머지한다
- 머지된 작업 브랜치는 삭제한다 (`develop`·`main`은 지우지 않는다)

| 단계 | CI 검사 |
|---|---|
| 작업 브랜치 → `develop` | `backend (test)` · `frontend (lint, build)` (단위 테스트 포함) · `ai-service (test)` |
| `develop` → `main` | 위 검사 + `source branch` + `integration (docker compose)` (운영과 같은 구성으로 전체 컨테이너를 띄워 응답 확인) |

- 급한 수정: `main`에서 `hotfix/*`를 만들어 main으로 PR → 머지 후 `main`을 `develop`에도 합친다
- `deploy (EC2)`는 `main` push에서만 실행된다. PR과 `develop`에서는 건너뜀이 정상이다

### DB 스키마 (Flyway)
- 스키마는 `backend/src/main/resources/db/migration/postgresql`의 SQL로만 바꾼다 (`ddl-auto: validate`)
- `db/migration/` 바로 아래의 V1–V7은 MariaDB 시절 이력으로 보관만 하고 더 이상 실행하지 않는다 (체크섬 보존)
- pgvector처럼 실제 PostgreSQL에서만 되는 마이그레이션은 `db/vendor/postgresql/`에 두고 번호는 이어서 매긴다 (V8 = `recipe_embeddings`, 레시피 검색). RDS에서는 관리 계정으로 `CREATE EXTENSION vector;`를 먼저 실행한다
- 테스트는 H2(PostgreSQL 모드)로 돌고, CI의 backend 작업은 실제 PostgreSQL(pgvector/pgvector:pg16)에서 마이그레이션·엔티티 검증(`PostgresSchemaIntegrationTest`)을 함께 돈다
- PostgreSQL IDENTITY는 ID를 직접 넣어도 다음 값이 올라가지 않는다. 데이터 이관 뒤에는 시퀀스를 `setval`로 맞춘다
- 현재 V1(핵심 업무 테이블) · V2(로컬 대체 레시피) · V3(회원·프로필) · V4(Refresh Token) · V5(식단 없는 조리) · V6(마이페이지 상세) · V7(탈퇴 시각) · V8(레시피 임베딩, vendor) · V9(이메일 인증) · V10(운동 사전) · V11(운동 루틴). 애플리케이션 테이블 24개
- **이미 머지된 `V*.sql`은 절대 수정하지 않는다.** 변경은 `db/migration/postgresql/`에 다음 번호의 새 파일 `V12__설명.sql` (2026-11-24 기준, 최신 develop에서 다시 확인)
- 같은 날 여러 명이 마이그레이션을 만들면 번호가 겹칠 수 있으니 단톡방에 번호를 먼저 말하고 쓴다
- 수량은 `NUMERIC(12,3)` + `BigDecimal`, 시각은 `TIMESTAMP(6)` + `LocalDateTime`, enum은 `VARCHAR(20)` + `@Enumerated(EnumType.STRING)`

### 백엔드
- 패키지: 새 클래스는 `domain/{도메인}/` 아래 `controller/ service/ repository/ entity/ model/ dto/` 중 역할에 맞는 곳에 둔다 (도메인 바로 아래에 두지 않는다)
- 현재 사용자: 컨트롤러 파라미터에 `@CurrentUserId Long userId`. JWT로 인증된 회원 ID만 들어오고, 요청의 `userId`·`X-User-Id`는 무시한다
- 다른 사용자 데이터 접근 방지: 조회는 `findByIdAndUserId(id, userId)` 형태로
- 에러: `throw new BusinessException(ErrorCode.XXX)` → 자동으로 아래 형식 응답. 새 에러는 `ErrorCode`에 도메인 접두어로 추가 (`INVENTORY_001`)
  ```json
  { "status": 404, "code": "INVENTORY_001", "message": "재고를 찾을 수 없습니다.", "errors": [], "timestamp": "..." }
  ```
- 상태 변경은 엔티티 메서드에서 `status.validateTransition(next)`로 허용된 전이만 통과 (`MealPlanStatus`, `CookingStatus`, `IntakeStatus`)
- 재고 수량 변경은 `InventoryTransaction` 이력 저장과 같은 `@Transactional` 안에서
- 계산 정책: 실제 필요량 = 재료량 × 실제 인분 / 기준 인분 · kg↔g, L↔ml 자동 환산 · 개/팩/마리는 서로 합산 금지 · 부족분 = 필요량 + 최소 유지량 − 현재고

### 프론트엔드
- **JavaScript만 사용** (TypeScript 문법 금지). 화면(JSX가 있는 파일)은 `.jsx`, 그 외는 `.js`
- API 호출은 `src/api/client.js`의 `api` 인스턴스만 사용한다. 토큰 첨부와 401 시 자동 재발급이 여기에 들어 있다. Access JWT는 메모리에만 두고 localStorage에 저장하지 않는다
- 로그인 세션은 `src/stores/authStore.js`(Zustand)에서만 다룬다. 화면에서 토큰을 직접 읽거나 저장하지 않는다
- 계층 나누기: 서버 요청 함수는 `src/api/{domain}.js`, `useQuery`/`useMutation` 훅은 `src/hooks/use{Domain}.js`, 화면에서 쓰는 계산·검증은 `src/models/`, 화면은 `pages/`·`components/`
- `src/models/`는 Node 테스트가 직접 불러오므로 `@/` 대신 상대 경로(`../lib/enums.js`)로 import한다
- 쿼리 키는 `src/api/queryKeys.js`에 모으고, 변경 후 관련 키를 `invalidateQueries`
- 에러 메시지는 `getErrorMessage(error)`로 서버 메시지를 그대로 보여준다
- 공통 스타일 클래스: `input`, `label`, `btn-primary`, `btn-secondary`, `card` (`src/index.css`)
- 백엔드 enum 값은 문자열을 직접 쓰지 말고 `src/lib/enums.js` 상수 사용 (예: `MEAL_PLAN_STATUS.CONFIRMED`), 한글 라벨은 `src/lib/labels.js`
- import 경로는 `@/`(= `src/`)로 시작한다 (예: `import { api } from '@/api/client'`)

### AI 서비스 연동 (Spring ↔ Flask)
- Gemini API 키는 `ai-service/.env`에만 둔다. 브라우저·Spring·저장소에는 노출 금지
- 이름·이메일·토큰·사용자 ID 등 개인정보는 AI 요청에 넣지 않는다 (재고·목표·알레르기·제외 재료만)
- Spring은 `domain/ai/config/AiClientConfig`의 `aiRestClient`로 호출한다. 타임아웃: Spring 연결 3초·읽기 20초, Flask → Gemini 18초(추가 재시도 없음), 프론트 axios 30초
- AI 결과는 항상 초안이다. Spring이 출처·필수 필드·시간·수량·알레르기·제외 재료를 다시 검사한다
- 실패 시 대응: 하루 3끼 추천은 로컬 대체 식단을 쓰고 `RecipeSource.LOCAL_FALLBACK`으로 표기한다. 15분 요리 추천은 가짜 결과를 만들지 않고 오류 코드(`QUICK_AI_001`~`005`)로 안내한다
