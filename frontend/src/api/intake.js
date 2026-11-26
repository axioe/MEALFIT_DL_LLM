import { api } from '@/api/client'

// [섭취기록] 식단 섭취 기록(먹음·건너뜀) 저장·정정 및 날짜별 조회 API (FR-INT-01·02)
export const intakeApi = {
  record: (body) =>
    api.post('/intake-logs', body).then((r) => r.data),
  getByDate: (date, signal) =>
    api.get('/intake-logs', { params: date ? { date } : undefined, signal }).then((r) => r.data),
}
