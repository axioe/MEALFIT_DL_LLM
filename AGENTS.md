# MealFit AI 작업 가이드라인

이 문서는 팀원 각자가 쓰는 AI(Claude, ChatGPT, Gemini, Copilot, Cursor 등)에게 처음 작업을 맡기기 전에 먼저 읽히는 규칙이다.

사용법: 새 대화를 시작할 때 이 파일을 첨부(또는 내용을 붙여 넣기)하고 "이 가이드라인을 지켜서 작업해줘"라고 요청한다. 저장소 루트의 AGENTS.md에도 같은 내용이 있어, 그 파일을 자동으로 읽는 도구(Claude Code, Codex, Cursor 등)는 따로 첨부하지 않아도 된다.

사람용 설명은 저장소의 README.md에 있다. 이 문서와 README가 다르면 이 문서를 따르고, 차이를 사용자에게 알린다.

| 항목 | 내용 |
|---|---|
| 저장소 | axioe/MEALFIT_DL_LLM |
| 작성 | PL 김영현 |
| 기준일 | 2026-11-24 (운영 배포 재개, 중간발표 일정 반영) |

## 0. 가장 먼저 지킬 것 (요약)

- main과 develop에는 절대 직접 push하지 않는다. 항상 develop에서 작업 브랜치를 만들고 develop으로 PR을 올린다. (저장소 규칙으로도 막혀 있다)
- 비밀값을 다루지 않는다. .env, API 키, JWT 비밀키, DB 비밀번호, .pem 파일을 읽어서 출력하거나, 커밋하거나, 채팅·로그·AI 요청에 넣지 않는다.
- 배포하지 않는다. 운영 서버(EC2)는 가동 중이고 main 머지가 곧 운영 배포다. AI는 서버 접속, 배포 스크립트 실행, DEPLOY_ENABLED 변수 변경, main 머지를 하지 않는다. 예외: PL이 그 대화에서 직접 요청한 작업(읽기 전용 점검, main 머지 등)은 요청받은 범위만 하고, 비밀값은 출력하지 않는다.
- 구조(MVC)를 지킨다. 새 코드는 아래 3장에 정해진 폴더에만 넣는다. 애매하면 만들기 전에 사용자에게 묻는다.
- 다 했다고 말하기 전에 검증한다. 6장의 명령을 실행하고, 실패하면 숨기지 말고 그대로 보고한다.
- 요청받은 범위만 바꾼다. 다른 팀원 담당 영역, 이미 머지된 마이그레이션, 관련 없는 파일은 고치지 않는다. 고치고 싶으면 먼저 묻는다.
- 12/4(금) 중간발표까지 개발을 완료한다. 기능 개발·화면 연결·단위/통합 테스트가 그 전에 끝나야 한다. 세부 마감은 1장 작업 일정을 따르고, 늦어질 것 같으면 바로 알린다.

## 1. 프로젝트 개요

- MealFit(밀핏): 냉장고 재고를 기반으로 AI가 식단을 추천하고, 장보기 → 조리 → 섭취 기록까지 이어 주는 식단 관리 웹 서비스.
- 현재 단계 (2026-11~): 1차 프로젝트(발표 2026-10-23)를 마치고, 이 저장소(axioe/MEALFIT_DL_LLM)에서 DL(딥러닝)·LLM 심화 작업을 한다. 1차 저장소 axioe/MealFit은 건드리지 않는다.
- 배포: 운영 중 (2026-11-20 재개). main push 시 backend·frontend·ai-service·integration 검사가 통과하면 deploy (EC2)가 실행된다(저장소 변수 DEPLOY_ENABLED=true). 작업 브랜치와 develop에서는 deploy가 "건너뜀"인 것이 정상이다. 배포가 실패해도 이전 버전으로 자동 복구되지 않는다.

| 영역 | 기술 |
|---|---|
| backend | Spring Boot 3.5 · Java 21 · JPA · Flyway · PostgreSQL 16 + pgvector (테스트는 H2 PostgreSQL 모드, CI는 실제 PostgreSQL, 운영은 Amazon RDS for PostgreSQL·TLS 인증서 검증) · JWT |
| frontend | React + JavaScript(TypeScript 금지) · Vite · TanStack Query · Zustand · Tailwind |
| ai-service | Python 3.12 · Flask · 현재 Gemini (google-genai), 자체 모델로 전환 예정 |
| CI | GitHub Actions (.github/workflows/ci.yml) |

