import { api } from '@/api/client'
import { dashboardMock } from '@/api/mocks/dashboardMock'
import { EXPIRATION_STATUS, LOT_STATUS, SHOPPING_ITEM_STATUS } from '@/lib/enums'

/**
 * 대시보드(메인 화면) 데이터. 영역마다 API 완성 시점이 달라서 MOCK을 영역별로 나눈다.
 * API가 완성되면 해당 값을 false로 바꾸고 api/mocks/dashboardMock.js에서 그 함수를 지운다.
 * 서버 응답이 아래 형식과 다르면 화면(DashboardPage)이 아니라 이 파일에서 맞춘다.
 */
export const MOCK = {
  // true: 식단은 예시 데이터, 기한 임박 재료·장보기 부족분은 실제 냉장고·장보기 API로 만든다
  // false: GET /api/v1/dashboard 하나로 받는다 (최원석)
  dashboard: true,
  // GET/PUT /api/v1/me/profile (최원석)
  profile: false,
  // 운동 루틴 (유지훈, Phase 1)
  workout: true,
  // 체중 기록 (최원석, Phase 1)
  weight: true,
  // 30초 컨디션 체크 → AI 코칭 (박희진·유지훈)
  coaching: true,
}

export const MOCK_AREAS = Object.entries(MOCK)
  .filter(([, isMock]) => isMock)
  .map(([area]) => area)

/*
 * GET /api/v1/dashboard?date=YYYY-MM-DD
 * {
 *   date: '2026-10-21',
 *   meals: [                       // MealPlanResponse + intakeStatus (확정 전이면 null)
 *     { id, planDate, mealType, status, servings, recommendationReason,
 *       recipe: { id, name, cookTimeMin, calories, nutritionEstimated, source }, intakeStatus }
 *   ],
 *   expiringLots: [                // 기한 경과·오늘·임박 재고 묶음 (LotResponse)
 *     { id, ingredientName, quantity, unit, expiryDate, storageLocation, status, expirationStatus }
 *   ],
 *   shortages: [                   // 구매 완료가 아닌 장보기 항목 (ShoppingItemResponse)
 *     { id, ingredientName, requiredQty, purchasedQty, remainingQty, unit, status }
 *   ]
 * }
 *
 * POST /api/v1/intake-logs  요청 { mealPlanId, intakeStatus: 'EATEN' | 'SKIPPED' }
 * GET  /api/v1/me/profile   응답 { nickname, goal: 'LOSE' | 'MAINTAIN' | 'GAIN', targetWeightKg, ... }
 */

const EXPIRING = [EXPIRATION_STATUS.EXPIRED, EXPIRATION_STATUS.TODAY, EXPIRATION_STATUS.IMMINENT]

function pickExpiringLots(inventory) {
  return inventory.groups
    .flatMap((group) => group.lots)
    .filter((lot) => lot.status === LOT_STATUS.ACTIVE && EXPIRING.includes(lot.expirationStatus))
    .sort(
      (a, b) =>
        EXPIRING.indexOf(a.expirationStatus) - EXPIRING.indexOf(b.expirationStatus) ||
        String(a.expiryDate).localeCompare(String(b.expiryDate)),
    )
}

async function composeDashboard(date) {
  const [meals, inventory, shoppingItems] = await Promise.all([
    dashboardMock.getMeals(date),
    api.get('/inventory/lots').then((r) => r.data),
    api.get('/shopping-items').then((r) => r.data),
  ])
  return {
    date,
    meals,
    expiringLots: pickExpiringLots(inventory),
    shortages: shoppingItems.filter((item) => item.status !== SHOPPING_ITEM_STATUS.PURCHASED),
  }
}

export const dashboardApi = {
  getDashboard: (date) =>
    MOCK.dashboard ? composeDashboard(date) : api.get('/dashboard', { params: { date } }).then((r) => r.data),
  recordIntake: (body) =>
    MOCK.dashboard ? dashboardMock.recordIntake(body) : api.post('/intake-logs', body).then((r) => r.data),
  getProfile: () => (MOCK.profile ? dashboardMock.getProfile() : api.get('/me/profile').then((r) => r.data)),
  getTodayWorkout: (date) => dashboardMock.getTodayWorkout(date),
  setWorkoutCompleted: (body) => dashboardMock.setWorkoutCompleted(body),
  getWeightSummary: () => dashboardMock.getWeightSummary(),
  getCoaching: () => dashboardMock.getCoaching(),
  checkCondition: (condition) => dashboardMock.checkCondition(condition),
}
