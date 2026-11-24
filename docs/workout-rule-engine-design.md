# 운동 루틴 규칙 엔진 상세 설계 (초안)

- 작성: 유지훈 · 검토: 최원석 · 2026-11-23 · 상태: **확정 (2026-11-23 최원석 동의, 10장 제안값 그대로 채택)**
- PL 확인: Flyway 번호 V10·V11 사용 확정(D9). 현재 루틴 조회 API 추가(D8)는 PL 확인 필요.
- 범위: FR-WORK-01 맞춤 운동 루틴, BR-17 루틴 검증·기본 루틴, `exercise_catalog` 운동 사전
- 근거: PRD v0.5 10장·BR-17·BR-18·QA-27·28·31–33 / TRD v0.18 AI-03·DOM-05·D-09·품질 목표(생성·조정 p95 ≤ 500ms) / SDD v0.3.7 5.8·6.5·8.1
- 표기: **[결정 Dn]** = 확정이 필요한 항목. 맨 아래 10장에 모았습니다. **[D18]** = 운동 안전 기준에서 정할 값이며, 여기 적은 값은 자리표시 제안입니다.

---

## 1. 담당 경계

WBS(11/18 최종본)를 따릅니다.

| 구분 | 유지훈 | 최원석 |
|---|---|---|
| 데이터 | `exercise_catalog` 스키마·시드 | 키워드 사전(시간·부위·강도) |
| 엔진 | 입력 정규화, 템플릿 생성기, 세션 구성기, **검증기(BR-17)**, 기본 루틴 | 문장 키워드 해석기 (FR-WORK-02) |
| API | `POST /workout-routines/recommend`, 루틴 조회 | `PATCH /workout-routines/{id}/sessions/{date}`, `/workout-logs`, `/workout-logs/summary` |
| 테이블 | `exercise_catalog`, `workout_routines`, `workout_sessions` | `workout_logs`, 키워드 사전 테이블 |
| 공통 | 검증기와 세션 구성기는 조정 API에서도 그대로 호출합니다 (같은 검증, PRD FR-WORK-02) | 운동 조건 저장(FR-PROF-05)은 입력 값 범위를 이 문서 3장과 맞춥니다 |

### 1.1 무게 단위 (2026-11-24 유지훈 결정)

- 운동에서 쓰는 무게(중량 기록, 덤벨·바벨 무게 등)는 **kg**로 저장하고 표시합니다. 마이페이지 체중(`currentWeight`·`targetWeight`)도 kg라서 앱 전체가 같습니다.
- 컬럼·필드 이름에 단위를 붙입니다 (예: `weight_kg`). 2.5kg 원판처럼 소수가 있으므로 `DECIMAL(6,2)`로 둡니다.
- 지금 무게 칸이 있는 테이블은 없습니다. `workout_logs`(최원석)에 중량 기록을 넣을 때 이 규칙을 따릅니다.
- 냉장고 재고는 다릅니다: 그룹 합계를 g·ml로 보여줍니다 (MEALFIT-56).

## 2. 패키지 구조

가이드라인 MVC 배치를 따릅니다: `com.mealfit.domain.workout`

```
workout/
  controller/  WorkoutRoutineController           (/api/v1/workout-routines)
  dto/         RoutineRecommendRequest, RoutineResponse, SessionResponse, ExerciseItemResponse
  entity/      ExerciseCatalog, WorkoutRoutine, WorkoutSession, (WorkoutLog: 최원석)
               enum: RoutineSource, RoutineStatus
  model/       (순수 값 객체, 스프링 의존 없음)
               WorkoutConditions, ExerciseDef, SessionPlan, PlannedExercise
               enum: Goal, Level, Equipment, BodyArea, Phase, Intensity, FocusArea, ViolationType
  repository/  ExerciseCatalogRepository, WorkoutRoutineRepository, WorkoutSessionRepository
  service/     WorkoutConditionsProvider   profile_details + 요청 값 → WorkoutConditions
               ExerciseCatalogCache        사전을 메모리에 캐시 (작고 거의 안 바뀜)
               RoutineTemplateGenerator    요일 배치·부위 배분 (순수 함수)
               SessionComposer             운동 선택·세트/횟수·시간 맞추기 (순수 함수)
               RoutineValidator            BR-17 (생성기와 독립, 조정에서도 사용)
               DefaultRoutineProvider      검증된 기본 세션
               WorkoutRoutineService       트랜잭션·저장·교체 조율
               (KeywordInterpreter: 최원석)
```

