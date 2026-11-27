# MealFit 트러블슈팅 기록

개발 중 만난 문제와 해결 과정을 바로 적는 문서입니다. 같은 문제를 다시 만났을 때 찾아보고, 발표 자료에도 씁니다.

## 작성 방법

- 번호는 TS-날짜-순번으로 쓴다. 예) TS-20261124-01. 같은 날 번호가 있으면 다음 순번을 쓴다.
- 문제를 만난 즉시 "증상"부터 적는다. 원인과 해결은 나중에 채워도 된다.
- 확인한 사실만 적는다. 추정이면 앞에 "추정:"을 붙인다.
- 비밀번호·키·토큰·.env 내용·개인정보와 그 화면 캡처는 넣지 않는다. 오류 로그는 값을 ***로 가린다.
- 특정 사람을 탓하지 않고 현상과 원인을 적는다.

| 적는 곳 | 적는 내용 |
|---|---|
| Drive 워드 | 모든 트러블슈팅. 팀원이 바로 열어 적는다 |
| docs/troubleshooting.md | 코드·설정 수정으로 해결한 것. 해결 PR에 같은 번호로 함께 올린다 |

## 목록

| 번호 | 제목 | 영역 | 상태 |
|---|---|---|---|
| TS-20261124-01 | 로컬 PostgreSQL에서 V8 마이그레이션 실패 | DB | 해결 |
| TS-20261124-02 | 오전 9시 전에 날짜가 하루 밀림 | frontend | 해결 |
| TS-20261124-03 | 세션 처리 작업과 최신 develop의 인증 코드 충돌 | frontend / Git | 해결 |
| TS-20261124-04 | 로그인 후 원래 요청한 화면으로 돌아가지 않음 | frontend | 해결 |
| TS-20261125-01 | 루틴을 다시 받으면 위험 신호 운동 차단이 풀림 | backend | 해결 |
| TS-20261127-01 | 로그인 안내를 닫으면 누른 버튼에서 키보드 포커스가 사라짐 | frontend | 해결 |

## 양식 (복사해서 "기록" 맨 아래에 붙여 넣기)

```
### TS-YYYYMMDD-01 제목

| 항목 | 내용 |
|---|---|
| 작성일 / 작성자 |  |
| 영역 | backend / frontend / ai-service / ml / DB / 배포 / 기타 |
| 상태 | 확인 중 / 해결 / 보류 |
| 증상 | 무엇이 안 되는지, 오류 메시지 핵심 1~3줄 |
| 발생 상황 | 환경(로컬·개발 DB·운영), 브랜치, 다시 나타나게 하는 순서 |
| 원인 | 확인한 원인과 근거 |
| 시도한 방법 | 해 본 것과 결과. 실패한 방법도 적는다 |
| 해결 | 바꾼 내용과 확인 방법(명령·화면) |
| 재발 방지 | 테스트·문서·규칙에 추가한 것 |
| 관련 | PR / Jira / 파일 |
```

## 기록

### TS-20261124-01 로컬 PostgreSQL에서 V8 마이그레이션 실패

| 항목 | 내용 |
|---|---|
| 작성일 / 작성자 | 2026-11-24 / PL (README 내용 정리) |
| 영역 | DB |
| 상태 | 해결 |
| 증상 | Windows에 직접 설치한 PostgreSQL에서 V8(recipe_embeddings)이 실패한다. |
| 발생 상황 | 로컬, Docker 없이 PostgreSQL 16을 설치하고 백엔드를 실행할 때 |
| 원인 | Windows용 PostgreSQL에 pgvector가 없다. |
| 시도한 방법 | 기록 없음. 주의: V8을 건너뛴 DB에서 spring.flyway.locations 줄만 지우면, V9 이후가 이미 적용돼 있어 Flyway 검증 오류로 실행되지 않는다. |
| 해결 | 로컬 .env에 spring.flyway.locations=classpath:db/migration/postgresql 을 넣어 V8을 건너뛴다. 벡터 검색이 필요하면 pgvector/pgvector:pg16으로 DB를 새로 만들어 연결한다. |
| 재발 방지 | README "로컬 실행"에 주의사항을 적음 |
| 관련 | README.md |

### TS-20261124-02 오전 9시 전에 날짜가 하루 밀림

