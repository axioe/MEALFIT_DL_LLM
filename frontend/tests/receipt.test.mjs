import { readInventoryMemo, writeInventoryMemo, inventoryProductLabel } from '../src/models/inventoryMemo.js'
import { buildLotAdjustBody } from '../src/models/inventoryForm.js'
import test from 'node:test'
import assert from 'node:assert/strict'
import { readReceiptResponse, receiptRow, buildReceiptBatch } from '../src/models/receipt.js'

const item = { productName: '국내산 당근', ingredientName: '당근', quantity: null, unit: null,
  mappingStatus: 'UNMAPPED', requiresConfirmation: true, parsingStatus: 'CHECK_REQUIRED', textConfidence: .98 }

test('영수증 후보는 수량을 추정하지 않고 수정을 허용함', () => {
  const row = receiptRow(item, 'row1')
  assert.equal(row.quantity, '')
  assert.equal(row.unit, '')
  assert.throws(() => buildReceiptBatch([row], 'key'))
  row.quantity = '2'; row.unit = '개'; row.ingredientName = '수정한 당근'
  const result = buildReceiptBatch([row], 'key')
  assert.equal(result.items[0].ingredientName, '수정한 당근')
  assert.equal(result.items[0].quantity, 2)
  assert.equal(result.items[0].productName, undefined)
})

test('제외한 품목은 검증 및 저장하지 않음', () => {
  const selected = receiptRow({ ...item, quantity: '1', unit: '개' })
  assert.equal(buildReceiptBatch([selected, { ...receiptRow(), selected: false }], 'key').items.length, 1)
  assert.throws(() => buildReceiptBatch([], 'key'))
})

test('중량과 포장 수량은 자동 환산하지 않음', () => {
  const row = receiptRow({ ...item, quantity: '2', unit: '팩', netQuantity: '500', netUnit: 'g' })
  const result = buildReceiptBatch([row], 'key')
  assert.equal(result.items[0].quantity, 2)
  assert.equal(result.items[0].unit, '팩')
  assert.equal(result.items[0].netQuantity, undefined)
})

test('0·음수·범위·정밀도 오류를 차단함', () => {
  for (const quantity of ['0', '-1', '1.0001', '1000000000']) {
    assert.throws(() => buildReceiptBatch([receiptRow({ ...item, quantity, unit: '개' })], 'key'))
  }
})

test('잘못된 응답과 자동 확정 후보를 거부함', () => {
  const result = { modelVersion: 'receipt-test', status: 'SUCCESS', items: [item] }
  assert.equal(readReceiptResponse(result).items.length, 1)
  assert.throws(() => readReceiptResponse({ ...result, items: [{...item, requiresConfirmation:false}] }))
  assert.throws(() => readReceiptResponse({ ...result, items: [] }))
})

test('최종 확정 본문은 같은 키로 재시도할 수 있음', () => {
  const body = buildReceiptBatch([receiptRow({ ...item, quantity: '1', unit: '개' })], 'same-key')
  assert.deepEqual(JSON.parse(JSON.stringify(body)), body)
})

test('상품 정보와 사용자 메모를 모두 보존하고 표준 이름은 집계에 유지함', () => {
  const row = receiptRow({ ...item, quantity: '10', unit: '개' })
  row.productName = '불닭볶음면 치즈맛'; row.ingredientName = '라면'; row.memo = '사용자가 적은 메모'
  row.storageLocation = 'PANTRY'; row.expiryDate = '2027-01-01'
  const saved = buildReceiptBatch([row], 'key').items[0]
  assert.equal(saved.ingredientName, '라면')
  assert.equal(saved.quantity, 10)
  assert.equal(saved.storageLocation, 'PANTRY')
  assert.deepEqual(readInventoryMemo(saved.memo), { productInfo: row.productName, memo: row.memo })
  assert.equal(inventoryProductLabel(saved), '라면 (불닭볶음면 치즈맛)')
  assert.equal(receiptRow(saved).productName, row.productName)
  assert.equal(receiptRow(saved).memo, row.memo)
})

test('기존 영어명·일반 메모·손상된 구조를 상품명으로 오인하지 않음', () => {
  for (const memo of ['원래 메모', '@mealfit-product:v1:bad', '@mealfit-product:v1:[1,2]']) {
    assert.deepEqual(readInventoryMemo(memo), { productInfo: '', memo })
    assert.equal(inventoryProductLabel({ ingredientName: 'tomato', memo }), 'tomato')
  }
})

test('구조화 메모 수정 시 상품 정보를 유지하고 길이 초과를 차단함', () => {
  const memo = writeInventoryMemo('신라면', '기존 메모')
  const lot = { quantity: 5, storageLocation: 'PANTRY', expiryDate: null, minStockQty: 0, memo }
  const form = { quantity: '5', storageLocation: 'PANTRY', expiryDate: '', minStockQty: '0', productInfo: '신라면', memo: '바꾼 메모' }
  assert.deepEqual(readInventoryMemo(buildLotAdjustBody(form, lot).memo), { productInfo: '신라면', memo: '바꾼 메모' })
  assert.equal(buildLotAdjustBody({ ...form, memo: '기존 메모' }, lot).memo, undefined)
  const row = receiptRow({ ...item, quantity: '1', unit: '개' })
  row.productName = '가'.repeat(100); row.memo = '나'.repeat(200)
  assert.throws(() => buildReceiptBatch([row], 'key'), /255/)
})

test('재시도 화면의 위치·기한·최소 유지량은 확정 본문과 일치함', () => {
  const source = { ...item, quantity: 5, unit: '개', storageLocation: 'PANTRY', expiryDate: '2027-01-01', minStockQty: 2 }
  const row = receiptRow(source)
  assert.equal(row.storageLocation, 'PANTRY')
  assert.equal(row.expiryDate, '2027-01-01')
  assert.equal(row.minStockQty, '2')
})

test('표준명 미확인 후보는 기본 제외하고 이름을 입력해야 입고함', () => {
  const response = { modelVersion: 'receipt-test', status: 'SUCCESS', items: [{ ...item, ingredientName: '', productName: '마트자체상품', quantity: '2', unit: '개' }] }
  const row = receiptRow(readReceiptResponse(response).items[0])
  assert.equal(row.selected, false)
  assert.throws(() => buildReceiptBatch([row], 'key'))
  row.selected = true
  assert.throws(() => buildReceiptBatch([row], 'key'))
  row.ingredientName = '라면'
  assert.equal(buildReceiptBatch([row], 'key').items[0].ingredientName, '라면')
})