- 생성기·구성기·검증기는 **DB와 시계에 의존하지 않는 순수 클래스**로 만듭니다. 입력(조건, 사전 목록, 시작일, 시드)만으로 결과가 정해지게 해서 단위 테스트를 쉽게 하고 p95 목표를 지킵니다.
- 오늘 날짜는 기존 코드처럼 주입한 `Clock`(Asia/Seoul)에서 얻습니다.

## 3. 입력 정규화 (`WorkoutConditions`)

요청 값이 우선이고, 없으면 `profile_details`의 값을 씁니다. 둘 다 없으면 `WORKOUT_001`(운동 조건 없음)을 반환해 프로필 입력을 안내합니다.

| 항목 | 저장 값 (현재 코드) | 엔진 값 | 메모 |
|---|---|---|---|
| 목표 | `loss` / `hypertrophy` / `stamina` / `health` | `FAT_LOSS` / `STRENGTH` / `ENDURANCE` / `MAINTAIN` | SDD 6.5의 감량·근력·체력·유지와 1:1 대응 |
| 수준 | `starter` / `beginner` / `intermediate` / `advanced` | `Level` 4단계 | 강도 상한에 씀 [D18] |
| 주당 일수 | 2–6 | 2–6 | 문서와 같음 |
| 회당 시간 | **10–90 아무 값** | **15 / 30 / 45 / 60** | 문서와 다름 → **[결정 D1]** |
| 장비 | `dumbbell, band, mat, pullup_bar, foam_roller, kettlebell, none, barbell, gym` | `Equipment` 같은 코드 + 맨몸(`BODYWEIGHT`) 항상 보유 | `gym`의 의미 → **[결정 D2]** |
| 부상 부위 | **자유 문자열** (화면 선택지: 허리·무릎·어깨·목·손목·발목·고관절) | `BodyArea` 코드 7개: `LOWER_BACK, KNEE, SHOULDER, NECK, WRIST, ANKLE, HIP` | 모르는 값의 처리 → **[결정 D3]** |
| 최근 기록 | `workout_logs` 최근 14일 | `recentSkipRatio` | 강도를 낮추는 기준 → **[결정 D4]** |

**강도 단계** (`Intensity` 1=LOW, 2=MID, 3=HIGH). 실제 상한값은 D18에서 정합니다.

| 수준 | 상한 (제안) [D18] |
|---|---|
| starter | 1 |
| beginner | 2 |
| intermediate | 3 |
| advanced | 3 |

- 최근 14일 기록이 2건 이상이고 건너뜀 비율이 50% 이상이면 상한을 한 단계 낮춥니다 (최저 1). SDD 6.5의 "건너뜀이 많으면 강도를 한 단계 낮춘다"를 구체화한 것입니다. [결정 D4]
- 통증·질환 키워드(조정 문장)나 부상 부위가 하나라도 있으면 응답 `notices`에 전문가 상담 안내를 넣습니다. 문구는 D18에서 정합니다.

## 4. 운동 사전 `exercise_catalog`

공용 참조 데이터이며 Flyway 시드로 넣습니다 (SDD 8.1). 사용자 데이터가 아니므로 `user_id`가 없습니다.

