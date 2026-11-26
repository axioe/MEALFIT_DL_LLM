const PREFIX = '@mealfit-product:v1:'

// 정확한 버전·자료형을 만족하는 구조만 해석하고 기존 메모는 그대로 반환함
export function readInventoryMemo(value) {
  const raw = typeof value === 'string' ? value : ''
  if (raw.startsWith(PREFIX)) {
    try {
      const data = JSON.parse(raw.slice(PREFIX.length))
      if (Array.isArray(data) && data.length === 2 && data.every(item => typeof item === 'string')
        && data[0].trim() && data[0].length <= 100 && raw.length <= 255) {
        return { productInfo: data[0], memo: data[1] }
      }
    } catch { /* 손상된 구조는 일반 메모로 보존함 */ }
  }
  return { productInfo: '', memo: raw }
}

// 상품 정보를 별도 항목으로 직렬화하며 사용자 메모를 삭제하거나 덮어쓰지 않음
export function writeInventoryMemo(productInfo = '', memo = '') {
  return productInfo.trim() ? PREFIX + JSON.stringify([productInfo.trim(), memo]) : memo
}

// 재고 묶음별 상품 정보만 괄호로 표시하고 집계용 식재료명은 유지함
export function inventoryProductLabel(lot) {
  const { productInfo } = readInventoryMemo(lot.memo)
  return productInfo ? `${lot.ingredientName} (${productInfo})` : lot.ingredientName
}
