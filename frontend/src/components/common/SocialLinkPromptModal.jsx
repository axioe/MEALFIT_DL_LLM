import { useState } from 'react'
import { Link2, X } from 'lucide-react'
import { getErrorMessage } from '@/api/client'
import { usePrepareSocialLink, useSocialAccounts } from '@/hooks/useAuth'
import {
  getSocialPromptStorageKey,
  getSocialProviderMeta,
  shouldShowSocialLinkPrompt,
} from '@/models/socialAuth'
import { useAuthStore } from '@/stores/authStore'

function readDismissed(userId) {
  if (!userId || typeof window === 'undefined') return true
  try {
    return window.localStorage.getItem(getSocialPromptStorageKey(userId)) === '1'
  } catch {
    return false
  }
}

function writeDismissed(userId) {
  if (!userId || typeof window === 'undefined') return
  try {
    window.localStorage.setItem(getSocialPromptStorageKey(userId), '1')
  } catch {
    // 스토리지 접근이 제한된 환경에서는 무시합니다.
  }
}

/**
 * [소셜로그인] 기존 이메일 가입자(Google·Naver·Kakao 도메인) 중 아직 소셜 연동을 하지 않은 회원에게
 * 로그인 후 최초 1회만 소셜 연동 안내 팝업을 표시합니다.
 */
export function SocialLinkPromptModal() {
  const userId = useAuthStore((state) => state.user?.id)
  const { data: socialAccounts } = useSocialAccounts()
  const prepareLink = usePrepareSocialLink()
  const [closedManually, setClosedManually] = useState(false)
  const [error, setError] = useState('')

  const dismissed = closedManually || readDismissed(userId)
  const visible = shouldShowSocialLinkPrompt({
    userId,
    socialAccounts,
    dismissed,
  })

  if (!visible) return null

  const providerId = socialAccounts.eligibleProvider
  const meta = getSocialProviderMeta(providerId)
  if (!meta) return null

  function handleDismiss() {
    writeDismissed(userId)
    setClosedManually(true)
  }

  async function handleConnect() {
    if (prepareLink.isPending) return
    setError('')
    try {
      // [소셜로그인] 최초 1회 팝업이 다시 뜨지 않도록 기록한 뒤 OAuth 연동을 시작합니다.
      writeDismissed(userId)
      await prepareLink.mutateAsync(providerId)
      window.location.assign(meta.authPath)
    } catch (err) {
      setError(getErrorMessage(err, '소셜 연동을 시작하지 못했습니다.'))
    }
  }

  return (
    <div
      role="dialog"
      aria-modal="true"
      aria-labelledby="social-link-prompt-title"
      className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4"
    >
      <div className="w-full max-w-sm rounded-3xl bg-white p-6 shadow-xl border border-gray-200">
        <div className="flex items-start justify-between gap-3">
          <div className="flex items-center gap-2.5">
            <div className="w-10 h-10 rounded-2xl bg-emerald-100 text-emerald-700 flex items-center justify-center">
              <Link2 className="w-5 h-5" aria-hidden="true" />
            </div>
            <div>
              <h3 id="social-link-prompt-title" className="text-base font-black text-gray-900">
                {meta.label} 계정 연동 안내
              </h3>
              <p className="text-[11px] text-gray-500">최초 1회 안내</p>
            </div>
          </div>
          <button
            type="button"
            onClick={handleDismiss}
            aria-label="닫기"
            className="rounded-lg p-1 text-gray-400 hover:bg-gray-100 hover:text-gray-600 cursor-pointer"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        <p className="mt-4 text-xs text-gray-600 leading-relaxed">
          현재 사용 중인 이메일과 연결되는 <strong className="text-gray-900">{meta.label}</strong> 소셜 로그인을 연동하면 다음부터 비밀번호 없이 바로 로그인할 수 있습니다.
          <br />
          나중에 마이페이지에서도 언제든 연동하거나 해제할 수 있습니다.
        </p>

        {error && (
          <p role="alert" className="mt-3 rounded-xl bg-rose-50 border border-rose-200 p-2.5 text-xs text-rose-700">
            {error}
          </p>
        )}

        <div className="mt-5 flex flex-col gap-2">
          <button
            type="button"
            disabled={prepareLink.isPending}
            onClick={handleConnect}
            className="w-full py-2.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white text-sm font-bold cursor-pointer disabled:opacity-50"
          >
            {prepareLink.isPending ? '연동 페이지로 이동 중...' : `${meta.label} 계정 연동하기`}
          </button>
          <button
            type="button"
            disabled={prepareLink.isPending}
            onClick={handleDismiss}
            className="w-full py-2 rounded-xl border border-gray-200 hover:bg-gray-50 text-xs font-semibold text-gray-600 cursor-pointer"
          >
            나중에 하기
          </button>
        </div>
      </div>
    </div>
  )
}
