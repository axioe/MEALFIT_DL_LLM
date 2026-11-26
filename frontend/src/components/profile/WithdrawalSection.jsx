import { useEffect, useId, useRef, useState } from 'react'
import { useSearchParams } from 'react-router-dom'
import { useSocialAccounts } from '@/hooks/useAuth'
import { useWithdraw, useWithdrawalReauthentication } from '@/hooks/useWithdrawal'
import { validateWithdrawalInput } from '@/models/withdrawalFlow'
import { getSocialProviderMeta } from '@/models/socialAuth'
import { getErrorMessage } from '@/api/client'

/** 기존 프로필 저장 중에는 탈퇴를 시작하지 않습니다. */
export function WithdrawalSection({ disabled = false }) {
  const [searchParams, setSearchParams] = useSearchParams()
  const callback = searchParams.get('withdrawal')
  const [open, setOpen] = useState(() => callback === 'verified' || callback === 'failed')
  function close() {
    setOpen(false)
    if (callback) {
      setSearchParams((current) => {
        const next = new URLSearchParams(current)
        next.delete('withdrawal')
        return next
      }, { replace: true })
    }
  }
  return (
    <div className="pt-4 border-t border-gray-100 flex items-center justify-between gap-4">
      <div>
        <span className="font-bold text-xs text-rose-700 block">회원 탈퇴</span>
        <span className="text-[11px] text-gray-500">본인 확인 후 계정과 이용 기록을 삭제합니다.</span>
      </div>
      <button type="button" onClick={() => setOpen(true)} disabled={disabled}
        className="min-h-11 shrink-0 rounded-xl border border-rose-300 bg-rose-50 px-3.5 py-2 text-xs font-bold text-rose-700 hover:bg-rose-100 disabled:opacity-50">
        회원 탈퇴
      </button>
      {open && <WithdrawalDialog callback={callback} onClose={close} />}
    </div>
  )
}

