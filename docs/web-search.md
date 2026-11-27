# 웹 통합 검색 (백엔드 완료 · 화면 연동 준비)

레시피·내 냉장고·내 식단·내 장보기·운동을 한 번에 찾는 검색입니다. 백엔드 API는 완료했고, 화면 연동은 이 문서대로 프론트 담당이 붙입니다.

- 방식: 키워드 + 재료 별칭. 공백·대소문자 무시 포함 검색 ("김치 찌개" = "김치찌개", "greek yogurt" = "Greek Yogurt")
- 별칭: 검색어가 재료 기준표(V15, 59종)의 이름·별칭과 같으면 같은 재료의 다른 이름도 찾습니다 (계란 → 달걀)
- 범위: 레시피는 공용(검수) + 본인 레시피, 나머지는 **본인 데이터만**
- 의미 검색(LLM-02, bge-m3·pgvector)은 별도 작업(박희진·백가연)이라 포함하지 않습니다
- DB 변경 없음 (H2·PostgreSQL 공통 쿼리)

## API

`GET /api/v1/search` (로그인 필요)

| 파라미터 | 필수 | 설명 |
|---|---|---|
| `q` | ✅ | 검색어 1–50자 (앞뒤 공백 제거, 연속 공백은 하나로) |
| `types` | | 대상 목록, 쉼표 구분. 생략하면 전체. `RECIPE`, `INVENTORY`, `MEAL_PLAN`, `SHOPPING`, `EXERCISE`, `WORKOUT` |
| `limit` | | 대상별 최대 건수 1–20, 기본 5 |
| `offset` | | 대상별 건너뛸 건수, 기본 0 |

`limit`·`offset`은 **대상마다 따로** 적용됩니다. 한 대상의 "더보기"는 `types=그 대상`만 + `offset`으로 부릅니다.

### 응답 예 (`q=계란`, 요청하지 않은 대상은 응답에서 빠짐)

```json
{
  "query": "계란",
  "terms": ["계란", "달걀"],
  "recipes": {
    "total": 412,
    "items": [
      { "id": 120, "name": "달걀 채소 볶음", "cookTimeMin": 10, "source": "LOCAL_FALLBACK", "mine": false,
        "matchedIngredients": ["달걀"], "restricted": true, "restrictedIngredients": ["달걀"] }
    ]
  },
  "inventory": {
    "total": 1,
    "items": [
      { "lotId": 7, "ingredientName": "달걀", "quantity": 4, "unit": "개", "expiryDate": "2026-12-01",
        "expirationStatus": "IMMINENT", "storageLocation": "FRIDGE" }
    ]
  },
  "mealPlans": { "total": 0, "items": [] },
  "shoppingItems": {
    "total": 1,
    "items": [ { "id": 3, "ingredientName": "계란", "requiredQty": 1, "purchasedQty": 0, "unit": "개", "status": "NEEDED" } ]
  },
  "exercises": { "total": 0, "items": [] },
  "workouts": { "total": 0, "items": [] }
}
```

| 대상 | 찾는 곳 | 정렬 | 항목 |
|---|---|---|---|
| `recipes` | 요리명, 재료명 | 요리명 일치 먼저, 그다음 id 순 | `id, name, cookTimeMin, source, mine, matchedIngredients, restricted, restrictedIngredients` |
| `inventory` | 사용 중(ACTIVE) 재고의 재료명 | 기한 빠른 순, 기한 미등록 마지막 | `lotId, ingredientName, quantity, unit, expiryDate, expirationStatus, storageLocation` |
| `mealPlans` | 식단 메뉴명 | 최근 날짜 순 | `id, planDate, mealType, status, recipeId, recipeName` |
| `shoppingItems` | 장보기 재료명 | id 순 | `id, ingredientName, requiredQty, purchasedQty, unit, status` |
| `exercises` | 운동 사전 이름·코드 | 이름 순 | `code, name, focusArea, equipment, intensity, poseSupported` |
| `workouts` | 내 운동 세션 제목·항목 | 최근 날짜 순 | `sessionId, sessionDate, title, focusArea, plannedMinutes` |

- `restricted`: 내 알레르기(같은 계열 포함)·제외 재료가 들어 있으면 `true`. 결과에서 빼지 않으니 화면에서 경고 배지로 표시하고, 자세한 사유는 기존 `GET /api/v1/recipes/{id}/allergen-check`로 봅니다.
- 오류: 검색어가 비었거나 50자 초과, `limit` 1–20 밖, `offset` 음수, 없는 `types` 값 → 400 (`COMMON_400`). 로그인 안 함 → 401.

## 화면 연동 준비 (프론트 담당용, 아직 코드 반영 안 함)

기존 패턴(`api/allergens.js`, `api/queryKeys.js`)과 같게 붙이면 됩니다.

```js
// frontend/src/api/search.js
import { api } from '@/api/client'

export const searchApi = {
  /** types: ['RECIPE','INVENTORY',...] (생략하면 전체) */
  search: ({ q, types, limit, offset }, signal) =>
    api.get('/search', { params: { q, types: types?.join(','), limit, offset }, signal }).then((r) => r.data),
}
```

```js
// frontend/src/api/queryKeys.js 에 추가
search: {
  all: (q) => ['search', q],
  type: (q, type, offset) => ['search', q, type, offset],
},
```

화면 제안:
- 상단 검색창 → 입력 300ms 디바운스, 1자 이상이면 `GET /search?q=...` (대상별 5건)
- 결과는 대상별 섹션(레시피 · 냉장고 · 식단 · 장보기 · 운동). `total`이 5보다 크면 "더보기" → `types=해당 대상&offset=5`
- 이동: 레시피 → `/recipes/{id}`, 재고 → 냉장고 화면, 식단 → 해당 날짜 추천 화면, 장보기 → 장보기 화면, 운동 → 운동 화면
- 레시피 `restricted=true`면 "알레르기 주의" 배지, `terms`가 2개 이상이면 "계란·달걀로 찾았어요" 안내

## 테스트

- `SearchApiTest` (H2, 9개): 별칭 확장, 본인 데이터만, 공백·대소문자 무시, 알레르기 표시, 대상별 limit·offset, LIKE 특수문자, 잘못된 요청 400, 로그인 필요
- `SearchPostgresIntegrationTest` (CI PostgreSQL): 같은 쿼리가 PostgreSQL에서 도는지 확인
