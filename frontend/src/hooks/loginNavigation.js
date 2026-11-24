import { buildLoginBody } from '../models/authForm.js'
import { loginDestination, readLoginReturnIntent } from '../models/loginNavigation.js'

const RETURN_KEY = 'mealfit-login-return'
const REPLACE_LOGIN = { replace: true, state: null }

/** OAuth 왕복에 필요한 화면 주소만 탭에 보관합니다. 인증 정보는 저장하지 않습니다. */
export function createLoginReturnStore({ getStorage, now = Date.now }) {
  function clear() {
    try { getStorage().removeItem(RETURN_KEY) } catch { /* 저장소 제한 시 기본 이동을 유지합니다. */ }
  }
  function peek() {
    try { return readLoginReturnIntent(getStorage().getItem(RETURN_KEY), now()) } catch { return null }
  }
  return {
    clear,
    peek,
    save(path) {
      clear()
      try {
        getStorage().setItem(RETURN_KEY, JSON.stringify({ path: loginDestination(path), createdAt: now() }))
      } catch { /* 저장소 제한 시 기존 소셜 로그인 목적지인 대시보드로 이동합니다. */ }
    },
    take() {
      const path = peek()
      clear()
      return path
    },
  }
}

export const loginReturnStore = createLoginReturnStore({ getStorage: () => window.sessionStorage })

export async function loginAndNavigate({ form, signIn, returnTo, navigate, returns = loginReturnStore }) {
  const session = await signIn(buildLoginBody(form))
  returns.clear()
  await navigate(loginDestination(returnTo), REPLACE_LOGIN)
  return session
}

/** 기존 서버의 /dashboard 콜백에서만 복귀합니다. 마이페이지 계정 연동 이동은 유지합니다. */
export async function resumeSocialLogin({ status, location, navigate, returns = loginReturnStore }) {
  if (status !== 'authenticated') return false
  const returnTo = returns.take()
  if (!returnTo || location.pathname !== '/dashboard' || location.search || location.hash
      || returnTo === '/dashboard') return false
  await navigate(returnTo, REPLACE_LOGIN)
  return true
}
