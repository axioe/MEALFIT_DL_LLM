import { assertCurrentSession, captureSession, isCurrentSession, SessionChangedError } from '../models/sessionScope.js'

/** Refresh 쿠키를 바꾸는 요청은 로그인·로그아웃까지 같은 잠금으로 직렬화합니다. */
export function createSessionRecovery({ store, client, request, withLock }) {
  let refreshFlight = null
  let cookieQueue = Promise.resolve()

  function serializeCookieRequest(operation) {
    const next = cookieQueue.then(() => withLock(operation))
    cookieQueue = next.catch(() => {})
    return next
  }

  function clearCache() {
    void client.cancelQueries().catch(() => {})
    client.clear()
  }

  function clearSession() {
    store.getState().clear()
    clearCache()
  }

  function refresh(bootstrap) {
    const state = store.getState()
    const scope = captureSession(state)
    if (refreshFlight && isCurrentSession(refreshFlight.scope, state)) return refreshFlight.promise
    if (bootstrap && state.accessToken) {
      state.markBootstrapped()
      return Promise.resolve(state.accessToken)
    }
    if (bootstrap) state.startRestore()

    const flight = { scope }
    flight.promise = Promise.resolve()
      .then(() => serializeCookieRequest(async () => {
        assertCurrentSession(scope, store.getState())
        const { data } = await request('/auth/refresh')
        assertCurrentSession(scope, store.getState())
        // 다른 탭이 다른 계정으로 로그인했더라도 기존 계정의 캐시를 이어받지 않습니다.
        if (scope.userId !== null && scope.userId !== data.user?.id) throw new SessionChangedError()
        if (bootstrap) {
          clearCache()
          store.getState().setSession(data)
        } else {
          store.getState().updateSession(data)
        }
        return data.accessToken
      }))
      .catch((error) => {
        assertCurrentSession(scope, store.getState())
        if (error.response?.status === 401) {
          clearSession()
          if (bootstrap) return null
        } else if (bootstrap) {
          store.getState().failRestore(error)
        }
        throw error
      })
      .finally(() => {
        if (refreshFlight === flight) refreshFlight = null
      })
    refreshFlight = flight
    return flight.promise
  }

  return {
    restore: () => refresh(true),
    refresh: () => refresh(false),
    clear: clearSession,
    async login(body) {
      clearSession()
      const scope = captureSession(store.getState())
      return serializeCookieRequest(async () => {
        assertCurrentSession(scope, store.getState())
        const { data } = await request('/auth/login', body)
        assertCurrentSession(scope, store.getState())
        store.getState().setSession(data)
        return data
      })
    },
    async logout() {
      // 사용자가 요청한 로그아웃은 통신 결과를 기다리지 않고 로컬 세션부터 종료합니다.
      clearSession()
      const scope = captureSession(store.getState())
      return serializeCookieRequest(async () => {
        assertCurrentSession(scope, store.getState())
        await request('/auth/logout')
        assertCurrentSession(scope, store.getState())
      })
    },
  }
}
