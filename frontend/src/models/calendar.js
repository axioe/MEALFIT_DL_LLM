import { toLocalDateString } from '../lib/date.js'

/**
 * 달력 한 달 칸: 앞쪽 이전 달 날짜 + 이번 달 + 뒤쪽 다음 달 날짜(주 단위로 채움).
 * 날짜 문자열은 한국 시간 기준 'YYYY-MM-DD' (toISOString 은 UTC라 하루씩 밀린다)
 */
export function buildMonthGrid(currentMonth) {
  const year = currentMonth.getFullYear()
  const month = currentMonth.getMonth()
  const firstDayOfMonth = new Date(year, month, 1).getDay() // 0 = 일요일
  const daysInMonth = new Date(year, month + 1, 0).getDate()
  const days = []
  const prevMonthDays = new Date(year, month, 0).getDate()
  for (let i = firstDayOfMonth - 1; i >= 0; i--) {
    const d = prevMonthDays - i
    days.push({ dateStr: toLocalDateString(new Date(year, month - 1, d)), dayNum: d, isCurrentMonth: false })
  }
  for (let d = 1; d <= daysInMonth; d++) {
    days.push({ dateStr: toLocalDateString(new Date(year, month, d)), dayNum: d, isCurrentMonth: true })
  }
  const remaining = (7 - (days.length % 7)) % 7
  for (let d = 1; d <= remaining; d++) {
    days.push({ dateStr: toLocalDateString(new Date(year, month + 1, d)), dayNum: d, isCurrentMonth: false })
  }
  return days
}

/** 이전·다음 달의 1일 */
export function shiftMonth(currentMonth, delta) {
  return new Date(currentMonth.getFullYear(), currentMonth.getMonth() + delta, 1)
}
