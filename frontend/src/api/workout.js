import { api } from '@/api/client'

// [문장조정] 운동 루틴 추천·조회·문장 키워드 해석 조정 API (FR-WORK-01·02)
export const workoutApi = {
  recommend: (body = {}) =>
    api.post('/workout-routines/recommend', body).then((r) => r.data),
  getCurrent: (week, signal) =>
    api.get('/workout-routines/current', { params: week ? { week } : undefined, signal }).then((r) => r.data),
  adjustSession: (routineId, sessionDate, prompt) =>
    api.patch(`/workout-routines/${routineId}/sessions/${sessionDate}`, { prompt }).then((r) => r.data),
  // [운동기록] 운동 완료 기록 저장·정정, 기간 조회, 주간 현황 집계 (FR-WORK-03·04)
  recordLog: (body) =>
    api.post('/workout-logs', body).then((r) => r.data),
  getLogs: (params, signal) =>
    api.get('/workout-logs', { params, signal }).then((r) => r.data),
  getWeeklySummary: (week, signal) =>
    api.get('/workout-logs/summary', { params: week ? { week } : undefined, signal }).then((r) => r.data),
}