| 컬럼 | 타입 | 설명 |
|---|---|---|
| id | BIGINT PK | |
| code | VARCHAR(50) UNIQUE | `PUSHUP`, `BW_SQUAT` 등. API·로그에서 이 값으로 참조 |
| name_ko | VARCHAR(100) | 표준 운동명 |
| phase | VARCHAR(20) | `WARM_UP` / `MAIN` / `COOL_DOWN` (한 운동은 한 단계) |
| focus_area | VARCHAR(20) | `UPPER_PUSH` / `UPPER_PULL` / `LOWER` / `CORE` / `FULL` / `CARDIO` / `MOBILITY` |
| equipment | VARCHAR(20) | 필요 장비 1개 (`BODYWEIGHT` = 맨몸). 장비가 2개 필요한 운동은 v1에서 넣지 않음 |
| intensity | SMALLINT | 1–3 |
| unit | VARCHAR(20) | `REPS` / `SECONDS` |
| default_sets | SMALLINT | |
| default_reps | SMALLINT NULL | unit=REPS일 때 |
| default_seconds | SMALLINT NULL | unit=SECONDS일 때 (1세트 시간) |
| seconds_per_rep | DECIMAL(4,1) | 시간 추정용 (예: 스쿼트 3.0초) |
| rest_seconds | SMALLINT | 세트 사이 기본 휴식 |
| pose_exercise_key | VARCHAR(50) NULL | 자세 판별(FR-WORK-05) 지원 운동이면 그 키. 루틴 엔진은 쓰지 않음 |
| active | BOOLEAN | 사전에서 빼지 않고 끌 때 |

자식 테이블 `exercise_catalog_load_areas(exercise_id, body_area)`에는 **그 운동이 부담을 주는 관절·부위**를 넣습니다. 부상 제외는 이 값과 사용자의 부상 부위를 겹쳐 봐서 판정합니다.
- 예: 점프 스쿼트 → `KNEE, ANKLE` / 푸시업 → `WRIST, SHOULDER` / 데드리프트 → `LOWER_BACK, HIP`
- 부위별로 어떤 운동을 뺄지 정하는 것 자체가 D18입니다. QA-28(무릎 부상 + 점프 운동)은 이 테이블로 검증합니다.

**시드 규모 (제안)**: 약 45종입니다. 장비 조합마다 모든 부위를 채울 수 있게 맞춥니다.
- 맨몸만으로 모든 `focus_area`를 최소 2종씩 채웁니다. 장비가 없어도 항상 루틴이 나오게 하기 위해서입니다.
- 덤벨·밴드·케틀벨·풀업바·바벨을 각각 부위별로 1–2종씩 넣습니다.
- 준비 운동 8종, 정리 운동 8종 (부담 부위가 최소인 이완·호흡 위주)
- 자세 판별 23종 중 맨몸·덤벨·바벨 운동은 같은 이름으로 넣고 `pose_exercise_key`를 연결합니다. 루틴에서 자세 판별로 바로 이어질 수 있습니다.

## 5. 루틴·세션 테이블

### 5.1 `workout_routines`

| 컬럼 | 타입 | 설명 |
|---|---|---|
| id | BIGINT PK | |
| user_id | BIGINT FK users | 소유자 |
| goal / level | VARCHAR(20) | 생성 당시 조건 |
| days_per_week | SMALLINT | |
| session_minutes | SMALLINT | |
| equipment_snapshot | VARCHAR(500) | 생성 당시 장비 코드 (쉼표 구분). 프로필이 바뀌어도 이 루틴이 무엇으로 만들어졌는지 남김 |
| injuries_snapshot | VARCHAR(500) | 생성 당시 부상 코드 |
| intensity_cap | SMALLINT | 실제 적용한 상한 |
| source | VARCHAR(20) | `RULE` / `DEFAULT` (전체가 기본 루틴이면 DEFAULT) |
| rule_version | VARCHAR(20) | 예: `wr-1.0`. 템플릿·사전이 바뀌면 올림 |
| status | VARCHAR(20) | `ACTIVE` / `REPLACED` |
| start_date | DATE | 루틴이 시작되는 주의 월요일 |
| created_at / updated_at | | BaseTimeEntity |

