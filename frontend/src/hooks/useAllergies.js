import { useEffect, useRef, useState } from 'react'
import { useQuery, useQueryClient } from '@tanstack/react-query'
import { allergensApi } from '@/api/allergens'
import { getErrorMessage } from '@/api/client'
import { profileKeys } from '@/api/profile'
import { queryKeys } from '@/api/queryKeys'
import { useSessionMutation } from '@/hooks/useSessionMutation'
import { addCustomAllergy, allergySelection, toggleAllergyCodes } from '@/models/allergies'
import { assertCurrentSession, captureSession } from '@/models/sessionScope'
import { useAuthStore } from '@/stores/authStore'

const keys = queryKeys.allergens

export function useAllergySettings() {
  const userId = useAuthStore((state) => state.user?.id)
  const catalog = useQuery({
    queryKey: keys.catalog, queryFn: ({ signal }) => allergensApi.catalog(signal), enabled: Boolean(userId),
  })
  const mine = useQuery({
    queryKey: keys.mine(userId), queryFn: ({ signal }) => allergensApi.mine(signal),
    enabled: Boolean(userId), staleTime: 0,
  })
  return { catalog, mine }
}

export function useAllergenSearch() {
  const [input, setInput] = useState('')
  const term = input.trim()
  const [debounced, setDebounced] = useState('')
  useEffect(() => {
    const timer = setTimeout(() => setDebounced(term), 250)
    return () => clearTimeout(timer)
  }, [term])
  const query = useQuery({
    queryKey: keys.search(term),
    queryFn: ({ signal }) => allergensApi.search(term, signal),
    enabled: Boolean(term) && term === debounced,
    retry: false,
  })
  return { input, setInput, term, query }
}

function useReplaceAllergies() {
  const client = useQueryClient()
  const userId = useAuthStore((state) => state.user?.id)
  return useSessionMutation({
    mutationFn: allergensApi.replace,
    retry: false,
    onSuccess: async (saved) => {
      const scope = captureSession(useAuthStore.getState())
      const mine = keys.mine(userId)
      const profile = profileKeys.detail(userId)
      const details = profileKeys.settings(userId)
      await Promise.all([mine, profile, details].map((queryKey) => client.cancelQueries({ queryKey })))
      assertCurrentSession(scope, useAuthStore.getState())
      client.setQueryData(mine, saved)
      // 다른 프로필 PUT도 알레르기 배열이 필수다. 다음 탭이 직전 값을 보내지 않게 맞춘다.
      const allergies = [...saved.selected.map((item) => item.name), ...saved.custom]
      client.setQueryData(profile, (prev) => prev && { ...prev, allergies })
      client.setQueryData(details, (prev) => prev && {
        ...prev, trainer: { ...prev.trainer, allergies }, diet: { ...prev.diet, allergies },
      })
      await Promise.all([keys.checks(userId), queryKeys.quickMenu(userId), queryKeys.dashboard.profile].map((queryKey) =>
        client.invalidateQueries({ queryKey })))
    },
  })
}

export function useAllergyEditor(saved, categories, onDirtyChange, onSavingChange) {
  const save = useReplaceAllergies()
  const lock = useRef(false)
  const [draft, setDraft] = useState(null)
  const [input, setInput] = useState('')
  const [message, setMessage] = useState('')
  const [error, setError] = useState('')
  const selection = draft ?? allergySelection(saved)
  const items = categories.flatMap((category) => category.items)

  function editing() {
    setError('')
    setMessage('')
    // [마이페이지통합] onDirtyChange 미전달 시에도 안전하게 동작하도록 옵셔널 체이닝 적용
    onDirtyChange?.(true)
  }
  function update(next) {
    editing()
    setDraft(next)
  }
  function changeCustom(text) {
    editing()
    setInput(text)
  }
  function addCustom() {
    update(addCustomAllergy(selection, input, items))
    setInput('')
  }
  async function submit(event) {
    event.preventDefault()
    if (lock.current) return
    const next = addCustomAllergy(selection, input, items)
    setMessage('')
    if (next.codes.length + next.custom.length > 50) {
      setError('알레르기는 50개까지 등록할 수 있습니다.')
      return
    }
    lock.current = true
    onSavingChange?.(true)
    setError('')
    try {
      await save.mutateAsync(next)
      setDraft(null)
      setInput('')
      onDirtyChange?.(false)
      setMessage('알레르기를 저장했습니다.')
    } catch (failure) {
      setError(getErrorMessage(failure))
    } finally {
      lock.current = false
      onSavingChange?.(false)
    }
  }
  return {
    selection, items, input, changeCustom, addCustom, submit, message, error, isSaving: save.isPending,
    toggle: (codes) => update(toggleAllergyCodes(selection, codes)),
    removeCustom: (text) => update({ ...selection, custom: selection.custom.filter((item) => item !== text) }),
  }
}

export function useRecipeAllergenCheck(id) {
  const userId = useAuthStore((state) => state.user?.id)
  return useQuery({
    queryKey: keys.recipe(userId, id),
    queryFn: ({ signal }) => allergensApi.checkRecipe(id, signal),
    enabled: Boolean(userId && id), staleTime: 0, retry: false,
  })
}
