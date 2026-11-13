import { STORAGE_LOCATION } from '../lib/enums.js'

// ---------- 새 묶음 입고 (StockInDialog) ----------

export const STOCK_IN_UNITS = ['개', 'g', 'kg', 'mL', 'L', '모', '쪽', '봉지', '팩', '마리']
export const STOCK_IN_INITIAL_FORM = {
  ingredientName: '', quantity: '', unit: '개', storageLocation: STORAGE_LOCATION.FRIDGE,
  expiryDate: '', minStockQty: '', memo: '',
}

export function validateStockInForm(form) {
  const errors = {}
  if (!form.ingredientName.trim()) errors.ingredientName = '식재료명을 입력해 주세요.'
  else if (form.ingredientName.trim().length > 100) errors.ingredientName = '식재료명은 100자 이내로 입력해 주세요.'
  for (const field of ['quantity', 'minStockQty']) {
    const text = form[field].trim()
    if (field === 'minStockQty' && text === '') continue
    if (!text || !/^(?:\d+(?:\.\d{1,3})?|\.\d{1,3})$/.test(text)
        || !Number.isFinite(Number(text)) || Number(text) > 999999999.999
        || (field === 'quantity' && Number(text) <= 0)) {
      errors[field] = field === 'quantity'
        ? '0보다 큰 수량을 정수 9자리, 소수 3자리 이내로 입력해 주세요.'
        : '최소 유지 수량은 0 이상, 정수 9자리, 소수 3자리 이내로 입력해 주세요.'
    }
  }
  if (!STOCK_IN_UNITS.includes(form.unit)) errors.unit = '단위를 선택해 주세요.'
  if (!Object.values(STORAGE_LOCATION).includes(form.storageLocation)) errors.storageLocation = '보관 위치를 선택해 주세요.'
  if (form.expiryDate) {
    const date = new Date(form.expiryDate + 'T00:00:00Z')
    if (!/^\d{4}-\d{2}-\d{2}$/.test(form.expiryDate) || Number.isNaN(date.getTime())
        || date.toISOString().slice(0, 10) !== form.expiryDate) errors.expiryDate = '올바른 소비기한 날짜를 입력해 주세요.'
  }
  if (form.memo.length > 255) errors.memo = '메모는 255자 이내로 입력해 주세요.'
  return errors
}

/** 입고 요청 본문: 비어 있는 선택 항목은 보내지 않는다 */
export function buildStockInBody(form) {
  return {
    ingredientName: form.ingredientName.trim(),
    quantity: Number(form.quantity),
    unit: form.unit,
    storageLocation: form.storageLocation,
    ...(form.expiryDate && { expiryDate: form.expiryDate }),
    ...(form.minStockQty.trim() !== '' && { minStockQty: Number(form.minStockQty) }),
    ...(form.memo !== '' && { memo: form.memo }),
  }
}

// ---------- 묶음 수정·폐기 (InventoryLotDialog) ----------

/** 정수 9자리·소수 3자리 이내의 0 이상(positive면 0 초과) 수량인지 */
export function isValidQuantity(text, positive = false) {
  return /^(?:\d+(?:\.\d{1,3})?|\.\d{1,3})$/.test(text.trim())
    && Number.isFinite(Number(text)) && Number(text) <= 999999999.999
    && (positive ? Number(text) > 0 : Number(text) >= 0)
}

/** 원래 묶음과 달라진 항목만 담은 수정 요청 본문 (기한을 비우면 clearExpiryDate) */
export function buildLotAdjustBody(form, lot) {
  const body = {}
  if (Number(form.quantity) !== Number(lot.quantity)) body.quantity = Number(form.quantity)
  if (form.storageLocation !== lot.storageLocation) body.storageLocation = form.storageLocation
  if (form.expiryDate !== (lot.expiryDate ?? '')) {
    if (form.expiryDate) body.expiryDate = form.expiryDate
    else body.clearExpiryDate = true
  }
  if (Number(form.minStockQty) !== Number(lot.minStockQty)) body.minStockQty = Number(form.minStockQty)
  if (form.memo !== (lot.memo ?? '')) body.memo = form.memo
  return body
}
