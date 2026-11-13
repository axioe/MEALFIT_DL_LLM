# MealFit AI 작업 가이드라인 (AGENTS.md)

> 이 파일은 팀원 각자가 쓰는 AI 코딩 도구(Claude Code, Codex, Cursor, Copilot, Gemini 등)가 **작업을 시작하기 전에 반드시 읽는 규칙**이다.
> 사람이 읽어도 되지만, 주 독자는 AI다. 사람용 설명은 [README.md](README.md)에 있다.
> 이 문서와 README가 다르면 이 문서를 따르고, 차이를 사용자에게 알린다.

---

## 0. 가장 먼저 지킬 것 (요약)

1. **`main`과 `develop`에는 절대 직접 push하지 않는다.** 항상 `develop`에서 작업 브랜치를 만들고 `develop`으로 PR을 올린다. (저장소 규칙으로도 막혀 있다)
2. **비밀값을 다루지 않는다.** `.env`, API 키, JWT 비밀키, DB 비밀번호, `.pem` 파일을 읽어서 출력하거나, 커밋하거나, 채팅·로그·AI 요청에 넣지 않는다.
3. **배포하지 않는다.** 운영 서버는 꺼져 있다. 서버 접속, 배포 스크립트 실행, `DEPLOY_ENABLED` 변수 변경을 하지 않는다.
4. **구조(MVC)를 지킨다.** 새 코드는 아래 3장에 정해진 폴더에만 넣는다. 애매하면 만들기 전에 사용자에게 묻는다.
5. **다 했다고 말하기 전에 검증한다.** 6장의 명령을 실행하고, 실패하면 숨기지 말고 그대로 보고한다.
6. **요청받은 범위만 바꾼다.** 다른 팀원 담당 영역, 이미 머지된 마이그레이션, 관련 없는 파일은 고치지 않는다. 고치고 싶으면 먼저 묻는다.

---

## 1. 프로젝트 개요

- **MealFit(밀핏):** 냉장고 재고를 기반으로 AI가 식단을 추천하고, 장보기 → 조리 → 섭취 기록까지 이어 주는 식단 관리 웹 서비스.
- **현재 단계 (2026-11~):** 1차 프로젝트(발표 2026-10-23)를 마치고, 이 저장소(`axioe/MEALFIT_DL_LLM`)에서 **DL(딥러닝)·LLM 심화 작업**을 한다. 1차 저장소 `axioe/MealFit`은 건드리지 않는다.
- **배포:** 중단 상태. CI의 `deploy (EC2)` job은 항상 "건너뜀"으로 표시되는 것이 정상이다.

| 영역 | 기술 |
|---|---|
| backend | Spring Boot 3.5 · Java 21 · JPA · Flyway · MariaDB 11.4 (테스트는 H2) · JWT |
| frontend | React + **JavaScript**(TypeScript 금지) · Vite · TanStack Query · Zustand · Tailwind |
| ai-service | Python 3.12 · Flask · Gemini (`google-genai`) |
| CI | GitHub Actions (`.github/workflows/ci.yml`) |

---

## 2. 브랜치 · PR · 커밋

```
feature/* ──PR──▶ develop(벽) ──PR──▶ main
```

- 작업 시작: `git fetch origin && git checkout develop && git pull` 후 `git checkout -b feature/{영역}-{내용}`
  - 접두어: `feature/`(기능), `fix/`(버그), `refactor/`(구조), `docs/`(문서), `chore/`(설정·CI), `ml/`(모델 학습·실험)
  - 예) `feature/ai-meal-coaching`, `ml/food-image-classifier`, `fix/auth-refresh`
- PR 대상은 **항상 `develop`**. `main`으로 가는 PR은 `develop`(또는 급한 수정 `hotfix/*`)에서만 올릴 수 있다. CI의 `source branch` 검사가 막는다.
- PR 올리기 전에 `develop`을 작업 브랜치에 합쳐서(merge 또는 pull) 충돌을 먼저 푼다.
- 커밋 메시지: `type: 한국어 요약` 한 줄 + 필요하면 본문.
  - type: `feat` `fix` `refactor` `docs` `test` `chore` `ci` `ml`
  - 예) `feat: 식단 코칭 LLM 엔드포인트 추가`, `ml: 음식 이미지 분류 베이스라인 학습 스크립트`