작업 일정 (중간발표 12/4 기준)

| 기한 (2026년) | 완료해야 하는 것 |
|---|---|
| 11/27(금) | 핵심 기능 구현 |
| 12/2(수) | 화면·API·AI 연결과 기능 통합 |
| 12/3(목) | 단위·통합 테스트와 오류 수정, 12:00까지 중간보고서 초안 제출 |
| 12/4(금) | 중간발표(중간보고). 이 날까지 개발 완료 |
| 12/7(월)~12/10(목) | 성능·장애 검증, 검수·결함 보완, 승인 후 최종 배포 |
| 12/11(금) | 완료보고·최종 시연 |

- 개발 완료의 기준: develop에 머지됨 + 6장 검사 통과 + 화면과 API가 실제 데이터로 연결됨. 코드만 작성한 상태는 완료가 아니다.
- 일정 확인: 작업을 시작할 때 이 일정과 WBS의 담당 작업 마감일을 확인하고, 12/4 전에 끝낼 수 있는 크기로 나눈다. 세부 담당과 마감은 WBS를 따른다.
- 늦어질 것 같으면: 임의로 범위를 줄이거나 검사를 생략하지 말고, 남은 일과 예상 완료일을 사용자에게 바로 알린다. 범위·일정 변경은 사용자와 PL이 정한다.

## 2. 브랜치 · PR · 커밋

```
feature/* ──PR──▶ develop(벽) ──PR──▶ main
```

