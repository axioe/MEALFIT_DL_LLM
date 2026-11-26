import { readInventoryMemo, writeInventoryMemo } from './inventoryMemo.js'
import { STOCK_IN_INITIAL_FORM, validateStockInForm, buildStockInBody } from './inventoryForm.js'

// 손상된 분석 응답은 빈 성공으로 바꾸지 않음
export function readReceiptResponse(data) {
  if (!data || typeof data.modelVersion !== 'string' || !['SUCCESS', 'NO_TEXT', 'NO_ITEMS'].includes(data.status)
    || !Array.isArray(data.items) || data.items.length > 50 || (data.status === 'SUCCESS') !== (data.items.length > 0)
    || (data.purchaseDate != null && !/^\d{4}-\d{2}-\d{2}$/.test(data.purchaseDate))) throw new Error('영수증 분석 응답 형식을 확인하지 못했습니다.')
  const items = data.items.map(item => {
    if (typeof item?.productName !== 'string' || item.productName.length > 100 || typeof item.ingredientName !== 'string'
      || (item.ingredientName !== '' && !item.ingredientName.trim()) || item.ingredientName.length > 100 || item.mappingStatus !== 'UNMAPPED'
      || item.requiresConfirmation !== true || item.parsingStatus !== 'CHECK_REQUIRED'
      || !Number.isFinite(item.textConfidence) || item.textConfidence < 0 || item.textConfidence > 1) throw new Error('영수증 품목 형식을 확인하지 못했습니다.')
    return item
  })
  return { ...data, items }
}

// 서버가 제안한 수량은 확인 대상으로 두고 상품 정보와 사용자 메모를 분리함
export function receiptRow(item = {}, id = crypto.randomUUID()) {
  const stored = readInventoryMemo(item.memo)
  const productInfo = item.productName && item.productName !== item.ingredientName
    && !/^서울우유\s*딸기우유$/.test(item.productName) ? item.productName : ''
  return { ...STOCK_IN_INITIAL_FORM, ...stored, id, selected: !(Object.hasOwn(item, 'ingredientName') && !item.ingredientName.trim()), productName: productInfo || stored.productInfo,
    storageLocation: item.storageLocation ?? STOCK_IN_INITIAL_FORM.storageLocation,
    expiryDate: item.expiryDate ?? '', minStockQty: item.minStockQty == null ? '' : String(item.minStockQty),
    ingredientName: item.ingredientName ?? '', quantity: item.quantity == null ? '' : String(item.quantity),
    unit: item.unit ?? '', netQuantity: item.netQuantity == null ? '' : String(item.netQuantity), netUnit: item.netUnit ?? '',
    packageCount: item.packageCount, purchaseQuantity: item.purchaseQuantity, purchaseUnit: item.purchaseUnit,
    quantityStatus: item.quantityStatus, price: item.price, textConfidence: item.textConfidence }
}

// 모든 선택 품목을 기존 입고 규칙으로 검증하고 원문·가격·구매일은 저장 요청에서 제외함
export function buildReceiptBatch(rows, clientRequestId) {
  const selected = rows.filter(row => row.selected)
  if (!selected.length || selected.length > 50) throw new Error('등록할 품목을 1~50개 선택해 주세요.')
  for (const row of selected) {
    if (row.productName.length > 100) throw new Error('추가 상품 정보는 100자 이내로 입력해 주세요.')
    const errors = validateStockInForm({ ...row, memo: writeInventoryMemo(row.productName, row.memo) })
    if (Object.keys(errors).length) throw new Error(`${row.ingredientName || '새 품목'}: ${Object.values(errors)[0]}`)
  }
  return { clientRequestId, items: selected.map(row => buildStockInBody({ ...row, memo: writeInventoryMemo(row.productName, row.memo) })) }
}
