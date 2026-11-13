const quantityFormatter = new Intl.NumberFormat('ko-KR', { maximumFractionDigits: 3 })

/** 숫자와 단위를 붙여 쓴다. (200, 'g') → '200g', ('1.500', 'L') → '1.5L' */
export function formatQuantity(quantity, unit) {
  return `${quantityFormatter.format(Number(quantity))}${unit}`
}

/** 숫자만 소수 셋째 자리까지 (예: 이력의 증감량) */
export function formatNumber(value) {
  return quantityFormatter.format(value)
}

const kstDateTimeFormatter = new Intl.DateTimeFormat('ko-KR', {
  timeZone: 'Asia/Seoul', year: 'numeric', month: '2-digit', day: '2-digit',
  hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: false,
})

/** 서버 시각을 한국 시간으로 표시한다. 시간대 표기가 없으면 서버 기준(+09:00)으로 본다 */
export function formatDateTimeKst(value) {
  if (!value) return '날짜 정보 없음'
  const zoned = /(?:Z|[+-]\d{2}:\d{2})$/.test(value) ? value : value + '+09:00'
  const date = new Date(zoned)
  return Number.isNaN(date.getTime()) ? value : kstDateTimeFormatter.format(date)
}
