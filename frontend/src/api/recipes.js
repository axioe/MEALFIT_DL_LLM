import { api } from '@/api/client'

export const recipesApi = {
  getDetail: (id, servings, signal) => api.get(`/recipes/${id}`, { params: { servings }, signal }).then((r) => r.data),
}
