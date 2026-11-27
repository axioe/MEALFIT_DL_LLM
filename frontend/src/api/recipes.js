import { api } from '@/api/client'

export const recipesApi = {
  getPublicCatalog: (page, signal) => api.get('/recipes/public', { params: { page }, signal }).then(r => r.data),
  getPublicDetail: (id, servings, signal) => api.get(`/recipes/public/${id}`, { params: { servings }, signal }).then(r => r.data),
  getDetail: (id, servings, signal) => api.get(`/recipes/${id}`, { params: { servings }, signal }).then((r) => r.data),
}
