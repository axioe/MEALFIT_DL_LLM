import { useEffect } from 'react'
import { Navigate, Outlet, useLocation } from 'react-router-dom'
import { getErrorMessage, restoreSession } from '@/api/client'
import { useCurrentUser } from '@/hooks/useAuth'
import { useAuthStore } from '@/stores/authStore'
import { Spinner } from '@/components/common/Spinner'

/**
 * [JWT메모리][HttpOnly쿠키]
 * 메모리에 Access Token이 없으면 새로고침 직후 Refresh 쿠키로 세션을 먼저 복구합니다.
 * 복구 중에는 인증 확인 화면을 표시하고, 실패하면 로그인 화면으로 이동합니다.
 */
export function RequireAuth() {
  const location = useLocation()
  const accessToken = useAuthStore((state) => state.accessToken)
  const bootstrapped = useAuthStore((state) => state.bootstrapped)

  useEffect(() => {
    if (!accessToken && !bootstrapped) {
      void restoreSession()
    }
  }, [accessToken, bootstrapped])

  const me = useCurrentUser({ enabled: Boolean(accessToken) })

  // [JWT메모리] 새로고침 후 Refresh 쿠키로 세션을 복구하는 동안 인증 확인 상태를 표시합니다.
  if (!bootstrapped) {
    return (
      <div role="status" className="flex min-h-screen items-center justify-center gap-3 bg-gray-50">
        <Spinner />
        <span className="text-sm text-gray-500">세션을 복구하고 있습니다.</span>
      </div>
    )
  }

  if (!accessToken) {
    return (
      <Navigate
        to="/login"
        replace
        state={{ from: location.pathname + location.search + location.hash }}
      />
    )
  }

  // 처음 인증을 확인하는 동안 보호 화면의 API와 내용을 열지 않습니다.
  if (me.isPending) {
    return (
      <div role="status" className="flex min-h-screen items-center justify-center gap-3 bg-gray-50">
        <Spinner />
        <span className="text-sm text-gray-500">로그인 정보를 확인하고 있습니다.</span>
      </div>
    )
  }

  // 일시적인 통신 장애는 로그아웃으로 단정하지 않고 재시도를 제공합니다.
  if (me.isError) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-gray-50 p-4">
        <div className="card space-y-4">
          <p role="alert" className="text-sm text-rose-700">
            {getErrorMessage(me.error)}
          </p>
          <button
            type="button"
            disabled={me.isFetching}
            onClick={() => me.refetch()}
            className="btn-primary min-h-11"
          >
            {me.isFetching ? '확인 중...' : '다시 시도'}
          </button>
        </div>
      </div>
    )
  }

  return <Outlet />
}
