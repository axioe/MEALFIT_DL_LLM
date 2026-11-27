import { intakeApi } from '@/api/intake'
import { api } from '@/api/client'
import { dashboardMock } from '@/api/mocks/dashboardMock'

// 체중·코칭의 예시 데이터는 홈의 별도 미리보기에서만 사용한다.
export const dashboardApi = {
  recordIntake: intakeApi.record,
  getProfile: () => api.get('/me/profile').then((r) => r.data),
  getTodayWorkout: (date) => dashboardMock.getTodayWorkout(date),
  setWorkoutCompleted: (body) => dashboardMock.setWorkoutCompleted(body),
  getWeightSummary: () => dashboardMock.getWeightSummary(),
  getCoaching: () => dashboardMock.getCoaching(),
  checkCondition: (condition) => dashboardMock.checkCondition(condition),
}