| 항목 | 내용 |
|---|---|
| 작성일 / 작성자 | 2026-11-24 / PL (가이드라인 내용 정리) |
| 영역 | frontend |
| 상태 | 해결 |
| 증상 | 한국 시간 오전 9시 전에는 오늘이 어제 날짜로 나온다. |
| 발생 상황 | 날짜를 toISOString()으로 만들 때 |
| 원인 | toISOString()이 UTC 기준이라 한국 시간보다 9시간 늦다. |
| 시도한 방법 | 기록 없음 |
| 해결 | lib/date.js의 toLocalDateString()·today()를 쓴다. |
| 재발 방지 | 가이드라인 3장에 규칙으로 추가 |
| 관련 | frontend/src/lib/date.js |

### TS-20261124-03 세션 처리 작업과 최신 develop의 인증 코드 충돌

| 항목 | 내용 |
|---|---|
| 작성일 / 작성자 | 2026-11-24 / Codex (MEALFIT-49 작업 보조) |
| 영역 | frontend / Git |
| 상태 | 해결 |
| 증상 | 로컬 세션 처리 변경을 최신 develop에 적용할 때 frontend/src/api/auth.js에서 내용 충돌이 발생했다. useAuth.js는 자동 병합됐지만 소셜 계정 해제 훅이 사용하는 useQueryClient import가 빠져 있었다. |
| 발생 상황 | 로컬 develop에 미커밋 작업 27개가 있고, 원격 develop에 팀원 커밋 14개가 추가된 상태에서 별도 fix 브랜치로 작업을 옮겼다. 기존 상태에는 진행 중인 merge/rebase나 미해결 파일이 없었다. |
| 원인 | 세션 처리 변경과 소셜 로그인 기능이 같은 인증 API 파일의 로그아웃 주변을 수정했다. 자동 병합은 useQueryClient의 새 사용처와 기존 import 제거 사이의 의존성을 반영하지 못했다. |
| 시도한 방법 | 작업 파일 27개를 해시와 함께 별도 백업하고 전용 stash로 보관했다. develop을 fast-forward한 뒤 새 브랜치에서 stash를 적용해 충돌 위치를 확인했다. |
| 해결 | 소셜 계정 조회·연동·해제 API와 훅을 유지하면서 로그인·로그아웃을 세션 처리 함수에 연결했다. useQueryClient import를 복구했다. npm ci, lint(오류 0개·기존 경고 3개), 테스트(222개 통과·실패 0개), build를 통과했다. |
| 재발 방지 | 커밋 전 충돌 표시와 변경 파일 범위를 검사하고, npm ci · npm run lint · npm test · npm run build로 통합 결과를 검증한다. 세션 관련 회귀 테스트는 tests/session*.test.mjs에 유지한다. |
| 관련 | MEALFIT-49 / frontend/src/api/auth.js / frontend/src/hooks/useAuth.js / fix/mealfit-49-session-guard-sync |

### TS-20261124-04 로그인 후 원래 요청한 화면으로 돌아가지 않음

| 항목 | 내용 |
|---|---|
| 작성일 / 작성자 | 2026-11-24 / Codex (MEALFIT-52 작업 보조) |
| 영역 | frontend |
| 상태 | 해결 |
| 증상 | 로그인하지 않은 상태에서 장보기·레시피 상세 주소로 진입해 로그인하면 원래 화면 대신 대시보드로 이동한다. |
| 발생 상황 | 보호 경로에서 /login으로 이동한 뒤 이메일 로그인하거나 소셜 로그인으로 전체 페이지를 왕복할 때 |
| 원인 | RequireAuth는 원래 경로를 state.from에 저장하지만 LoginPage는 항상 /dashboard로 이동했다. 소셜 로그인은 서버도 /dashboard로 돌려보내므로 React Router state만으로 원래 경로를 전달할 수 없다. |
| 시도한 방법 | 기존 보호 경로, 로그인 완료 처리, OAuth 성공·실패 처리와 메뉴 목적지를 확인했다. 서버 OAuth 코드는 변경하지 않았다. |
| 해결 | 허용된 내부 업무 경로의 쿼리·앵커를 유지해 로그인 후 replace로 이동한다. OAuth 시작 시에는 주소만 탭 저장소에 15분간 보관하고 회원 확인 완료 후 1회 사용한다. 소셜 계정 연동의 마이페이지 이동은 유지한다. npm ci, lint(오류 0개·기존 경고 3개), 테스트(233개 통과·실패 0개), build를 통과했다. 실제 계정의 이메일·소셜 로그인 화면 검증은 별도로 필요하다. |
| 재발 방지 | 외부 주소·인증 화면·존재하지 않는 경로 차단, 로그인 실패 시 이동 방지, OAuth 복귀·만료·연동 유지와 라우터 뒤로 가기를 회귀 테스트한다. |
| 관련 | MEALFIT-52 / frontend/src/models/loginNavigation.js / frontend/src/hooks/loginNavigation.js / frontend/tests/loginNavigation.test.mjs |

