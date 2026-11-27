import { useEffect, useRef } from 'react'
import { Link } from 'react-router-dom'
import { LockKeyhole } from 'lucide-react'

export function LoginPromptDialog({ feature, returnTo, onClose }) {
  const ref = useRef(null)
  useEffect(() => {
    const dialog = ref.current
    dialog.showModal()
    return () => dialog.close()
  }, [])

  function dismiss() {
    ref.current.close()
    onClose()
  }

  return <dialog ref={ref} aria-labelledby="login-prompt-title" aria-describedby="login-prompt-description"
    onCancel={event => { event.preventDefault(); dismiss() }}
    className="fixed inset-0 m-auto max-h-[90dvh] w-[calc(100%-2rem)] max-w-sm overflow-y-auto overscroll-contain rounded-2xl border border-gray-200 bg-white p-6 text-gray-900 shadow-xl backdrop:bg-black/40">
    <span className="mb-4 inline-flex size-11 items-center justify-center rounded-full bg-emerald-50 text-[#195940]">
      <LockKeyhole size={22} aria-hidden="true" />
    </span>
    <h2 id="login-prompt-title" className="mf-title">로그인이 필요해요</h2>
    <p id="login-prompt-description" className="mf-copy">로그인하면 ‘{feature}’ 항목을 열 수 있어요. 처음이라면{' '}
      <Link to="/signup" state={{ from: returnTo }} className="font-semibold text-emerald-700 underline">회원가입</Link>해 주세요.</p>
    <div className="mt-6 flex flex-wrap justify-end gap-2">
      <button type="button" onClick={dismiss} className="btn-secondary">계속 둘러보기</button>
      <Link to="/login" state={{ from: returnTo }} className="btn-primary">로그인하기</Link>
    </div>
  </dialog>
}
