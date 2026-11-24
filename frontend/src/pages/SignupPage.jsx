import React, { useRef, useState } from 'react'
import { Link } from 'react-router-dom'
import { AlertCircle, CheckCircle2, Mail, Zap } from 'lucide-react'
import { BrandLogo } from '@/components/common/BrandLogo'
import { useResendEmailVerification, useSignup } from '@/hooks/useAuth'
import { getErrorMessage } from '@/api/client'
import { buildSignupBody, validateSignupForm } from '@/models/authForm'

/**
 * [이메일인증] 이메일·비밀번호·닉네임으로 가입하고 인증 메일을 발송합니다.
 * 메일 링크로 인증을 완료한 뒤 로그인하면 토큰이 발급됩니다.
 */
export function SignupPage() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [nickname, setNickname] = useState('')
  const [formError, setFormError] = useState('')
  const [signedUpEmail, setSignedUpEmail] = useState('')
  const [resendNotice, setResendNotice] = useState('')
  const submitLock = useRef(false)
  const signup = useSignup()
  const resend = useResendEmailVerification()
  const isSubmitting = signup.isPending
  const error = formError || (
    signup.isError
      ? getErrorMessage(signup.error, '회원가입하지 못했습니다.')
      : null
  )

  /** 화면에서도 검증하고, 최종 검증·중복 검사는 서버에 맡깁니다. */
  async function handleSubmit(event) {
    event.preventDefault()
    if (submitLock.current) return

    setFormError('')
    setResendNotice('')
    signup.reset()

    const invalid = validateSignupForm({ password, nickname })
    if (invalid) {
      setFormError(invalid)
      return
    }

    submitLock.current = true
    try {
      const result = await signup.mutateAsync(
        buildSignupBody({ email, password, nickname }),
      )
      // [이메일인증] 가입 직후 자동 로그인하지 않고 인증 메일 안내 화면으로 전환
      setSignedUpEmail(result?.email || email.trim())
    } catch {
      // 중복 이메일 등 서버 오류는 기존 오류 영역에 표시합니다.
    } finally {
      submitLock.current = false
    }
  }

  /** [이메일인증] 가입 완료 안내 화면에서 인증 메일 재발송을 요청합니다. */
  async function handleResend() {
    if (!signedUpEmail || resend.isPending) return
    setResendNotice('')
    try {
      await resend.mutateAsync(signedUpEmail)
      setResendNotice('인증 메일을 다시 발송했습니다. 메일함을 확인해 주세요.')
    } catch (err) {
      setResendNotice(getErrorMessage(err, '인증 메일을 다시 보내지 못했습니다.'))
    }
  }

  if (signedUpEmail) {
    return (
      <div className="min-h-screen bg-gradient-to-b from-emerald-50/50 via-gray-50 to-white flex items-center justify-center p-4">
        <div className="bg-white rounded-3xl p-6 sm:p-8 border border-gray-200 shadow-xl max-w-lg w-full text-center">
          <div className="w-12 h-12 rounded-2xl bg-emerald-100 text-emerald-700 flex items-center justify-center mx-auto mb-3">
            <CheckCircle2 aria-hidden="true" className="w-6 h-6" />
          </div>
          <h1 className="text-xl font-black text-gray-900 tracking-tight">
            인증 메일을 발송했습니다
          </h1>
          <p className="text-xs text-gray-600 mt-2 leading-relaxed">
            <strong className="text-gray-900">{signedUpEmail}</strong> 로 인증 링크를 보냈습니다.
            <br />
            메일의 인증 링크를 클릭한 뒤 로그인해 주세요.
          </p>

          {resendNotice && (
            <p role="status" className="mt-4 rounded-xl border border-emerald-200 bg-emerald-50 p-3 text-xs text-emerald-800">
              {resendNotice}
            </p>
          )}

          <div className="mt-6 flex flex-col gap-2.5">
            <Link
              to="/login"
              state={{ email: signedUpEmail }}
              className="w-full py-3 rounded-2xl bg-emerald-600 hover:bg-emerald-700 text-white font-extrabold text-sm shadow-md shadow-emerald-200 transition-all"
            >
              로그인 화면으로 이동
            </Link>
            <button
              type="button"
              onClick={handleResend}
              disabled={resend.isPending}
              className="w-full py-2.5 rounded-2xl border border-gray-200 hover:bg-gray-50 text-gray-700 font-bold text-xs flex items-center justify-center gap-1.5 cursor-pointer disabled:opacity-50"
            >
              <Mail aria-hidden="true" className="w-4 h-4" />
              <span>{resend.isPending ? '재발송 중...' : '인증 메일 다시 보내기'}</span>
            </button>
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-b from-emerald-50/50 via-gray-50 to-white flex items-center justify-center p-4">
      <div className="bg-white rounded-3xl p-6 sm:p-8 border border-gray-200 shadow-xl max-w-lg w-full">
        <div className="text-center mb-6">
          <BrandLogo className="w-12 h-12 mx-auto mb-2" />
          <h1 className="text-xl font-black text-gray-900 tracking-tight">
            MealFit 회원가입
          </h1>
          <p className="text-xs text-gray-500 mt-1">
            계정 정보를 입력하고 밀핏을 시작하세요.
          </p>
        </div>

        {error && (
          <div role="alert" className="mb-4 p-3 rounded-xl bg-rose-50 border border-rose-200 text-rose-800 text-xs flex items-center gap-2">
            <AlertCircle aria-hidden="true" className="w-4 h-4 text-rose-600 shrink-0" />
            <span>{error}</span>
          </div>
        )}

        <form onSubmit={handleSubmit} className="space-y-4 text-xs">
          <div>
            <label htmlFor="signup-nickname" className="font-bold text-gray-700 block mb-1">
              닉네임 *
            </label>
            <input
              id="signup-nickname"
              type="text"
              required
              maxLength={50}
              autoComplete="nickname"
              disabled={isSubmitting}
              placeholder="밀핏러버"
              value={nickname}
              onChange={(event) => setNickname(event.target.value)}
              className="w-full px-3 py-2.5 rounded-xl border border-gray-300 text-sm focus:outline-emerald-500"
            />
          </div>

          <div>
            <label htmlFor="signup-email" className="font-bold text-gray-700 block mb-1">
              이메일 *
            </label>
            <input
              id="signup-email"
              type="email"
              required
              maxLength={254}
              autoComplete="username"
              autoCapitalize="none"
              disabled={isSubmitting}
              placeholder="user@example.com"
              value={email}
              onChange={(event) => setEmail(event.target.value)}
              className="w-full px-3 py-2.5 rounded-xl border border-gray-300 text-sm focus:outline-emerald-500"
            />
          </div>

          <div>
            <label htmlFor="signup-password" className="font-bold text-gray-700 block mb-1">
              비밀번호 *
            </label>
            <input
              id="signup-password"
              type="password"
              required
              minLength={8}
              maxLength={64}
              autoComplete="new-password"
              disabled={isSubmitting}
              aria-describedby="signup-password-help"
              placeholder="8자 이상 64자 이하"
              value={password}
              onChange={(event) => setPassword(event.target.value)}
              className="w-full px-3 py-2.5 rounded-xl border border-gray-300 text-sm focus:outline-emerald-500"
            />
            <p id="signup-password-help" className="mt-1.5 text-[11px] text-gray-500">
              8~64자로 입력해 주세요. 한글 등 다국어 문자는 72바이트 제한이 함께 적용됩니다.
            </p>
          </div>

          <p className="text-[11px] text-gray-500 leading-relaxed bg-gray-50 p-2.5 rounded-xl border border-gray-100">
            가입 후 이메일 인증을 완료하고 로그인하면 마이페이지에서 식단 목표와 알레르기를 설정할 수 있습니다.
          </p>

          <button
            type="submit"
            disabled={isSubmitting}
            className="w-full py-3 rounded-2xl bg-emerald-600 hover:bg-emerald-700 text-white font-extrabold text-sm shadow-md shadow-emerald-200 transition-all flex items-center justify-center gap-1.5 min-h-[46px] cursor-pointer disabled:opacity-50"
          >
            <Zap aria-hidden="true" className="w-4 h-4" />
            <span>{isSubmitting ? '가입 진행 중...' : '회원가입'}</span>
          </button>
        </form>

        <div className="text-center mt-5 pt-3 border-t border-gray-100 text-xs text-gray-500">
          이미 계정이 있으신가요?{' '}
          <Link to="/login" className="text-emerald-700 font-bold hover:underline">
            로그인하기
          </Link>
        </div>
      </div>
    </div>
  )
}
