import { api } from '@/api/client'

export const allergensApi = {
  catalog: (signal) => api.get('/allergens', { signal }).then((r) => r.data),
  search: (q, signal) => api.get('/allergens/search', { params: { q }, signal }).then((r) => r.data),
  mine: (signal) => api.get('/me/allergies', { signal }).then((r) => r.data),
  replace: (body) => api.put('/me/allergies', body).then((r) => r.data),
  checkRecipe: (id, signal) => api.get(`/recipes/${id}/allergen-check`, { signal }).then((r) => r.data),
}
