import { useRef, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useLogout } from '@/hooks/useAuth'
import { useUpdateProfileSection } from '@/hooks/useProfile'
import { buildProfileSectionBody, createProfileForm, profileSaveErrorMessage } from '@/models/profileForm'

/**
 * 마이페이지 탭 입력 상태와 저장 흐름 (Controller).
 * 화면(components/mypage)은 form 값과 updateField·handleSave만 받아 그린다.
 */
export function useMyPageForm({ details, activeTab, setActiveTab }) {
  const save = useUpdateProfileSection()
  const [isProfileSaving, setIsProfileSaving] = useState(false)
  const isSaving = save.isPending || isProfileSaving
  const submitLock = useRef(false)
  const [form, setForm] = useState(() => createProfileForm(details))
  const [dirty, setDirty] = useState(false)
  const [message, setMessage] = useState('')
  const [error, setError] = useState('')

  /** 입력값 하나를 바꾼다. next가 함수면 이전 값으로 계산한다 */
  function updateField(key, next) {
    setDirty(true)
    setMessage('')
    setError('')
    setForm((previous) => ({ ...previous, [key]: typeof next === 'function' ? next(previous[key]) : next }))
  }

  /** 저장하지 않고 탭을 바꿀 때 입력을 버릴지 확인합니다. */
  function changeTab(next) {
    if (next === activeTab || isSaving) return
    if (dirty && !window.confirm('저장하지 않은 입력이 있습니다. 입력을 버리고 다른 탭으로 이동할까요?')) return
    setActiveTab(next)
  }

  async function handleSave(event) {
    event.preventDefault()
    if (submitLock.current || isSaving) return
    setMessage('')
    setError('')
    submitLock.current = true
    try {
      const body = buildProfileSectionBody(activeTab, form)
      const saved = await save.mutateAsync({ section: activeTab, body })
      setForm(createProfileForm(saved))
      setDirty(false)
      setMessage('설정을 저장했습니다.')
    } catch (failure) {
      setError(profileSaveErrorMessage(failure))
    } finally {
      submitLock.current = false
    }
  }

  return { form, updateField, changeTab, handleSave, isSaving, message, error, setDirty, setIsProfileSaving }
}

/** 서버 토큰 폐기와 로컬 상태 정리가 끝나면 로그인 화면으로 이동합니다. (중복 클릭 방지) */
export function useLogoutAction() {
  const logout = useLogout()
  const navigate = useNavigate()
  const logoutLock = useRef(false)

  function handleLogout() {
    if (logoutLock.current || logout.isPending) return
    logoutLock.current = true
    logout.mutate(undefined, {
      // 서버 응답이 실패해도 useLogout이 로컬 로그인 정보는 정리합니다.
      onSettled: () => {
        logoutLock.current = false
        navigate('/login', { replace: true, state: null })
      },
    })
  }

  return { handleLogout, isPending: logout.isPending }
}