- **AI는 사용자가 요청할 때만** 커밋·push·PR 생성을 한다. 머지는 사용자가 명시적으로 시킬 때만 한다.
- 금지: `git push --force`, `git reset --hard`로 남의 커밋 지우기, 다른 사람 브랜치에 push, `--no-verify`.
- 작업이 끝나면 사용자에게 **브랜치 이름**과 **한 줄 커밋 메시지**를 알려 준다.

### CI 검사 (PR이 머지되려면 통과해야 함)

| 단계 | 필수 검사 |
|---|---|
| 작업 브랜치 → `develop` | `backend (test)` · `frontend (lint, build)`(단위 테스트 포함) · `ai-service (test)` |
| `develop` → `main` | 위 3개 + `source branch (develop → main)` + `integration (docker compose)` |

---

## 3. 폴더 구조와 MVC 규칙

세 서비스 모두 **Controller(요청 처리) → Model(로직·데이터) → View(응답·화면)** 로 나눈다. 새 파일은 아래 표에서 역할이 맞는 곳에만 만든다.

### backend (`backend/src/main/java/com/mealfit/`)

| 위치 | 넣는 것 |
|---|---|
| `domain/{도메인}/controller/` | REST 컨트롤러. 요청 받고 서비스 호출만. 로직 금지 |
| `domain/{도메인}/service/` | 비즈니스 로직·검증·트랜잭션 |
| `domain/{도메인}/repository/` | Spring Data JPA |
| `domain/{도메인}/entity/` | JPA 엔티티, 상태 enum |
| `domain/{도메인}/model/` | DB에 저장하지 않는 값 객체 |
| `domain/{도메인}/dto/` | 요청·응답 형태 |
| `domain/{도메인}/client/ config/ exception/` | 외부 호출·설정·도메인 예외 (필요할 때만) |
| `global/` | security(JWT), exception, config, common, web — 여러 도메인 공용 |

- 도메인: `auth, user, inventory, mealplan, recipe, shopping, cooking, intake, ai`. 클래스를 도메인 폴더 바로 아래에 두지 않는다.
- 현재 사용자는 컨트롤러 파라미터 `@CurrentUserId Long userId`로만 받는다. 요청 본문·헤더의 userId는 믿지 않는다.
- 조회는 `findByIdAndUserId(id, userId)`처럼 **항상 본인 데이터만** 가져온다.
- 오류는 `throw new BusinessException(ErrorCode.XXX)`. 새 코드는 `ErrorCode`에 도메인 접두어로 추가(`INVENTORY_001`).
- 상태 변경은 엔티티 메서드에서 `status.validateTransition(next)`로.
- 재고 수량 변경은 `InventoryTransaction` 이력 저장과 같은 `@Transactional` 안에서.

### frontend (`frontend/src/`)

| 위치 | MVC | 넣는 것 |
|---|---|---|
| `api/` | Model(데이터) | 서버 요청 함수만. `api/client.js`의 `api` 인스턴스 사용. 쿼리 키는 `api/queryKeys.js` |
| `models/` | Model(규칙) | 계산·검증 **순수 함수**. React·API import 금지. `@/` 대신 **상대 경로** import (Node 테스트가 직접 불러옴) |
| `stores/` | Model(상태) | Zustand. 로그인 세션은 `authStore.js`에서만 |
| `hooks/` | Controller | `useQuery`/`useMutation`, 화면 상태 흐름 |
| `pages/`, `components/` | View | JSX만. 계산·검증·API 호출을 직접 하지 않고 hooks·models를 쓴다 |
| `lib/` | 공용 | `enums.js`(백엔드 enum 상수), `labels.js`(한글 라벨), 날짜·숫자 형식 |

