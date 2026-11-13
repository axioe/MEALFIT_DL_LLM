import test from 'node:test'
import assert from 'node:assert/strict'
import { buildDashboard, pickExpiringLots } from '../src/models/dashboard.js'

const lot = (id, expirationStatus, expiryDate, status = 'ACTIVE') => ({ id, ingredientName: `재료${id}`, expirationStatus, expiryDate, status })

test('보관 중인 재고 중 기한 경과·오늘·임박만 급한 순서와 날짜순으로 고른다', () => {
  const inventory = { groups: [
    { lots: [lot(1, 'IMMINENT', '2026-11-15'), lot(2, 'NORMAL', '2026-12-01'), lot(3, 'EXPIRED', '2026-11-10')] },
    { lots: [lot(4, 'TODAY', '2026-11-13'), lot(5, 'IMMINENT', '2026-11-14'), lot(6, 'EXPIRED', '2026-11-01', 'DISPOSED')] },
  ] }
  assert.deepEqual(pickExpiringLots(inventory).map((l) => l.id), [3, 4, 5, 1])
})

test('기한 미등록·정상 재고만 있으면 빈 목록이다', () => {
  assert.deepEqual(pickExpiringLots({ groups: [{ lots: [lot(1, 'UNKNOWN', null), lot(2, 'NORMAL', '2026-12-01')] }] }), [])
})

test('대시보드 응답은 구매 완료가 아닌 장보기 항목만 부족분으로 담는다', () => {
  const result = buildDashboard({
    date: '2026-11-13',
    meals: [{ id: 1 }],
    inventory: { groups: [{ lots: [lot(1, 'TODAY', '2026-11-13')] }] },
    shoppingItems: [{ id: 1, status: 'NEEDED' }, { id: 2, status: 'PARTIAL' }, { id: 3, status: 'PURCHASED' }],
  })
  assert.equal(result.date, '2026-11-13')
  assert.deepEqual(result.meals, [{ id: 1 }])
  assert.deepEqual(result.expiringLots.map((l) => l.id), [1])
  assert.deepEqual(result.shortages.map((s) => s.id), [1, 2])
})
