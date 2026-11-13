import { EXPIRATION_STATUS, LOT_STATUS, SHOPPING_ITEM_STATUS } from '../lib/enums.js'

// 기한이 급한 순서: 경과 → 오늘 → 임박
const EXPIRING = [EXPIRATION_STATUS.EXPIRED, EXPIRATION_STATUS.TODAY, EXPIRATION_STATUS.IMMINENT]

/** 보관 중인 재고 묶음 중 기한 경과·오늘·임박인 것만 급한 순서로 고른다 */
export function pickExpiringLots(inventory) {
  return inventory.groups
    .flatMap((group) => group.lots)
    .filter((lot) => lot.status === LOT_STATUS.ACTIVE && EXPIRING.includes(lot.expirationStatus))
    .sort(
      (a, b) =>
        EXPIRING.indexOf(a.expirationStatus) - EXPIRING.indexOf(b.expirationStatus) ||
        String(a.expiryDate).localeCompare(String(b.expiryDate)),
    )
}

/** 식단·냉장고·장보기 응답을 대시보드 응답 형식(GET /dashboard)으로 묶는다 */
export function buildDashboard({ date, meals, inventory, shoppingItems }) {
  return {
    date,
    meals,
    expiringLots: pickExpiringLots(inventory),
    shortages: shoppingItems.filter((item) => item.status !== SHOPPING_ITEM_STATUS.PURCHASED),
  }
}
