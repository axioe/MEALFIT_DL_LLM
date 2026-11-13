import test from 'node:test'
import assert from 'node:assert/strict'
import { ALL_STORAGE, buildFridgeView, describeGroup, lotSavedMessage, stockInMessage, summarizeLots } from '../src/models/fridge.js'

const lot = (id, quantity, extra = {}) => ({ id, quantity, unit: 'g', status: 'ACTIVE', expirationStatus: 'NORMAL', storageLocation: 'FRIDGE', expiryDate: null, ...extra })

test('보관 중 묶음만 합산하고 기한 경과량은 사용 가능량에서 뺀다 (소수 셋째 자리 정확)', () => {
  const result = summarizeLots([lot(1, '0.1'), lot(2, '0.2', { expirationStatus: 'EXPIRED' }), lot(3, '5', { status: 'DISPOSED' })])
  assert.deepEqual(result, { totalQuantity: 0.3, availableQuantity: 0.1, expiredQuantity: 0.2 })
})

test('그룹 요약: 가장 급한 기한 상태와 가장 빠른 기한을 고른다', () => {
  const group = { lots: [
    lot(1, '1', { expirationStatus: 'IMMINENT', expiryDate: '2026-11-15' }),
    lot(2, '1', { expirationStatus: 'EXPIRED', expiryDate: '2026-11-10' }),
    lot(3, '1', { status: 'DEPLETED', expiryDate: '2026-11-01' }),
  ] }
  const result = describeGroup(group)
  assert.equal(result.activeLots.length, 2)
  assert.deepEqual(result.usableLots.map((l) => l.id), [1])
  assert.deepEqual(result.expiredLots.map((l) => l.id), [2])
  assert.equal(result.worstStatus, 'EXPIRED')
  assert.equal(result.earliestExpiry, '2026-11-10')
})

test('검색어·보관 위치로 거르고 보관 중 그룹과 소진·폐기 기록을 나눈다', () => {
  const groups = [
    { ingredientName: '두부', unit: '모', lots: [lot(1, '1'), lot(2, '1', { storageLocation: 'FREEZER', expirationStatus: 'TODAY' }), lot(3, '1', { status: 'DISPOSED' })] },
    { ingredientName: '양파', unit: '개', lots: [lot(4, '2', { expirationStatus: 'IMMINENT' })] },
  ]
  const all = buildFridgeView({ groups, searchQuery: '', storageFilter: ALL_STORAGE })
  assert.equal(all.visibleGroups.length, 2)
  assert.equal(all.activeLotCount, 3)
  assert.equal(all.activeIngredientCount, 2)
  assert.equal(all.imminentCount, 2)
  assert.equal(all.archivedLotCount, 1)
  assert.equal(all.hasFilters, false)
  assert.equal(all.allLots.length, 4)

  const frozenTofu = buildFridgeView({ groups, searchQuery: ' 두부 ', storageFilter: 'FREEZER' })
  assert.deepEqual(frozenTofu.visibleGroups.map((g) => g.lots.map((l) => l.id)), [[2]])
  assert.equal(frozenTofu.archivedLotCount, 0)
  assert.equal(frozenTofu.hasFilters, true)
  assert.equal(frozenTofu.hasAnyActiveLots, true)
})

test('안내 문구는 수량과 단위를 붙여 쓴다', () => {
  assert.equal(stockInMessage({ ingredientName: '우유', quantity: '1.500', unit: 'L' }), '우유 1.5L이(가) 새 묶음으로 등록되었습니다.')
  assert.equal(lotSavedMessage({ ingredientName: '두부', quantity: '0', unit: '모', id: 3 }, true), '두부 폐기가 처리되었습니다. 남은 수량은 0모입니다.')
  assert.equal(lotSavedMessage({ ingredientName: '두부', id: 3 }, false), '두부 묶음 #3 정보가 저장되었습니다.')
})
