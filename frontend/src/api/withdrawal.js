import { api } from '@/api/client'

const reauthenticationPath = '/me/withdrawal/reauthentication'

export const withdrawalApi = {
  start: (provider) => api.post(reauthenticationPath, { provider }),
  status: () => api.get(reauthenticationPath).then((response) => response.data),
  cancel: () => api.delete(reauthenticationPath),
}
