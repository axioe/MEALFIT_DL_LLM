/**
 * 여러 브라우저 탭이 같은 로그인 정보(localStorage)를 쓸 때 토큰 재발급을 조율한다.
 *
 * Refresh Token은 한 번 쓰면 폐기되고, 폐기된 토큰을 다시 쓰면 서버가 그 회원의 토큰을 모두 폐기한다.
 * 탭마다 메모리에 남은 옛 토큰으로 각자 재발급하면 두 번째 탭이 "재사용"으로 판정돼 모든 탭이 로그아웃된다.
 * 그래서 재발급은 한 번에 한 탭만 하고(잠금), 잠금을 얻으면 저장소의 최신 값을 먼저 확인한다.
 */

export const AUTH_STORAGE_KEY = 'mealfit-auth'
export const REFRESH_LOCK_NAME = 'mealfit-auth-refresh'

/** zustand persist 형식({ state, version })으로 저장된 로그인 정보를 읽는다. 없거나 깨졌으면 null */
export function readPersistedSession(storage, key = AUTH_STORAGE_KEY) {
  try {
    const raw = storage?.getItem(key)
    if (!raw) return null
    const state = JSON.parse(raw)?.state
    return state && typeof state === 'object' ? state : null
  } catch {
    return null
  }
}

/** 브라우저가 Web Locks를 지원하면 탭 사이 잠금, 아니면 그대로 실행한다. */
export function withTabLock(fn, name = REFRESH_LOCK_NAME, locks = globalThis.navigator?.locks) {
  return locks?.request ? locks.request(name, fn) : fn()
}

export class LoggedOutError extends Error {
  constructor() {
    super('로그인이 필요합니다.')
    this.name = 'LoggedOutError'
  }
}

/**
 * 잠금 안에서 최신 저장값을 확인한 뒤 필요할 때만 재발급한다.
 * apply(session)도 잠금 안에서 호출해, 다음 탭이 잠금을 얻을 때는 이미 새 토큰이 저장돼 있게 한다.
 *
 * @param originalRefreshToken 401을 받을 때 이 탭이 들고 있던 Refresh Token
 * @param readLatest  저장소의 최신 로그인 정보를 읽는다
 * @param refresh     (refreshToken) => 새 로그인 정보 (서버 호출)
 * @param apply       (session) => void  이 탭의 store에 반영 (persist로 저장소에도 기록)
 * @param withLock    (fn) => fn의 결과  탭 사이 잠금
 * @returns {{ session, refreshed: boolean }}
 */
export function coordinateRefresh({ originalRefreshToken, readLatest, refresh, apply, withLock = withTabLock }) {
  return withLock(async () => {
    const latest = readLatest()
    if (!latest?.refreshToken) {
      throw new LoggedOutError() // 다른 탭에서 로그아웃했다
    }
    if (latest.refreshToken !== originalRefreshToken) {
      // 다른 탭이 이미 재발급했다. 옛 토큰으로 다시 요청하면 재사용으로 판정되므로 새 값을 그대로 쓴다
      apply(latest)
      return { session: latest, refreshed: false }
    }
    const session = await refresh(originalRefreshToken)
    apply(session)
    return { session, refreshed: true }
  })
}