### 5.2 `workout_sessions`

| 컬럼 | 타입 | 설명 |
|---|---|---|
| id | BIGINT PK | |
| routine_id | BIGINT FK | |
| user_id | BIGINT FK users | 조회·소유권 확인용으로 둠 (findByIdAndUserId) |
| session_date | DATE | |
| focus_area | VARCHAR(20) | |
| title | VARCHAR(100) | 예: "하체 근력 30분" |
| planned_minutes | SMALLINT | 추정 시간 합계 (≤ session_minutes) |
| items | TEXT (JSON) | 운동 목록. 아래 형식 |
| source | VARCHAR(20) | `RULE` / `DEFAULT` (세션 단위 대체 여부) |
| adjusted | BOOLEAN | 문장 조정 여부 (FR-WORK-02) |
| adjust_note | VARCHAR(200) NULL | 해석된 키워드 요약 (원문은 저장하지 않음) |
| active_key | DATE NULL | 활성 세션이면 session_date, 교체되면 NULL |
| created_at / updated_at | | |

- 제약 `UNIQUE(user_id, active_key)`로 "같은 사용자·날짜의 활성 세션 중복 방지"(SDD 8.1)를 구현합니다.
  - NULL끼리는 겹쳐도 되므로, 교체된 지난 세션은 여러 개 남아도 됩니다.
  - PostgreSQL 부분 인덱스(`WHERE active`)를 쓰지 않는 이유는 H2 테스트에서도 같은 마이그레이션이 돌게 하기 위해서입니다.
- **휴식일은 행으로 저장하지 않습니다.** 활성 루틴의 기간 안인데 그 날짜에 세션이 없으면 휴식일, 활성 루틴이 없으면 "루틴 없음"으로 판단합니다. 이렇게 FR-DASH-04·QA-32의 구분을 처리합니다.
- `items`를 별도 테이블 대신 JSON 텍스트로 두는 이유: 세션 안 운동 목록은 항상 통째로 읽고 쓰고, 조정할 때도 세션 전체를 다시 만듭니다. 운동별 집계는 v1 범위에 없습니다. [결정 D5]

`items` 형식:
```json
[
  {"phase":"WARM_UP","code":"ARM_CIRCLE","name":"팔 돌리기","sets":1,"seconds":60,"restSeconds":0},
  {"phase":"MAIN","code":"DB_GOBLET_SQUAT","name":"덤벨 고블릿 스쿼트","sets":3,"reps":12,"restSeconds":60},
  {"phase":"COOL_DOWN","code":"HAMSTRING_STRETCH","name":"햄스트링 스트레칭","sets":1,"seconds":60,"restSeconds":0}
]
```

### 5.3 몇 주치 세션을 만들지 [결정 D6]

- **제안 (A)**: 생성할 때 **이번 주(시작일 ~ 일요일)와 다음 주, 2주치**를 저장합니다. 그다음 주는 루틴 조회 시 같은 규칙·시드로 이어서 만듭니다 (지연 생성).
  - 장점: 대시보드·주간 현황이 항상 실제 세션 행을 기준으로 집계됩니다.
- 대안 (B): 생성할 때 1주치만 저장하고, 매주 루틴을 다시 받게 합니다. 구현은 단순하지만 사용자가 매주 다시 받아야 합니다.

## 6. 생성 알고리즘 (FR-WORK-01)

입력은 `WorkoutConditions`, 사전 목록, 시작일, 시드입니다. 시드는 `hash(userId, start_date, rule_version)`이며, 같은 입력이면 항상 같은 루틴이 나옵니다.

### 6.1 요일 배치 [결정 D7]

| 주당 일수 | 운동 요일 (제안) |
|---|---|
| 2 | 월, 목 |
| 3 | 월, 수, 금 |
| 4 | 월, 화, 목, 금 |
| 5 | 월, 화, 수, 금, 토 |
| 6 | 월 ~ 토 |

