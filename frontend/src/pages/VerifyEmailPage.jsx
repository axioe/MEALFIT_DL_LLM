import React, { useEffect, useRef, useState } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { AlertCircle, CheckCircle2, Loader2 } from 'lucide-react'
import { useConfirmEmailVerification } from '@/hooks/useAuth'
import { getErrorMessage } from '@/api/client'

/**
 * [이메일인증] 메일 링크(?token=...)로 진입했을 때 서버에 인증 완료를 요청하는 공개 페이지입니다.
 */
export function VerifyEmailPage() {
  const [searchParams] = useSearchParams()
  const token = searchParams.get('token')?.trim() ?? ''
  const confirm = useConfirmEmailVerification()
  const [status, setStatus] = useState(token ? 'loading' : 'error')
  const [errorMessage, setErrorMessage] = useState(
    token ? '' : '유효하지 않은 이메일 인증 링크입니다.',
  )
  const triggered = useRef(false)

  useEffect(() => {
    if (!token || triggered.current) return
    triggered.current = true

    confirm
      .mutateAsync(token)
      .then(() => {
        setStatus('success')
      })
      .catch((err) => {
        setStatus('error')
        setErrorMessage(
          getErrorMessage(err, '이메일 인증에 실패했습니다. 링크가 만료되었을 수 있습니다.'),
        )
      })
  }, [token])

  return (
    <div className="min-h-screen bg-gradient-to-b from-emerald-50/50 via-gray-50 to-white flex items-center justify-center p-4">
      <div className="bg-white rounded-3xl p-6 sm:p-8 border border-gray-200 shadow-xl max-w-md w-full text-center">
        {status === 'loading' && (
          <>
            <Loader2 aria-hidden="true" className="w-10 h-10 text-emerald-600 animate-spin mx-auto mb-3" />
            <h1 className="text-lg font-black text-gray-900">이메일 인증을 확인하고 있습니다...</h1>
          </>
        )}

        {status === 'success' && (
          <>
            <div className="w-12 h-12 rounded-2xl bg-emerald-100 text-emerald-700 flex items-center justify-center mx-auto mb-3">
              <CheckCircle2 aria-hidden="true" className="w-6 h-6" />
            </div>
            <h1 className="text-xl font-black text-gray-900">이메일 인증이 완료되었습니다</h1>
            <p className="text-xs text-gray-600 mt-2">
              이제 가입하신 이메일과 비밀번호로 로그인할 수 있습니다.
            </p>
            <Link
              to="/login"
              state={{ verified: true }}
              className="mt-6 inline-block w-full py-3 rounded-2xl bg-emerald-600 hover:bg-emerald-700 text-white font-extrabold text-sm"
            >
              로그인하러 가기
            </Link>
          </>
        )}

        {status === 'error' && (
          <>
            <div className="w-12 h-12 rounded-2xl bg-rose-100 text-rose-700 flex items-center justify-center mx-auto mb-3">
              <AlertCircle aria-hidden="true" className="w-6 h-6" />
            </div>
            <h1 className="text-xl font-black text-gray-900">이메일 인증에 실패했습니다</h1>
            <p className="text-xs text-rose-700 mt-2">{errorMessage}</p>
            <Link
              to="/login"
              className="mt-6 inline-block w-full py-3 rounded-2xl bg-gray-900 hover:bg-gray-800 text-white font-extrabold text-sm"
            >
              로그인 화면으로 이동
            </Link>
          </>
        )}
      </div>
    </div>
  )
}