- **JavaScript만.** JSX가 있으면 `.jsx`, 아니면 `.js`.
- 백엔드 enum 문자열을 직접 쓰지 말고 `lib/enums.js` 상수를 쓴다.
- 날짜는 `toISOString()`(UTC) 대신 `lib/date.js`의 `toLocalDateString()`·`today()`를 쓴다. (한국 시간 오전 9시 전 날짜가 하루 밀리는 버그가 있었다)
- 서버 오류 메시지는 `getErrorMessage(error)`로 표시한다.
- `components/prototype/`은 연결 안 된 시안이다. 여기서 import하지 않는다.

### ai-service (`ai-service/`)

| 위치 | MVC | 넣는 것 |
|---|---|---|
| `app.py` | — | 실행 진입점만 |
| `mealfit_ai/__init__.py` | — | `create_app`: 설정·Blueprint·오류 처리 등록 |
| `mealfit_ai/controllers/` | Controller | Flask Blueprint 라우트, 오류 응답 |
| `mealfit_ai/services/` | Model | 프롬프트 구성, 응답 검증, 추론 로직 |
| `mealfit_ai/schemas/` | — | 요청 본문 검증 |
| `mealfit_ai/clients/` | — | 외부 모델·API 호출 (Gemini 등) |
| `tests/` | — | `unittest`. 외부 API는 반드시 mock |

### DL·LLM 심화 작업용 위치 (새 규칙)

| 위치 | 넣는 것 |
|---|---|
| `ai-service/mealfit_ai/services/` | 서비스에서 쓰는 추론·LLM 로직 (학습된 모델을 불러와 예측하는 코드 포함) |
| `ai-service/mealfit_ai/clients/` | LLM·외부 모델 API 호출 래퍼 (Gemini, 그 외 LLM) |
| `ai-service/ml/` | **학습·실험 코드** (데이터 전처리, 학습 스크립트, 평가). 서비스 코드가 `ml/`을 import하지 않는다 |
| `ai-service/ml/notebooks/` | 실험용 노트북 (출력 셀은 비우고 커밋) |
| `docs/` | 모델 카드, 데이터 설명, 실험 결과 요약 |

- 위 표에 없는 최상위 폴더(새 서비스, 새 언어 등)를 만들어야 하면 **먼저 사용자(PL)에게 확인**한다.
- 새 Python 패키지는 `requirements.txt`에 **버전을 고정**해서 추가한다(`torch==x.y.z`). 학습 전용 패키지는 `ai-service/ml/requirements.txt`에 따로 둔다.

---

## 4. DL · LLM 작업 규칙

1. **데이터·모델 파일은 git에 올리지 않는다.** 데이터셋, 체크포인트(`*.pt`, `*.pth`, `*.ckpt`, `*.h5`, `*.onnx`, `*.safetensors`), 실험 로그(`wandb/`, `mlruns/`, `runs/`)는 `.gitignore`에 들어 있다. 공유가 필요하면 저장 위치(드라이브 링크 등)를 `docs/`에 적는다.
2. **재현 가능하게.** 시드 고정, 하이퍼파라미터는 코드나 설정 파일에 남기고, 결과(지표·데이터 버전)를 `docs/`에 기록한다.
3. **LLM 출력은 항상 "초안"이다.** Spring이 출처·필수 필드·수량·알레르기·제외 재료를 다시 검증하는 기존 흐름을 유지한다. LLM 결과를 검증 없이 DB에 저장하거나 사용자에게 바로 보여 주지 않는다.
4. **실패해도 서비스가 멈추지 않게.** AI가 실패하면 하루 식단은 로컬 대체 식단(`RecipeSource.LOCAL_FALLBACK`), 15분 요리는 오류 코드(`QUICK_AI_001~005`)로 안내하는 기존 방식을 따른다. 가짜 결과를 만들지 않는다.
5. **개인정보를 모델에 보내지 않는다.** 이름·이메일·토큰·사용자 ID 금지. 재고·목표·알레르기·제외 재료처럼 추천에 필요한 값만 보낸다.
6. **테스트에서 실제 API를 부르지 않는다.** LLM·외부 모델 호출은 mock한다 (비용·속도·키 노출 방지). CI에는 API 키가 없다.
7. **프롬프트는 `services/`에 코드로** 둔다. 프롬프트를 바꾸면 응답 검증 테스트도 같이 고친다.
8. **타임아웃을 지킨다.** 현재: Spring → Flask 연결 3초·읽기 20초, Flask → Gemini 18초, 프론트 30초. 무거운 모델을 넣어 이 시간을 넘길 것 같으면 먼저 상의한다.
9. 모델·API 비용이 드는 대량 호출(배치 생성, 평가 수백 건 이상)은 실행 전에 사용자에게 확인한다.