/** native dialog가 포커스 이동과 배경 조작 차단을 처리합니다. */
function WithdrawalDialog({ callback, onClose }) {
  const dialogRef = useRef(null)
  const passwordRef = useRef(null)
  const submitLock = useRef(false)
  const id = useId()
  const withdrawal = useWithdraw()
  const accounts = useSocialAccounts()
  const social = accounts.data?.hasPassword === false
  const { status, start, cancel } = useWithdrawalReauthentication(social)
  const [password, setPassword] = useState('')
  const [confirmed, setConfirmed] = useState(false)
  const [error, setError] = useState(callback === 'failed' ? '연결된 소셜 계정으로 다시 인증해 주세요.' : '')
  const [expiredStatusAt, setExpiredStatusAt] = useState(0)
  const remainingMillis = status.data?.remainingMillis ?? 0
  const verified = social && status.isSuccess && remainingMillis > 0 && expiredStatusAt !== status.dataUpdatedAt

  useEffect(() => {
    const dialog = dialogRef.current
    dialog.showModal()
    passwordRef.current?.focus()
    return () => dialog.close()
  }, [])

  useEffect(() => {
    if (!verified) return
    const elapsed = Math.max(0, Date.now() - status.dataUpdatedAt)
    const timer = setTimeout(() => setExpiredStatusAt(status.dataUpdatedAt), Math.max(0, remainingMillis - elapsed))
    return () => clearTimeout(timer)
  }, [remainingMillis, status.dataUpdatedAt, verified])

  async function close() {
    if (submitLock.current || withdrawal.isPending || start.isPending || cancel.isPending) return
    if (social) {
      try {
        await cancel.mutateAsync()
      } catch (failure) {
        setError(getErrorMessage(failure, '인증을 취소하지 못했습니다. 다시 시도해 주세요.'))
        return
      }
    }
    onClose()
  }

  async function startSocial(provider) {
    setError('')
    try {
      await start.mutateAsync(provider.id)
      window.location.assign(provider.authPath + '?withdrawal=1')
    } catch (failure) {
      setError(getErrorMessage(failure, '소셜 인증을 시작하지 못했습니다.'))
    }
  }

  async function handleSubmit(event) {
    event.preventDefault()
    if (submitLock.current || withdrawal.isPending || !accounts.data || (social && !verified)) return
    setError('')
    try {
      if (!social) validateWithdrawalInput(password, confirmed)
      else if (!confirmed) return
    } catch (failure) {
      setError(failure.message)
      passwordRef.current?.focus()
      return
    }
    submitLock.current = true
    try {
      await withdrawal.mutateAsync({ password, confirmed, social })
    } catch (failure) {
      // 비밀번호 오류나 통신 실패만으로 현재 로그인 정보를 삭제하지 않습니다.
      setError(getErrorMessage(failure, '탈퇴를 완료하지 못했습니다. 다시 시도해 주세요.'))
      setPassword('')
      passwordRef.current?.focus()
      if (social) {
        setConfirmed(false)
        void status.refetch()
      }
    } finally {
      submitLock.current = false
    }
  }

  return (
    <dialog ref={dialogRef} aria-labelledby={id + '-title'} aria-describedby={id + '-description'}
      onCancel={(event) => { event.preventDefault(); close() }}
      className="fixed inset-0 m-auto max-h-[90dvh] w-[calc(100%-2rem)] max-w-md overflow-y-auto rounded-2xl border border-gray-200 bg-white p-6 text-gray-900 shadow-xl backdrop:bg-black/40">
      <h2 id={id + '-title'} className="text-lg font-bold">회원 탈퇴</h2>
      <div id={id + '-description'} className="mt-3 space-y-2 text-sm text-gray-600">
        <p>탈퇴하면 모든 기기에서 로그인과 서비스 이용이 차단됩니다.</p>
        <p>계정과 이용 기록이 삭제됩니다. 같은 이메일이나 소셜 계정으로 재가입하면 새 계정으로 시작합니다.</p>
        <p>저장하지 않은 입력 내용은 사라집니다.</p>
      </div>
      <form onSubmit={handleSubmit} className="mt-5 space-y-4">
        <fieldset disabled={withdrawal.isPending || start.isPending || cancel.isPending} className="space-y-4">
          {!accounts.data && <p role="status" className="text-sm">
            {accounts.isError ? '계정의 인증 방법을 불러오지 못했습니다.' : '계정의 인증 방법을 확인하는 중입니다.'}
          </p>}
          {accounts.isError && !accounts.data &&
            <button type="button" className="text-sm underline" onClick={() => accounts.refetch()}>다시 시도</button>}
          {accounts.data?.hasPassword && <div>
            <label htmlFor={id + '-password'} className="block text-sm font-semibold">현재 비밀번호</label>
            <input ref={passwordRef} id={id + '-password'} type="password" required maxLength={72}
              autoComplete="current-password" value={password}
              aria-invalid={Boolean(error)} aria-describedby={error ? id + '-error' : undefined}
              onChange={(event) => { setPassword(event.target.value); setError('') }}
              className="mt-1 min-h-11 w-full rounded-xl border border-gray-300 px-3 py-2 focus:outline-rose-500" />
          </div>}
          {social && !verified && <div className="space-y-2">
            <p className="text-sm">{status.isPending ? '재인증 상태를 확인하는 중입니다.' : '연결된 소셜 계정으로 인증해 주세요.'}</p>
            {!status.isPending && accounts.data.linkedProviders.map(getSocialProviderMeta).filter(Boolean).map((provider) =>
              <button key={provider.id} type="button" onClick={() => startSocial(provider)}
                className="mr-2 min-h-11 rounded-xl border border-gray-300 px-3 text-sm font-semibold">
                {provider.label}로 다시 인증
              </button>
            )}
          </div>}
          {verified && <p role="status" className="text-sm text-emerald-700">
            소셜 인증을 확인했습니다. 인증 후 5분 안에 탈퇴를 확정해 주세요.
          </p>}
          {(accounts.data?.hasPassword || verified) && <label className="flex items-start gap-2 text-sm">
            <input type="checkbox" required checked={confirmed}
              onChange={(event) => { setConfirmed(event.target.checked); setError('') }}
              className="mt-1 h-4 w-4 shrink-0 accent-rose-600" />
            <span>탈퇴 안내를 확인했으며 회원 탈퇴에 동의합니다.</span>
          </label>}
          {error && <p id={id + '-error'} role="alert" className="text-sm text-rose-700">{error}</p>}
          <div className="flex justify-end gap-2">
            <button type="button" onClick={close} className="min-h-11 rounded-xl border border-gray-300 px-4 py-2 text-sm">취소</button>
            <button type="submit" disabled={!confirmed || !accounts.data || (social ? !verified : !password.trim()) || withdrawal.isPending}
              className="min-h-11 rounded-xl bg-rose-600 px-4 py-2 text-sm font-bold text-white hover:bg-rose-700 disabled:opacity-50">
              {withdrawal.isPending ? '탈퇴 처리 중...' : '탈퇴 확정'}
            </button>
          </div>
        </fieldset>
      </form>
    </dialog>
  )
}
