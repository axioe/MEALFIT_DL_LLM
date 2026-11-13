/** 완료한 운동 기록 수 */
export function countCompletedDays(logs) {
  return logs.filter((log) => log.completed).length
}

/** 이번 주 운동 진행률(%): 완료한 날 ÷ 운동일(휴식일 제외), 최대 100 */
export function weeklyProgress(routine, logs) {
  const completedDays = countCompletedDays(logs)
  const exerciseDays = routine.filter((day) => !day.isRestDay).length || 1
  return Math.min(100, Math.round((completedDays / exerciseDays) * 100))
}

/** 월요일 = 0 인 요일 번호 */
export function mondayBasedDayIndex(date = new Date()) {
  return (date.getDay() + 6) % 7
}
