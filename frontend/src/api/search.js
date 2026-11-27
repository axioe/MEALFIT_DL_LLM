import { api } from '@/api/client'

export function searchWeb({ q, type, limit, offset }, signal) {
  return api.get('/search', {
    params: { q, types: type, limit, offset },
    signal,
  }).then(response => response.data)
}
