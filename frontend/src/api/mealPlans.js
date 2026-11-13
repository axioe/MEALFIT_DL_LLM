import { api } from '@/api/client'

export const mealPlansApi = {
  getByDate: (date, signal) => api.get('/meal-plans', { params: { date }, signal }).then((r) => r.data),
  recommend: (body) => api.post('/meal-plans/recommend', body).then((r) => r.data),
  regenerate: (id) => api.post(`/meal-plans/${id}/regenerate`).then((r) => r.data),
  confirm: (id) => api.post(`/meal-plans/${id}/confirm`).then((r) => r.data),
  cancel: (id) => api.post(`/meal-plans/${id}/cancel`).then((r) => r.data),
}
