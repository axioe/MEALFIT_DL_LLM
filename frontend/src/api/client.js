import axios from 'axios'
import { useAuthStore } from '@/stores/authStore'
import { queryClient } from '@/lib/queryClient'
import { withTabLock } from '@/lib/tabSession'
import { createSessionRecovery } from '@/hooks/sessionRecovery'
import { installSessionInterceptors } from '@/hooks/sessionClient'
import { SessionChangedError } from '@/models/sessionScope'

/** 모든 API는 같은 인증·쿠키·오류 처리를 사용합니다. */
export const api = axios.create({
  baseURL: '/api/v1',
  headers: {
    'Content-Type': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  },
  withCredentials: true,
  timeout: 30_000,
})

const recovery = createSessionRecovery({
  store: useAuthStore,
  client: queryClient,
  request: (path, body) => api.post(path, body),
  withLock: withTabLock,
})
installSessionInterceptors(api, useAuthStore, recovery)

export const restoreSession = recovery.restore
export const loginSession = recovery.login
export const logoutSession = recovery.logout

/** 서버 ErrorResponse의 필드 오류·메시지를 우선 표시합니다. */
export function getErrorMessage(error, fallback = '요청을 처리하지 못했습니다.') {
  if (error instanceof SessionChangedError) return error.message
  if (axios.isAxiosError(error)) {
    const data = error.response?.data
    if (data?.errors?.length) return data.errors.map((item) => item.message).join('\n')
    if (data?.message) return data.message
    if (!error.response) return '서버에 연결하지 못했습니다. 연결 상태를 확인한 뒤 다시 시도해 주세요.'
  }
  return fallback
}

export function getErrorCode(error) {
  return axios.isAxiosError(error) ? error.response?.data?.code : undefined
}
