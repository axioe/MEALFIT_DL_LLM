import { useEffect, useState } from 'react'
import { useSearchParams } from 'react-router-dom'
import { CheckCircle2, Link2, Unlink } from 'lucide-react'
import { getErrorMessage } from '@/api/client'
import {
  usePrepareSocialLink,
  useSocialAccounts,
  useUnlinkSocialAccount,
} from '@/hooks/useAuth'
import {
  getSocialErrorMessage,
  getSocialProviderMeta,
} from '@/models/socialAuth'

/**
 * [소셜로그인] 마이페이지 소셜 계정 연동 관리 카드입니다.
 * Google·Naver·Kakao 이메일 가입자 또는 이미 소셜 계정이 연동된 회원에게만 노출됩니다.
 * 그 외 이메일 도메인으로 가입한 회원에게는 렌더링하지 않습니다.
 */
export function SocialAccountsCard({ disabled = false }) {
  const [searchParams, setSearchParams] = useSearchParams()
  const { data: socialAccounts, isPending } = useSocialAccounts()
  const prepareLink = usePrepareSocialLink()
  const unlink = useUnlinkSocialAccount()
  const [notice, setNotice] = useState(() => {
    const linked = searchParams.get('socialLinked')
    if (!linked) return ''
    const meta = getSocialProviderMeta(linked)
    return `${meta?.label ?? linked} 계정이 성공적으로 연동되었습니다.`
  })
  const [error, setError] = useState(() => {
    const socialError = searchParams.get('socialError')
    return socialError
      ? (getSocialErrorMessage(socialError) ?? '소셜 계정을 연동하지 못했습니다.')
      : ''
  })

  // [소셜로그인] OAuth 연동 리다이렉트 쿼리(?socialLinked= / ?socialError=)를 URL에서 정리합니다.
  useEffect(() => {
    if (!searchParams.has('socialLinked') && !searchParams.has('socialError')) return
    const next = new URLSearchParams(searchParams)
    next.delete('socialLinked')
    next.delete('socialError')
    setSearchParams(next, { replace: true })
  }, [searchParams, setSearchParams])

  // [소셜로그인] 3개 소셜 도메인 외 일반 가입자(canManageSocialLinks=false)에게는 숨깁니다.
  if (isPending || !socialAccounts || !socialAccounts.canManageSocialLinks) {
    return null
  }

  const linkedSet = new Set(socialAccounts.linkedProviders ?? [])
  const targetProviderIds = Array.from(
    new Set([
      ...(socialAccounts.linkedProviders ?? []),
      ...(socialAccounts.eligibleProvider ? [socialAccounts.eligibleProvider] : []),
    ]),
  )

  async function handleLink(providerId) {
    const meta = getSocialProviderMeta(providerId)
    if (!meta || prepareLink.isPending) return
    setNotice('')
    setError('')
    try {
      await prepareLink.mutateAsync(providerId)
      window.location.assign(meta.authPath)
    } catch (err) {
      setError(getErrorMessage(err, '소셜 연동을 시작하지 못했습니다.'))
    }
  }

  async function handleUnlink(providerId) {
    const meta = getSocialProviderMeta(providerId)
    if (!meta || unlink.isPending) return
    setNotice('')
    setError('')
    try {
      await unlink.mutateAsync(providerId)
      setNotice(`${meta.label} 계정 연동을 해제했습니다.`)
    } catch (err) {
      setError(getErrorMessage(err, '소셜 연동을 해제하지 못했습니다.'))
    }
  }

  const isBusy = disabled || prepareLink.isPending || unlink.isPending

  return (
    <div className="bg-white rounded-2xl p-6 border border-gray-200 shadow-xs w-full space-y-4">
      <div className="flex items-center gap-2">
        <Link2 className="w-4 h-4 text-emerald-600" aria-hidden="true" />
        <h4 className="font-bold text-sm text-gray-900">소셜 계정 연동</h4>
      </div>
      <p className="text-xs text-gray-500 leading-relaxed">
        현재 계정 이메일과 연결 가능한 소셜 계정을 연동하면 다음부터 버튼 한 번으로 로그인할 수 있습니다.
      </p>

      {notice && (
        <p role="status" className="rounded-xl border border-emerald-200 bg-emerald-50 p-3 text-xs text-emerald-800">
          {notice}
        </p>
      )}
      {error && (
        <p role="alert" className="rounded-xl border border-rose-200 bg-rose-50 p-3 text-xs text-rose-800">
          {error}
        </p>
      )}

      <div className="space-y-2.5">
        {targetProviderIds.map((providerId) => {
          const meta = getSocialProviderMeta(providerId)
          if (!meta) return null
          const isLinked = linkedSet.has(providerId)
          const cannotUnlinkLast = !socialAccounts.hasPassword && linkedSet.size <= 1

          return (
            <div
              key={providerId}
              className="flex items-center justify-between gap-3 rounded-xl border border-gray-200 px-4 py-3"
            >
              <div className="flex items-center gap-2.5">
                <span className="text-sm font-bold text-gray-900">{meta.label}</span>
                {isLinked ? (
                  <span className="inline-flex items-center gap-1 rounded-full bg-emerald-50 px-2.5 py-0.5 text-[11px] font-semibold text-emerald-700">
                    <CheckCircle2 className="w-3.5 h-3.5" aria-hidden="true" />
                    연동됨
                  </span>
                ) : (
                  <span className="rounded-full bg-gray-100 px-2.5 py-0.5 text-[11px] font-semibold text-gray-500">
                    미연동
                  </span>
                )}
              </div>

              {isLinked ? (
                <button
                  type="button"
                  disabled={isBusy || cannotUnlinkLast}
                  onClick={() => handleUnlink(providerId)}
                  title={cannotUnlinkLast ? '비밀번호가 없는 계정은 마지막 소셜 연동을 해제할 수 없습니다.' : undefined}
                  className="inline-flex items-center gap-1 rounded-xl border border-gray-300 px-3 py-1.5 text-xs font-semibold text-gray-700 hover:bg-gray-50 cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  <Unlink className="w-3.5 h-3.5" aria-hidden="true" />
                  연동 해제
                </button>
              ) : (
                <button
                  type="button"
                  disabled={isBusy}
                  onClick={() => handleLink(providerId)}
                  className="rounded-xl bg-emerald-600 hover:bg-emerald-700 px-3.5 py-1.5 text-xs font-bold text-white cursor-pointer disabled:opacity-50"
                >
                  {meta.label} 연동하기
                </button>
              )}
            </div>
          )
        })}
      </div>
    </div>
  )
}
