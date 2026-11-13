import { EXPIRATION_STATUS, LOT_STATUS } from '../lib/enums.js'
import { formatQuantity } from '../lib/format.js'

/** 보관 위치 필터의 '전체' 값 */
export const ALL_STORAGE = 'ALL'

// 그룹 배지는 가장 급한 상태 하나를 보여준다
const EXPIRATION_PRIORITY = [
  EXPIRATION_STATUS.EXPIRED,
  EXPIRATION_STATUS.TODAY,
  EXPIRATION_STATUS.IMMINENT,
  EXPIRATION_STATUS.NORMAL,
  EXPIRATION_STATUS.UNKNOWN,
]

const isActive = (lot) => lot.status === LOT_STATUS.ACTIVE
const isArchived = (lot) => lot.status === LOT_STATUS.DEPLETED || lot.status === LOT_STATUS.DISPOSED

/** 보관 중 묶음의 총량·사용 가능량·기한 경과량. 소수 셋째 자리까지 정수로 합산해 표시 오차를 줄인다 */
export function summarizeLots(lots) {
  const activeLots = lots.filter(isActive)
  const total = activeLots.reduce((sum, lot) => sum + Math.round(Number(lot.quantity) * 1000), 0)
  const expired = activeLots
    .filter((lot) => lot.expirationStatus === EXPIRATION_STATUS.EXPIRED)
    .reduce((sum, lot) => sum + Math.round(Number(lot.quantity) * 1000), 0)
  return { totalQuantity: total / 1000, availableQuantity: (total - expired) / 1000, expiredQuantity: expired / 1000 }
}

/** 재료 그룹 카드에 필요한 값: 보관 중·사용 가능·기한 경과 묶음, 가장 급한 기한 상태, 가장 빠른 기한 */
export function describeGroup(group) {
  const activeLots = group.lots.filter(isActive)
  return {
    activeLots,
    usableLots: activeLots.filter((lot) => lot.expirationStatus !== EXPIRATION_STATUS.EXPIRED),
    expiredLots: activeLots.filter((lot) => lot.expirationStatus === EXPIRATION_STATUS.EXPIRED),
    worstStatus: EXPIRATION_PRIORITY.find((status) => activeLots.some((lot) => lot.expirationStatus === status)),
    earliestExpiry: activeLots.map((lot) => lot.expiryDate).filter(Boolean).sort()[0],
  }
}

/**
 * 냉장고 화면 목록: 재료명 검색과 보관 위치 필터를 적용해
 * 보관 중 그룹(합계 포함)과 소진·폐기 기록, 요약 숫자를 만든다.
 */
export function buildFridgeView({ groups, searchQuery, storageFilter }) {
  const search = searchQuery.trim().toLocaleLowerCase('ko-KR')
  const filteredGroups = groups
    .filter((group) => group.ingredientName.toLocaleLowerCase('ko-KR').includes(search))
    .map((group) => ({
      ...group,
      lots: group.lots.filter((lot) => storageFilter === ALL_STORAGE || lot.storageLocation === storageFilter),
    }))
  const visibleGroups = filteredGroups
    .map((group) => {
      const lots = group.lots.filter(isActive)
      return { ...group, lots, ...summarizeLots(lots) }
    })
    .filter((group) => group.lots.length > 0)
  const archivedGroups = filteredGroups
    .map((group) => ({ ...group, lots: group.lots.filter(isArchived) }))
    .filter((group) => group.lots.length > 0)
  const visibleActiveLots = visibleGroups.flatMap((group) => group.lots).filter(isActive)

  return {
    allLots: groups.flatMap((group) => group.lots),
    visibleGroups,
    archivedGroups,
    archivedLotCount: archivedGroups.reduce((count, group) => count + group.lots.length, 0),
    activeLotCount: visibleActiveLots.length,
    activeIngredientCount: new Set(visibleGroups.filter((group) => group.lots.some(isActive)).map((group) => group.ingredientName)).size,
    imminentCount: visibleActiveLots.filter((lot) => lot.expirationStatus === EXPIRATION_STATUS.IMMINENT || lot.expirationStatus === EXPIRATION_STATUS.TODAY).length,
    hasFilters: searchQuery !== '' || storageFilter !== ALL_STORAGE,
    hasAnyActiveLots: groups.some((group) => group.lots.some(isActive)),
  }
}

/** 재고 수정·폐기 결과 안내 */
export function lotSavedMessage(lot, disposed) {
  return disposed
    ? `${lot.ingredientName} 폐기가 처리되었습니다. 남은 수량은 ${formatQuantity(lot.quantity, lot.unit)}입니다.`
    : `${lot.ingredientName} 묶음 #${lot.id} 정보가 저장되었습니다.`
}

/** 새 묶음 입고 결과 안내 */
export function stockInMessage(lot) {
  return `${lot.ingredientName} ${formatQuantity(lot.quantity, lot.unit)}이(가) 새 묶음으로 등록되었습니다.`
}

/** 오늘 만료·기한 임박인 보관 중 묶음 수 (헤더 배지) */
export function countImminentLots(groups) {
  return groups
    .flatMap((group) => group.lots)
    .filter((lot) => isActive(lot) &&
      (lot.expirationStatus === EXPIRATION_STATUS.TODAY || lot.expirationStatus === EXPIRATION_STATUS.IMMINENT))
    .length
}
