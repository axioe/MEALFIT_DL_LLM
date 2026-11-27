import { api } from '@/api/client'
import { readReceiptResponse } from '../models/receipt.js'

// 기존 인증 클라이언트로만 영수증을 전송하고 사진·원문은 저장하지 않음
export async function recognizeReceipt({ image, signal }) {
  const form = new FormData()
  form.append('image', image)
  const response = await api.post('/inventory/recognitions/receipt', form,
    { signal, headers: { 'Content-Type': undefined } })
  return readReceiptResponse(response.data)
}

// 확정한 재고 필드와 재시도에도 동일한 요청 키만 전달함
export async function stockInReceipt(body) {
  const response = await api.post('/inventory/lots/batch', body)
  if (response.data?.clientRequestId !== body.clientRequestId || !Array.isArray(response.data?.lots)
    || response.data.lots.length !== body.items.length || response.data.lots.some(lot => !Number.isSafeInteger(lot.id) || lot.id <= 0)) {
    throw new Error('저장 응답을 확인하지 못했습니다. 같은 요청으로 다시 확인해 주세요.')
  }
  return response.data
}
