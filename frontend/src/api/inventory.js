import { api } from '@/api/client'

export const inventoryApi = {
  getLots: () => api.get('/inventory/lots').then((response) => response.data),
  getTransactions: (lotId) => api.get('/inventory/transactions', { params: lotId == null ? {} : { lotId } }).then((response) => response.data),
  updateLot: ({ id, body }) => api.patch(`/inventory/lots/${id}`, body).then((response) => response.data),
  stockIn: (body) => api.post('/inventory/lots', body).then((response) => response.data),
}