- PRD는 "요일 수"만 받습니다. 사용자가 요일을 직접 고르는 기능은 v1에서 빼는 것을 제안합니다.
- 시작일이 주 중간이면, 그 주는 시작일 이후의 운동 요일만 만듭니다.

### 6.2 목표별 부위 배분 (템플릿)

| 목표 | 2–3일 | 4일 | 5–6일 | 본 운동 구성 |
|---|---|---|---|---|
| STRENGTH 근력 | 전신 | 상체 / 하체 반복 | 상체 밀기 / 하체 / 상체 당기기 / 코어 순환 | 근력 운동 위주 |
| FAT_LOSS 감량 | 전신 서킷 | 전신 / 유산소+코어 반복 | 전신 / 하체 / 유산소 / 상체 순환 | 서킷 + 마지막 유산소 블록 |
| ENDURANCE 체력 | 유산소+전신 | 유산소 / 전신 반복 | 유산소 / 하체 / 전신 / 코어 순환 | 시간 기반 (40초 운동·20초 휴식) |
| MAINTAIN 유지 | 전신+가동성 | 전신 / 가동성+코어 반복 | 전신 / 가동성 / 코어 순환 | 가벼운 근력 + 가동성 |

- 같은 부위(하체, 상체 밀기 등)는 연속된 날에 두지 않습니다 (48시간 간격).
- "전신"이면 본 운동 칸을 하체 → 상체 밀기 → 상체 당기기 → 코어 순서로 채웁니다.

### 6.3 시간 배분

| 회당 시간 | 준비 | 본 운동 | 정리 |
|---|---|---|---|
| 15분 | 3 | 10 | 2 |
| 30분 | 5 | 21 | 4 |
| 45분 | 7 | 32 | 6 |
| 60분 | 8 | 44 | 8 |

### 6.4 후보 필터

사전에서 다음을 모두 만족하는 운동만 후보로 씁니다. 검증기도 같은 조건을 다시 확인합니다.
1. `active = true`
2. `equipment ∈ 보유 장비 ∪ {BODYWEIGHT}`
3. `load_areas ∩ 부상 부위 = ∅` [D18]
4. `intensity ≤ intensity_cap`
5. `phase`, `focus_area`가 그 칸과 맞음

### 6.5 선택과 분량

- 칸마다 후보를 `(장비를 쓰는 운동 우선, intensity 높은 순, code)`로 정렬합니다. 그다음 요일 번호와 시드로 시작 위치를 돌려서, 같은 부위의 날이라도 운동이 조금씩 바뀌게 합니다.
- 목표별 기본 분량 (수준에 따라 조정, 상한은 [D18]):

| 목표 | 세트 | 횟수 / 시간 | 휴식 |
|---|---|---|---|
| STRENGTH | 3 | 8–12회 (사전 기본값) | 90초 |
| FAT_LOSS | 3 | 12–15회 | 45초 |
| ENDURANCE | 2–3 | 40초 | 20초 |
| MAINTAIN | 2 | 10–12회 | 60초 |

- 수준 보정: starter는 세트 −1(최소 1), advanced는 세트 +1(최대 4)입니다. [D18]
- **시간 추정**: 운동 1개 = `세트 × (횟수 × seconds_per_rep 또는 seconds) + (세트−1) × 휴식 + 전환 30초`
- 본 운동 칸을 순서대로 채우다가 예산을 넘으면, 넘긴 운동의 세트를 줄입니다. 그래도 넘으면 그 운동을 뺍니다. 결과적으로 **세션 합계 ≤ 회당 시간**이 항상 성립합니다 (BR-17).
- 본 운동이 1개도 들어가지 못하면 그 세션은 6.6의 기본 세션으로 대체합니다.

### 6.6 기본 루틴 (`DefaultRoutineProvider`)