- 작업 시작: git fetch origin && git checkout develop && git pull 후 git checkout -b feature/{영역}-{내용}
- 접두어: feature/(기능), fix/(버그), refactor/(구조), docs/(문서), chore/(설정·CI), ml/(모델 학습·실험)
- 예) feature/ai-meal-coaching, ml/food-image-classifier, fix/auth-refresh
- PR 대상은 항상 develop. main으로 가는 PR은 develop(또는 급한 수정 hotfix/*)에서만 올릴 수 있다. CI의 source branch 검사가 막는다.
- PR 올리기 전에 develop을 작업 브랜치에 합쳐서(merge 또는 pull) 충돌을 먼저 푼다.
- 커밋 메시지: type: 한국어 요약 한 줄 + 필요하면 본문.
- type: feat fix refactor docs test chore ci ml
- 예) feat: 식단 코칭 LLM 엔드포인트 추가, ml: 음식 이미지 분류 베이스라인 학습 스크립트
- AI는 사용자가 요청할 때만 커밋·push·PR 생성을 한다. 머지는 사용자가 명시적으로 시킬 때만 한다.
- 금지: git push --force, git reset --hard로 남의 커밋 지우기, 다른 사람 브랜치에 push, --no-verify.
- 작업이 끝나면 사용자에게 브랜치 이름과 한 줄 커밋 메시지를 알려 준다.

CI 검사 (PR이 머지되려면 통과해야 함)

| 단계 | 필수 검사 |
|---|---|
| 작업 브랜치 → develop | backend (test) · frontend (lint, build)(단위 테스트 포함) · ai-service (test) |
| develop → main | 위 3개 + source branch (develop → main) + integration (docker compose) |

## 3. 폴더 구조와 MVC 규칙

세 서비스 모두 Controller(요청 처리) → Model(로직·데이터) → View(응답·화면) 로 나눈다. 새 파일은 아래 표에서 역할이 맞는 곳에만 만든다.

backend (backend/src/main/java/com/mealfit/)

| 위치 | 넣는 것 |
|---|---|
| domain/{도메인}/controller/ | REST 컨트롤러. 요청 받고 서비스 호출만. 로직 금지 |
| domain/{도메인}/service/ | 비즈니스 로직·검증·트랜잭션 |
| domain/{도메인}/repository/ | Spring Data JPA |
| domain/{도메인}/entity/ | JPA 엔티티, 상태 enum |
| domain/{도메인}/model/ | DB에 저장하지 않는 값 객체 |
| domain/{도메인}/dto/ | 요청·응답 형태 |
| domain/{도메인}/client/ config/ exception/ | 외부 호출·설정·도메인 예외 (필요할 때만) |
| global/ | security(JWT), exception, config, common, web — 여러 도메인 공용 |

- 도메인: auth, user, inventory, mealplan, recipe, shopping, cooking, intake, workout, ai. 클래스를 도메인 폴더 바로 아래에 두지 않는다.
- 현재 사용자는 컨트롤러 파라미터 @CurrentUserId Long userId로만 받는다. 요청 본문·헤더의 userId는 믿지 않는다.
- 조회는 findByIdAndUserId(id, userId)처럼 항상 본인 데이터만 가져온다.
- 오류는 throw new BusinessException(ErrorCode.XXX). 새 코드는 ErrorCode에 도메인 접두어로 추가(INVENTORY_001).
- 상태 변경은 엔티티 메서드에서 status.validateTransition(next)로.
- 재고 수량 변경은 InventoryTransaction 이력 저장과 같은 @Transactional 안에서.

frontend (frontend/src/)

| 위치 | MVC | 넣는 것 |
|---|---|---|
| api/ | Model(데이터) | 서버 요청 함수만. api/client.js의 api 인스턴스 사용. 쿼리 키는 api/queryKeys.js |
| models/ | Model(규칙) | 계산·검증 순수 함수. React·API import 금지. @/ 대신 상대 경로 import (Node 테스트가 직접 불러옴) |
| stores/ | Model(상태) | Zustand. 로그인 세션은 authStore.js에서만. Access JWT는 메모리에만 두고(localStorage 금지), Refresh는 HttpOnly 쿠키, /refresh·/logout은 CSRF 헤더(X-Requested-With)가 필요하다 |
| hooks/ | Controller | useQuery/useMutation, 화면 상태 흐름 |
| pages/, components/ | View | JSX만. 계산·검증·API 호출을 직접 하지 않고 hooks·models를 쓴다 |
| lib/ | 공용 | enums.js(백엔드 enum 상수), labels.js(한글 라벨), 날짜·숫자 형식 |

- JavaScript만. JSX가 있으면 .jsx, 아니면 .js.
- 백엔드 enum 문자열을 직접 쓰지 말고 lib/enums.js 상수를 쓴다.
- 날짜는 toISOString()(UTC) 대신 lib/date.js의 toLocalDateString()·today()를 쓴다. (한국 시간 오전 9시 전 날짜가 하루 밀리는 버그가 있었다)
- 서버 오류 메시지는 getErrorMessage(error)로 표시한다.
- components/prototype/은 연결 안 된 시안이다. 여기서 import하지 않는다.

ai-service (ai-service/)

| 위치 | MVC | 넣는 것 |
|---|---|---|
| app.py | — | 실행 진입점만 |
| mealfit_ai/__init__.py | — | create_app: 설정·Blueprint·오류 처리 등록 |
| mealfit_ai/controllers/ | Controller | Flask Blueprint 라우트, 오류 응답 |
| mealfit_ai/services/ | Model | 프롬프트 구성, 응답 검증, 추론 로직 |
| mealfit_ai/schemas/ | — | 요청 본문 검증 |
| mealfit_ai/clients/ | — | 외부 모델·API 호출 (Gemini 등) |
| tests/ | — | unittest. 외부 API는 반드시 mock |

DL·LLM 심화 작업용 위치 (새 규칙)

| 위치 | 넣는 것 |
|---|---|
| ai-service/mealfit_ai/services/ | 서비스에서 쓰는 추론·LLM 로직 (학습된 모델을 불러와 예측하는 코드 포함) |
| ai-service/mealfit_ai/clients/ | LLM·외부 모델 API 호출 래퍼 (Gemini, 그 외 LLM) |
| ai-service/ml/ | 학습·실험 코드 (데이터 전처리, 학습 스크립트, 평가). 서비스 코드가 ml/을 import하지 않는다 |
| ai-service/ml/notebooks/ | 실험용 노트북 (출력 셀은 비우고 커밋) |
| docs/ | 모델 카드, 데이터 설명, 실험 결과 요약 |

- 위 표에 없는 최상위 폴더(새 서비스, 새 언어 등)를 만들어야 하면 먼저 사용자(PL)에게 확인한다.
- 새 Python 패키지는 requirements.txt에 버전을 고정해서 추가한다(torch==x.y.z). 학습 전용 패키지는 ai-service/ml/requirements.txt에 따로 둔다.

## 4. DL · LLM 작업 규칙

- 외부 AI API 호출을 새로 추가하지 않는다. 목표는 자체 서빙 모델(LLM vLLM, 임베딩 bge-m3, OCR PaddleOCR)이고, 현재 코드는 아직 Gemini를 쓴다. 기존 Gemini 클라이언트는 전환 전까지만 유지한다.
- 데이터·모델 파일은 git에 올리지 않는다. 데이터셋, 체크포인트(*.pt, *.pth, *.ckpt, *.h5, *.onnx, *.safetensors), 실험 로그(wandb/, mlruns/, runs/)는 .gitignore에 들어 있다. 공유가 필요하면 저장 위치(드라이브 링크 등)를 docs/에 적는다.
- 재현 가능하게. 시드 고정, 하이퍼파라미터는 코드나 설정 파일에 남기고, 결과(지표·데이터 버전)를 docs/에 기록한다.
- LLM 출력은 항상 "초안"이다. Spring이 출처·필수 필드·수량·알레르기·제외 재료를 다시 검증하는 기존 흐름을 유지한다. LLM 결과를 검증 없이 DB에 저장하거나 사용자에게 바로 보여 주지 않는다.
- 실패해도 서비스가 멈추지 않게. AI가 실패하면 하루 식단은 로컬 대체 식단(RecipeSource.LOCAL_FALLBACK), 15분 요리는 오류 코드(QUICK_AI_001~005)로 안내하는 기존 방식을 따른다. 가짜 결과를 만들지 않는다.
- 개인정보를 모델에 보내지 않는다. 이름·이메일·토큰·사용자 ID 금지. 재고·목표·알레르기·제외 재료처럼 추천에 필요한 값만 보낸다.
- 테스트에서 실제 API를 부르지 않는다. LLM·외부 모델 호출은 mock한다 (비용·속도·키 노출 방지). CI에는 API 키가 없다.
- 프롬프트는 services/에 코드로 둔다. 프롬프트를 바꾸면 응답 검증 테스트도 같이 고친다.
- 타임아웃을 지킨다. 현재: Spring → Flask 연결 3초·읽기 20초, Flask → 모델 호출(현재 Gemini) 18초, 프론트 30초. 무거운 모델을 넣어 이 시간을 넘길 것 같으면 먼저 상의한다.
- 모델·API 비용이 드는 대량 호출(배치 생성, 평가 수백 건 이상)은 실행 전에 사용자에게 확인한다.

## 5. DB 스키마 (Flyway)

- 스키마는 backend/src/main/resources/db/migration/postgresql/의 SQL로만 바꾼다 (ddl-auto: validate). db/migration/ 바로 아래 V1–V7은 MariaDB 시절 이력이라 실행하지 않고 수정하지도 않는다.
- pgvector처럼 H2가 모르는 타입을 쓰는 마이그레이션은 db/vendor/postgresql/에 둔다. 번호는 두 폴더를 합쳐 이어서 매긴다 (2026-11-24 develop 기준 마지막: V11 운동 루틴. 새로 만들 때는 최신 develop에서 다시 확인한다).
- recipe_embeddings(V8)는 레시피 검색 전용이다: bge-m3, vector(1024), HNSW 코사인. CREATE EXTENSION vector는 RDS 관리 계정으로만 실행한다. 벡터 테스트는 H2가 아닌 PostgreSQL(pgvector/pgvector:pg16)에서 하고, 임베딩 모델을 바꾸면 model_version 기준으로 전체를 다시 임베딩한다.
- 이미 머지된 V*.sql은 절대 수정하지 않는다. 변경은 다음 번호의 새 파일 (V12__설명.sql …).
- main에 머지되면 새 마이그레이션이 운영 RDS에 바로 적용된다. 로컬·CI에서 먼저 확인한다.
- 번호가 겹치지 않게, 새 마이그레이션을 만들기 전에 사용자에게 번호를 확인받는다.
- 수량은 NUMERIC(12,3) + BigDecimal, 시각은 TIMESTAMP(6) + LocalDateTime, enum은 VARCHAR(20) + @Enumerated(EnumType.STRING). 시간대는 Asia/Seoul로 고정돼 있으므로 TIMESTAMPTZ로 바꾸려면 먼저 PL과 상의한다.
- PostgreSQL IDENTITY는 ID를 직접 넣어도 다음 값이 오르지 않는다. 테스트나 이관에서 ID를 직접 넣으면 시퀀스를 따로 맞춘다. 실제 PostgreSQL이 필요한 테스트는 PG_TEST_URL이 있을 때만 돌게 하고(CI가 넣어 준다), 로컬 확인은 docker compose up -d(pgvector/pgvector:pg16)로 한다.

## 6. 검증 (PR 전에 반드시)

바꾼 영역의 검사를 실행하고 결과를 보고한다. CI와 같은 명령이다.

```
# backend
cd backend && ./gradlew test            # Windows: gradlew.bat test

# frontend
cd frontend && npm ci && npm run lint && npm test && npm run build

# ai-service
cd ai-service && python -m pip install -r requirements-test.txt && python -m unittest -v
```

- 프론트 로직(models/)을 바꾸면 frontend/tests/*.test.mjs에 테스트를 추가한다.
- ai-service 로직을 바꾸면 ai-service/tests/에 테스트를 추가한다.
- 백엔드 서비스 로직을 바꾸면 backend/src/test/에 테스트를 추가한다.
- 실패한 검사를 끄거나(@Disabled, skip), 검사 기준을 낮춰서 통과시키지 않는다.

로컬 실행 방법(DB, .env, 포트)은 README의 "로컬 실행"을 따른다.

## 7. 보안 · 금지 사항

- .env, .env.*(예시 파일 제외), *.pem, 키·토큰이 든 파일을 열어서 내용을 출력하거나 커밋하지 않는다. 값이 필요하면 사용자에게 직접 넣어 달라고 한다.
- 비밀값을 코드에 하드코딩하지 않는다. 환경 변수로 받는다.
- 운영 서버(EC2)와 운영 DB(RDS)에 접속하거나 명령을 실행하지 않는다 (SSH 터널 포함). PL이 직접 요청한 읽기 전용 점검만 예외다.
- 로컬 백엔드를 운영 DB에 연결하지 않는다. 실행만 해도 작업 중인 Flyway 마이그레이션이 운영 DB에 적용될 수 있다.
- DB_URL·DB 비밀번호·JWT_SECRET·MAIL_PASSWORD·SSH 키 값은 출력·커밋하지 않고 AI 요청에도 넣지 않는다. 주석 처리된 줄에도 실제 값이 있을 수 있다. 예시 파일(.env.example, .env.prod.example)에는 자리 표시만 둔다.
- 저장소 설정(보호 규칙, Secrets, Variables, 기본 브랜치)을 바꾸지 않는다. 필요하면 PL에게 요청한다.
- 출처가 불분명한 파일·패키지를 내려받아 실행하지 않는다. 새 의존성은 이름과 이유를 사용자에게 알린다.
- 외부 데이터셋·모델을 쓸 때는 라이선스를 확인하고 docs/에 출처를 적는다.

## 8. 작업 방식

- 먼저 읽는다. 이 파일 → README → 바꿀 영역의 기존 코드. 비슷한 기존 구현이 있으면 그 패턴을 따른다.
- 계획을 짧게 말하고 시작한다. 여러 영역(backend·frontend·ai-service)에 걸치거나 DB 스키마를 바꾸면 계획을 먼저 보여 주고 확인받는다.
- 작게 나눈다. 한 PR에는 한 가지 목적. 구조 정리와 기능 추가를 섞지 않는다.
- 모르면 묻는다. 요구사항이 애매하거나, 다른 팀원 영역을 건드려야 하거나, 이 문서에 없는 결정이 필요하면 추측하지 말고 묻는다.
- 사실대로 보고한다. 끝나면 아래 형식으로 알린다.

```
변경 요약: (무엇을, 왜)
바꾼 파일: (주요 파일)
검증 결과: (실행한 명령과 통과/실패 수)
남은 일·주의점: (있으면)
브랜치: feature/...
커밋 메시지: type: 한 줄 요약
```
