import { Navigate, Outlet, useLocation } from 'react-router-dom'
import { useSessionRecovery } from '@/hooks/useSessionRecovery'
import { Spinner } from '@/components/common/Spinner'

/** 세션 복구 상태에 따라 보호 화면·재시도 안내·로그인 화면을 표시합니다. */
export function RequireAuth() {
  const location = useLocation()
  const session = useSessionRecovery()

  if (session.status === 'restore-error' || session.status === 'user-error') {
    return (
      <div className="flex min-h-screen items-center justify-center bg-gray-50 p-4">
        <div className="card space-y-4">
          <p role="alert" className="text-sm text-rose-700">{session.errorMessage}</p>
          <button type="button" disabled={session.isRetrying}
            onClick={session.retry} className="btn-primary min-h-11">
            {session.isRetrying ? '확인 중...' : '다시 시도'}
          </button>
        </div>
      </div>
    )
  }

  if (session.status === 'restoring' || session.status === 'checking-user') {
    return (
      <div role="status" className="flex min-h-screen items-center justify-center gap-3 bg-gray-50">
        <Spinner />
        <span className="text-sm text-gray-500">
          {session.status === 'restoring' ? '세션을 복구하고 있습니다.' : '로그인 정보를 확인하고 있습니다.'}
        </span>
      </div>
    )
  }

  if (session.status === 'anonymous') {
    return (
      <Navigate to="/login" replace
        state={{ from: location.pathname + location.search + location.hash }} />
    )
  }

  return <Outlet key={session.sessionVersion} />
}