- 조건을 만족하는 조합이 없을 때 쓰는, **미리 검증한 세션 묶음**입니다.
  - 맨몸, intensity 1, 부담 부위가 최소인 운동(걷기·호흡·가벼운 이완 등)으로 시간별(15/30/45/60분)로 둡니다.
- 부상 부위 때문에 기본 세션도 걸리면, 그 운동을 뺀 이완·호흡 세션과 상담 안내를 보여 줍니다.
- 내용(어떤 운동을 몇 분)은 D18에서 확정합니다.
- 응답에는 `source: DEFAULT`와 안내 문구를 넣습니다. 예: "선택한 조건에 맞는 운동이 부족해 기본 루틴을 보여 드려요."

## 7. 검증기 `RoutineValidator` (BR-17)

생성기를 믿지 않고 저장 직전에 **독립적으로 다시 확인**합니다. 조정 결과(FR-WORK-02)에도 같은 메서드를 씁니다.

| 검사 | 위반 코드 | 근거 |
|---|---|---|
| 사전에 있는 활성 운동인가 | `UNKNOWN_EXERCISE` | SDD 6.5 |
| 필요 장비를 보유했는가 | `EQUIPMENT_NOT_OWNED` | BR-17 |
| 부담 부위가 부상 부위와 겹치지 않는가 | `INJURY_CONFLICT` | BR-17, D18 |
| 강도 ≤ 상한인가 | `INTENSITY_EXCEEDED` | D-09 |
| 세션 추정 시간 합계 ≤ 회당 시간인가 | `TIME_EXCEEDED` | BR-17 |
| 세트·횟수·시간이 허용 범위 안인가 (세트 1–5, 횟수 1–30, 시간 10–600초) | `DOSAGE_OUT_OF_RANGE` | D18 |
| 본 운동이 1개 이상인가 | `EMPTY_MAIN` | FR-WORK-01 |

- 결과는 `List<Violation>`입니다.
  - 생성: 위반한 **세션만** 기본 세션으로 바꿉니다 (TRD AI-03 "위반 세션은 저장하지 않고 검증된 기본 루틴으로 대체"). 바꾼 세션도 다시 검증합니다.
  - 조정: 위반이면 원래 세션을 유지하고 안내합니다 (최원석님과 확인 필요).
- 위반 내용은 로그에 운동 코드와 위반 코드만 남깁니다. 부상 부위 같은 건강 정보는 로그에 남기지 않습니다 (NFR-SEC-04 취지).

## 8. API

### 8.1 `POST /api/v1/workout-routines/recommend`

요청 (모든 필드 선택, 없으면 프로필 값):
```json
{
  "goal": "hypertrophy",
  "daysPerWeek": 3,
  "sessionMinutes": 30,
  "equipment": ["dumbbell"],
  "injuries": ["무릎"],
  "startDate": "2026-11-23"
}
```
- `startDate`가 없으면 오늘입니다. 과거 날짜는 400으로 거부합니다.
- 요청에 준 조건을 프로필에 저장하지는 않습니다. 프로필 저장은 FR-PROF-05 API가 맡습니다.

응답 `201`. 지금 운동 화면(`WorkoutPage`)이 쓰는 필드 이름(`isRestDay, focusArea, durationMinutes, title, warmUp, exercises, coolDown`)에 맞췄습니다:
```json
{
  "routineId": 12,
  "goal": "hypertrophy",
  "daysPerWeek": 3,
  "sessionMinutes": 30,
  "source": "RULE",
  "ruleVersion": "wr-1.0",
  "notices": ["통증이 계속되면 전문가와 상담해 주세요."],
  "days": [
    {
      "date": "2026-11-23", "dayOfWeek": "MON", "isRestDay": false,
      "sessionId": 101, "focusArea": "FULL", "title": "전신 근력 30분",
      "durationMinutes": 28, "source": "RULE", "adjusted": false,
      "warmUp":    [{"code":"ARM_CIRCLE","name":"팔 돌리기","sets":1,"seconds":60}],
      "exercises": [{"code":"DB_ROW","name":"덤벨 로우","sets":3,"reps":12,"restSeconds":90}],
      "coolDown":  [{"code":"CHEST_STRETCH","name":"가슴 스트레칭","sets":1,"seconds":60}]
    },
    {"date": "2026-11-24", "dayOfWeek": "TUE", "isRestDay": true}
  ]
}
```
- 화면 예시 데이터는 `reps: "12~15회"`처럼 문자열이지만, API는 숫자로 주고 화면에서 표시 문자열을 만듭니다 (`lib`의 라벨 함수).