### TS-20261125-01 루틴을 다시 받으면 위험 신호 운동 차단이 풀림

| 항목 | 내용 |
|---|---|
| 작성일 / 작성자 | 2026-11-25 / 유지훈 (Claude Code 보조) |
| 영역 | backend |
| 상태 | 해결 |
| 증상 | 위험 신호 문장(가슴 통증·호흡곤란 등)으로 그날 운동 시작이 차단(startBlocked=true)된 뒤, 같은 날을 시작일로 POST /workout-routines/recommend를 다시 호출하면 새 세션의 startBlocked가 false가 된다. 이어서 일반 문장("15분만")으로 조정하면 조정까지 적용된다(adjusted=true). |
| 발생 상황 | 로컬 H2 테스트, develop 1c09b5b(PR #34 머지 후). 루틴 생성 → 같은 날짜에 위험 신호 문장으로 조정 → 같은 시작일로 루틴 재추천 → GET /current 또는 조정 재요청. develop에만 있었고 운영(main)과 화면에는 아직 반영되지 않은 상태였다. |
| 원인 | 차단 상태를 따로 저장하지 않고 세션 행의 adjust_note가 "위험신호:운동중단"으로 시작하는지로만 판단한다. 재추천은 시작일 이후 활성 세션을 모두 비활성화하고 adjust_note가 빈 새 세션을 만들기 때문에 차단 표시가 이어지지 않았다. |
| 시도한 방법 | 위 순서를 통합 테스트로 재현해 재추천 응답·/current·조정 응답 모두 startBlocked=false임을 확인했다. 수정 범위는 담당자와 정했다: 오늘 날짜의 차단만 이어 가고, 미래 날짜 차단은 이어 가지 않는다. |
| 해결 | 재추천 시작일이 오늘이면, 오늘 날짜에 차단 표시가 남은 세션(교체된 비활성 세션 포함)이 있는지 확인하고 새로 만든 오늘 세션에 같은 차단 표시를 다시 넣는다. DB 스키마 변경 없음. backend에서 gradlew.bat test 실행 결과 372개 중 실패 0개(기존 조건부 건너뜀 10개). |
| 재발 방지 | WorkoutSessionAdjustApiTest에 회귀 테스트 2개 추가: 오늘 차단 후 재추천(2회)·조회·일반 문장 조정에서도 startBlocked=true 유지, 미래 날짜 차단은 재추천 후 이어 가지 않음. 오늘 차단 테스트는 일요일(주 6일 루틴에 세션 없음)에는 건너뛴다. |
| 관련 | PR #34 / MEALFIT-116 / WorkoutRoutineService.java / WorkoutSessionRepository.java / WorkoutSessionAdjustApiTest.java / feature/workout-keep-emergency-block |

### TS-20261127-01 로그인 안내를 닫으면 누른 버튼에서 키보드 포커스가 사라짐

| 항목 | 내용 |
|---|---|
| 작성일 / 작성자 | 2026-11-27 / Codex |
| 영역 / 상태 | frontend / 해결 |
| 증상 | 비로그인 홈에서 ‘첫 재료 등록하기’로 모달을 연 뒤 Esc를 누르면 키보드 포커스가 문서 본문으로 이동했다. |
| 발생 상황 | 로컬 H2와 Chrome에서 회원 전용 기능 안내 모달의 열기·닫기를 검증하던 중 발견했다. |
| 원인 | 닫기 시 React가 열린 dialog를 먼저 제거하고, effect 정리 단계에서 close()를 호출했다. |
| 해결 | ‘계속 둘러보기’와 Esc에서 dialog.close()를 호출한 후 모달을 제거한다. |
| 재발 방지 | 데스크톱 1440px·모바일 390px에서 Esc를 누른 뒤 document.activeElement가 ‘첫 재료 등록하기’인지 확인했다. |
| 관련 | frontend/src/components/common/LoginPromptDialog.jsx |
