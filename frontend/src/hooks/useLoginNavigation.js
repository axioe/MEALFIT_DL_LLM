import { useLocation, useNavigate } from 'react-router-dom'
import { useLogin } from '@/hooks/useAuth'
import { loginAndNavigate, loginReturnStore } from '@/hooks/loginNavigation'
import { loginDestination } from '@/models/loginNavigation'

/** 이메일 로그인과 OAuth 시작이 동일한 복귀 주소 규칙을 사용합니다. */
export function useLoginNavigation() {
  const location = useLocation()
  const navigate = useNavigate()
  const login = useLogin()
  const oauthFailed = new URLSearchParams(location.search).has('oauthError')
  const returnTo = loginDestination(location.state?.from ?? (oauthFailed ? loginReturnStore.peek() : null))

  function submitLogin(form) {
    return loginAndNavigate({ form, signIn: (body) => login.mutateAsync(body), returnTo, navigate })
  }

  function startSocialLogin() {
    loginReturnStore.save(returnTo)
  }

  return { login, submitLogin, startSocialLogin }
}