### 8.2 `GET /api/v1/workout-routines/current?week=2026-11-23` [결정 D8]

- 운동 화면과 대시보드가 처음 열릴 때 필요하지만 TRD API 표에는 없습니다. 추가를 제안합니다.
- 활성 루틴이 없으면 `200`에 `{"routineId": null, "days": []}`를 돌려줍니다. 화면은 이걸 보고 "루틴 받기"를 안내합니다.

### 8.3 오류 코드 (`ErrorCode`에 추가)

| 코드 | HTTP | 메시지 |
|---|---|---|
| WORKOUT_001 | 422 | 운동 조건이 없습니다. 프로필에서 운동 조건을 먼저 입력해 주세요. |
| WORKOUT_002 | 400 | 허용하지 않는 운동 조건입니다. (일수·시간·장비·부상 값) |
| WORKOUT_003 | 404 | 운동 루틴을 찾을 수 없습니다. |
| WORKOUT_004 | 404 | 운동 세션을 찾을 수 없습니다. |
| WORKOUT_005 | 409 | 루틴을 동시에 여러 번 요청했습니다. 잠시 뒤 다시 시도해 주세요. |

(WORKOUT_006 이후는 최원석님 조정·기록용으로 비워 둡니다.)

## 9. 저장·트랜잭션·성능

`WorkoutRoutineService.recommend`는 `@Transactional` 하나로 처리합니다:
1. `userRepository.findByIdForUpdate(userId)`로 회원 행을 잠급니다. 같은 사용자의 동시 요청을 줄 세우며, 기존 인증 코드와 같은 방식입니다.
2. 조건을 정규화합니다. 최근 기록 요약은 `workout_logs`에서 읽습니다. 최원석님 테이블이 아직 없으면 빈 요약으로 시작합니다.
3. 생성 → 검증 → 위반 세션 대체 → 다시 검증합니다.
4. 기존 `ACTIVE` 루틴을 `REPLACED`로 바꿉니다. 그 루틴의 **오늘 이후 세션 중 기록이 없는 것**만 `active_key = NULL`로 비활성화합니다. 기록이 있는 지난 세션은 그대로 둡니다 (FR-WORK-04 "루틴을 다시 받아도 지난 기록은 유지").
5. 새 루틴과 세션을 저장합니다. 4에서 남은 활성 세션(예: 오늘 이미 기록한 세션)이 있는 날짜는 새 루틴에서 건너뛰어 같은 날짜에 세션이 두 개 생기지 않게 합니다. 그래도 유일 제약 위반이 나면 `WORKOUT_005`를 돌려줍니다.

- 성능: 사전은 `ExerciseCatalogCache`로 메모리에 둡니다(약 45행). 생성은 순수 계산이고 DB 접근은 잠금 1회, 기록 조회 1회, insert 묶음뿐이라 p95 500ms 안에 들어갈 것으로 봅니다. 통합 테스트로 시간을 잽니다.
- 운동 조건·부상 정보는 AI 서비스로 보내지 않습니다 (NFR-SEC-04). 이 도메인에는 AI 클라이언트가 없습니다.

## 10. 결정 필요 항목

