import { useEffect } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import { getErrorMessage, restoreSession } from '@/api/client'
import { useCurrentUser } from '@/hooks/useAuth'
import { useAuthStore } from '@/stores/authStore'
import { resumeSocialLogin } from '@/hooks/loginNavigation'

/** 세션 복구·회원 확인의 흐름은 Controller에서 처리하고 View에는 표시 상태만 전달합니다. */
export function useSessionRecovery() {
  const location = useLocation()
  const navigate = useNavigate()
  const accessToken = useAuthStore((state) => state.accessToken)
  const bootstrapped = useAuthStore((state) => state.bootstrapped)
  const restoring = useAuthStore((state) => state.restoring)
  const restoreError = useAuthStore((state) => state.restoreError)
  const sessionVersion = useAuthStore((state) => state.sessionVersion)
  const me = useCurrentUser({ enabled: Boolean(accessToken) })

  useEffect(() => {
    if (!accessToken && !bootstrapped && !restoreError) {
      void restoreSession().catch(() => {})
    }
  }, [accessToken, bootstrapped, restoreError])

  const status = !bootstrapped ? (restoreError ? 'restore-error' : 'restoring')
    : !accessToken ? 'anonymous'
    : me.isPending ? 'checking-user'
    : me.isError ? 'user-error' : 'authenticated'

  useEffect(() => {
    void resumeSocialLogin({ status, location, navigate })
  }, [status, location, navigate])

  function retry() {
    if (!bootstrapped) void restoreSession().catch(() => {})
    else void me.refetch()
  }

  return {
    status,
    sessionVersion,
    isRetrying: restoring || me.isFetching,
    errorMessage: getErrorMessage(restoreError ?? me.error,
      '로그인 상태를 확인하지 못했습니다. 잠시 후 다시 시도해 주세요.'),
    retry,
  }
}
