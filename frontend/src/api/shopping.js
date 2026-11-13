import { api } from '@/api/client'

export const shoppingApi = {
  getItems: () => api.get('/shopping-items').then((r) => r.data),
  purchase: (body) => api.patch('/shopping-items', body).then((r) => r.data),
  stockIn: (body) => api.post('/shopping-items/stock-in', body).then((r) => r.data),
}