---

## 5. DB 스키마 (Flyway)

- 스키마는 `backend/src/main/resources/db/migration/`의 SQL로만 바꾼다 (`ddl-auto: validate`).
- **이미 머지된 `V*.sql`은 절대 수정하지 않는다.** 변경은 다음 번호의 새 파일 (`V8__설명.sql` …).
- 번호가 겹치지 않게, 새 마이그레이션을 만들기 전에 사용자에게 번호를 확인받는다.
- 수량은 `DECIMAL(12,3)` + `BigDecimal`, enum은 `VARCHAR(20)` + `@Enumerated(EnumType.STRING)`.

---

## 6. 검증 (PR 전에 반드시)

바꾼 영역의 검사를 실행하고 결과를 보고한다. CI와 같은 명령이다.

```bash
# backend
cd backend && ./gradlew test            # Windows: gradlew.bat test

# frontend
cd frontend && npm ci && npm run lint && npm test && npm run build

# ai-service
cd ai-service && python -m unittest -v
```

- 프론트 로직(`models/`)을 바꾸면 `frontend/tests/*.test.mjs`에 테스트를 추가한다.
- ai-service 로직을 바꾸면 `ai-service/tests/`에 테스트를 추가한다.
- 백엔드 서비스 로직을 바꾸면 `backend/src/test/`에 테스트를 추가한다.
- 실패한 검사를 끄거나(`@Disabled`, `skip`), 검사 기준을 낮춰서 통과시키지 않는다.

로컬 실행 방법(DB, `.env`, 포트)은 README의 "로컬 실행"을 따른다.

---

## 7. 보안 · 금지 사항

- `.env`, `.env.*`(예시 파일 제외), `*.pem`, 키·토큰이 든 파일을 **열어서 내용을 출력하거나 커밋하지 않는다.** 값이 필요하면 사용자에게 직접 넣어 달라고 한다.
- 비밀값을 코드에 하드코딩하지 않는다. 환경 변수로 받는다.
- 운영 서버(EC2), 운영 DB에 접속하거나 명령을 실행하지 않는다.
- 저장소 설정(보호 규칙, Secrets, Variables, 기본 브랜치)을 바꾸지 않는다. 필요하면 PL에게 요청한다.
- 출처가 불분명한 파일·패키지를 내려받아 실행하지 않는다. 새 의존성은 이름과 이유를 사용자에게 알린다.
- 외부 데이터셋·모델을 쓸 때는 라이선스를 확인하고 `docs/`에 출처를 적는다.

---

## 8. 작업 방식

1. **먼저 읽는다.** 이 파일 → README → 바꿀 영역의 기존 코드. 비슷한 기존 구현이 있으면 그 패턴을 따른다.
2. **계획을 짧게 말하고 시작한다.** 여러 영역(backend·frontend·ai-service)에 걸치거나 DB 스키마를 바꾸면 계획을 먼저 보여 주고 확인받는다.
3. **작게 나눈다.** 한 PR에는 한 가지 목적. 구조 정리와 기능 추가를 섞지 않는다.
4. **모르면 묻는다.** 요구사항이 애매하거나, 다른 팀원 영역을 건드려야 하거나, 이 문서에 없는 결정이 필요하면 추측하지 말고 묻는다.
5. **사실대로 보고한다.** 끝나면 아래 형식으로 알린다.

```
변경 요약: (무엇을, 왜)
바꾼 파일: (주요 파일)
검증 결과: (실행한 명령과 통과/실패 수)
남은 일·주의점: (있으면)
브랜치: feature/...
커밋 메시지: type: 한 줄 요약
```
