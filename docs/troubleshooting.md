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