| # | 항목 | 제안 | 누구와 |
|---|---|---|---|
| D1 | 회당 시간: 프로필은 10–90 아무 값, 문서는 15/30/45/60 | 프로필 검증을 15/30/45/60으로 바꿈 (FR-PROF-05). 그 전까지 엔진은 가까운 아래 값으로 내림 (최소 15) | 최원석 |
| D2 | 장비 `gym`(백엔드만 있고 화면에 없음)의 의미 | `gym` = 바벨·덤벨·케틀벨·밴드·풀업바·매트 전부 보유로 해석. 머신 운동은 v1 사전에 넣지 않음 | 최원석 |
| D3 | 부상 부위 자유 문자열 | 화면 7개 값만 허용하도록 프로필 검증 추가 → 코드로 변환. 모르는 값이 오면 강도 상한 1과 상담 안내 | 최원석, D18 |
| D4 | "건너뜀이 많으면" 기준 | 최근 14일 기록 2건 이상 + 건너뜀 50% 이상 → 상한 −1 | 최원석 |
| D5 | 세션 운동 목록 저장 방식 | JSON 텍스트 1컬럼 | 최원석, PL |
| D6 | 몇 주치를 만들지 | 2주치 저장 + 이후 지연 생성 | 최원석 |
| D7 | 요일 배치 | 6.1 표 고정, 요일 선택은 v1 제외 | 최원석, 백가연(화면) |
| D8 | 현재 루틴 조회 API | `GET /workout-routines/current?week=` 추가 | PL (TRD API 표) |
| D9 | Flyway 번호 | V10 `exercise_catalog`+시드, V11 `workout_routines`·`workout_sessions` (최원석 `workout_logs`·키워드 사전과 순서 조율) | PL |
| D18 | 운동 안전 기준 | 강도 상한(3장), 부위별 제외(4장 `load_areas`), 분량 범위(7장), 안내 문구, 기본 루틴 내용(6.6) | 최원석 |

## 11. 테스트 계획

- **단위 (순수 클래스)**
  - 생성기 결정성: 같은 입력이면 같은 결과
  - 일수·요일 배치, 연속일에 같은 부위가 없음
  - 세션 시간 ≤ 회당 시간 (15/30/45/60 × 목표 4 × 수준 4 전부 돌려 봄)
  - 장비 미보유 운동 없음, 부상 부위 운동 없음, 강도 상한 지킴
  - 후보가 없을 때 기본 세션, 기본 세션도 검증 통과
  - 검증기: 위반 코드별 표 테스트
- **통합 (H2 + `PostgresSchemaIntegrationTest`)**
  - QA-27 앞부분: 3일·30분·덤벨만으로 생성
  - QA-28: 점프 운동과 미보유 장비 운동만 남긴 사전 + 무릎 부상 → 위반 저장 0건, 기본 루틴과 안내
  - QA-31: 바벨을 빼고 무릎을 추가한 뒤 다시 생성 → 바벨·무릎 부담 운동 없음
  - 다시 받기: 지난 기록이 있는 세션 유지, 기록 없는 미래 세션 교체, 활성 세션 중복 0
  - 다른 사용자 루틴 접근 → 404
  - p95 시간 측정
- 마감: 단위·통합 테스트는 12/4 중간보고 전 완료 (팀 일정 12/2–3).

## 12. 작업 순서 (11/23 – 11/27)

| 날짜 | 작업 | WBS |
|---|---|---|
| 11/23 | 이 설계 검토(최원석) · D1–D9 정리 · D18 초안 | 규칙 엔진 설계(밀림), D18(밀림) |
| 11/24 | `exercise_catalog` 마이그레이션·시드 45종, 엔티티·캐시 | 운동 사전 구축 (~11/24) |
| 11/25 | `model` 값 객체, 생성기·구성기 + 단위 테스트 | FR-WORK-01 |
| 11/26 | 검증기·기본 루틴, 루틴·세션 테이블, recommend·current API | FR-WORK-01 (~11/26), BR-17 시작 |
| 11/27 | 다시 받기·동시성, QA-27·28·31 통합 테스트, PR → develop | BR-17 (~11/27) |
