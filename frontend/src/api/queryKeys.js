/**
 * TanStack Query 키 모음. 도메인 담당자가 여기에 키를 추가하고,
 * 데이터를 바꾸는 mutation 후에는 관련 키를 invalidate 한다.
 * 예) 조리 완료 → inventory, mealPlans, dashboard 무효화
 */
export const queryKeys = {
  search: {
    all: (userId, q) => ['search', userId, q, 'all'],
    more: (userId, q, type) => ['search', userId, q, type],
  },
  auth: {
    // 회원 간 인증 조회 캐시를 분리합니다.
    me: (userId) => ['auth', 'me', userId ?? null],
  },
  dashboard: {
    all: ['dashboard'],
    byDate: (date) => ['dashboard', date],
    profile: ['dashboard', 'profile'],
    workout: (date) => ['dashboard', 'workout', date],
    weight: ['dashboard', 'weight'],
    coaching: ['dashboard', 'coaching'],
  },
  inventory: {
    all: ['inventory'],
    transactions: (lotId) => ['inventory', 'transactions', lotId ?? 'all'],
  },
  mealPlans: {
    all: ['mealPlans'],
    byDate: (date) => ['mealPlans', date],
  },
  recipes: {
    detail: (id, servings) => ['recipes', id, servings],
  },
  allergens: {
    catalog: ['allergens', 'catalog'],
    search: (q) => ['allergens', 'search', q],
    mine: (userId) => ['allergies', userId],
    checks: (userId) => ['recipeAllergenCheck', userId],
    recipe: (userId, id) => ['recipeAllergenCheck', userId, String(id)],
  },
  shopping: {
    all: ['shopping'],
  },
  // [문장조정][운동기록] 운동 루틴·기록 쿼리 키
  quickMenu: (userId) => ['quick-menu', userId],
  workout: {
    all: ['workout'],
    current: (week) => ['workout', 'current', week ?? null],
    logs: (from, to) => ['workout', 'logs', from ?? null, to ?? null],
    summary: (week) => ['workout', 'summary', week ?? null],
  },
  // [섭취기록] 날짜별 섭취 기록 쿼리 키
  intake: {
    all: ['intake'],
    byDate: (date) => ['intake', date ?? null],
  },
  // [자세판별] 자세 판별 지원 운동 목록
  pose: {
    exercises: ['pose', 'exercises'],
  },
}
