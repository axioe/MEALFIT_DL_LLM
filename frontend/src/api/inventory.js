import { api } from '@/api/client'
import { readRecognitionResponse } from '../models/ingredientRecognition.js'

export const inventoryApi = {
  // 기존 인증 클라이언트로 이미지만 보내고 multipart 경계값은 브라우저에 맡김.
  recognizePhoto: async ({ image, signal }) => {
    const form = new FormData()
    form.append('image', image)
    const response = await api.post('/inventory/recognitions/photo', form, { signal, headers: { 'Content-Type': undefined } })
    return readRecognitionResponse(response.data)
  },
  getLots: () => api.get('/inventory/lots').then((response) => response.data),
  getTransactions: (lotId) => api.get('/inventory/transactions', { params: lotId == null ? {} : { lotId } }).then((response) => response.data),
  updateLot: ({ id, body }) => api.patch(`/inventory/lots/${id}`, body).then((response) => response.data),
  stockIn: (body) => api.post('/inventory/lots', body).then((response) => response.data),
}
