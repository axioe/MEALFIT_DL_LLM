import { assertCurrentSession, captureSession } from '../models/sessionScope.js'

const AUTH_PATHS = new Set([
  '/auth/signup', '/auth/login', '/auth/refresh', '/auth/logout',
  '/auth/email-verification/confirm', '/auth/email-verification/resend',
])
const isAuthRequest = (config) => AUTH_PATHS.has(config.url?.split('?')[0])

/** 실제 요청과 응답을 검사해 오래된 조회·저장 결과를 호출자에게 전달하지 않습니다. */
export function installSessionInterceptors(api, store, recovery) {
  api.interceptors.request.use((config) => {
    const state = store.getState()
    if (!isAuthRequest(config)) {
      config._authSession ??= captureSession(state)
      assertCurrentSession(config._authSession, state)
    }
    if (!isAuthRequest(config) && state.accessToken) {
      config.headers.set('Authorization', `Bearer ${state.accessToken}`)
      config._authAccessToken = state.accessToken
    } else {
      config.headers.delete('Authorization')
      config._authAccessToken = null
    }
    return config
  })

  api.interceptors.response.use(
    (response) => {
      if (response.config._authSession) assertCurrentSession(response.config._authSession, store.getState())
      return response
    },
    async (error) => {
      const config = error.config
      if (config?._authSession) assertCurrentSession(config._authSession, store.getState())
      if (!config || error.response?.status !== 401 || isAuthRequest(config)) throw error

      const current = store.getState()
      if (config._authRetried) {
        if (current.accessToken === config._authAccessToken) recovery.clear()
        throw error
      }
      config._authRetried = true

      if (!current.accessToken || current.accessToken === config._authAccessToken) await recovery.refresh()
      assertCurrentSession(config._authSession, store.getState())
      return api(config)
    },
  )
}
