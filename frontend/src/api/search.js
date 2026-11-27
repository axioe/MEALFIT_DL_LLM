import { api } from '@/api/client'

export function searchWeb({ q, type, limit, offset, guest = false }, signal) {
  return api.get(guest ? '/search/public' : '/search', {
    params: { q, types: type, limit, offset },
    signal,
  }).then(response => response.data)
}
