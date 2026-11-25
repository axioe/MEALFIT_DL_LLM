import { api } from '@/api/client'

// [문장조정] 운동 루틴 추천·조회·문장 키워드 해석 조정 API (FR-WORK-01·02)
export const workoutApi = {
  recommend: (body = {}) =>
    api.post('/workout-routines/recommend', body).then((r) => r.data),
  getCurrent: (week, signal) =>
    api.get('/workout-routines/current', { params: week ? { week } : undefined, signal }).then((r) => r.data),
  adjustSession: (routineId, sessionDate, prompt) =>
    api.patch(`/workout-routines/${routineId}/sessions/${sessionDate}`, { prompt }).then((r) => r.data),
}
