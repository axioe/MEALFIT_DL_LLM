import { api } from '@/api/client'

// [자세판별] 운동 자세 판별 API (FR-WORK-05). 관절 좌표만 보내며 영상·이미지는 보내지 않는다 (NFR-SEC-05).
export const poseApi = {
  getExercises: (signal) => api.get('/workout/pose-exercises', { signal }).then((r) => r.data),
  analyze: ({ body, signal }) => api.post('/workout/pose-analyses', body, { signal }).then((r) => r.data),
}
