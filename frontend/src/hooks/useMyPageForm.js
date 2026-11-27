import { useRef, useState } from 'react'
import { useLogout } from '@/hooks/useAuth'
import { useUpdateProfileSection } from '@/hooks/useProfile'
import { buildProfileSectionBody, createProfileForm, profileSaveErrorMessage } from '@/models/profileForm'

/**
 * [마이페이지통합] 단일 페이지 4카드 입력 상태와 카드별 저장 흐름 (Controller).
 * 화면(components/mypage)은 form 값과 updateField·카드별 저장 핸들러만 받아 그린다.
 */
export function useMyPageForm({ details }) {
  const save = useUpdateProfileSection()
  const [isAllergySaving, setIsAllergySaving] = useState(false)
  const [savingSection, setSavingSection] = useState(null)
  const submitLock = useRef(false)
  const [form, setForm] = useState(() => createProfileForm(details))
  const [statusByCard, setStatusByCard] = useState({
    bodyFitness: { message: '', error: '' },
    diet: { message: '', error: '' },
    tests: { message: '', error: '' },
  })

  const isSaving = save.isPending || isAllergySaving || savingSection !== null

  /** 입력값 하나를 바꾼다. next가 함수면 이전 값으로 계산한다 */
  function updateField(key, next) {
    setForm((previous) => ({ ...previous, [key]: typeof next === 'function' ? next(previous[key]) : next }))
  }

  function setCardStatus(cardKey, message, error) {
    setStatusByCard((prev) => ({ ...prev, [cardKey]: { message, error } }))
  }

  /** 카드 1: 신체 기본 정보(common) + 운동 조건(fitness) 순차 저장 */
  async function handleSaveBodyFitness(event) {
    event.preventDefault()
    if (submitLock.current || isSaving) return
    setCardStatus('bodyFitness', '', '')
    submitLock.current = true
    setSavingSection('bodyFitness')
    try {
      const commonBody = buildProfileSectionBody('common', form)
      await save.mutateAsync({ section: 'common', body: commonBody })
      const fitnessBody = buildProfileSectionBody('fitness', form)
      const saved = await save.mutateAsync({ section: 'fitness', body: fitnessBody })
      setForm((prev) => ({
        ...createProfileForm(saved),
        // 다른 카드에서 작성 중이던 식단·체력 입력값은 덮어쓰지 않는다
        dietGoal: prev.dietGoal,
        dietType: prev.dietType,
        dislikedFoodsText: prev.dislikedFoodsText,
        preferredFoodsText: prev.preferredFoodsText,
        cookTime: prev.cookTime,
        defaultServings: prev.defaultServings,
        budgetPerMeal: prev.budgetPerMeal,
        prioritizeFridge: prev.prioritizeFridge,
        restingHeartRate: prev.restingHeartRate,
        pushups: prev.pushups,
        squat30s: prev.squat30s,
        plankSeconds: prev.plankSeconds,
      }))
      setCardStatus('bodyFitness', '신체 · 운동 설정을 저장했습니다.', '')
    } catch (failure) {
      setCardStatus('bodyFitness', '', profileSaveErrorMessage(failure))
    } finally {
      submitLock.current = false
      setSavingSection(null)
    }
  }

  /** 카드 2: 식단 목표 · 기호(diet) 저장 (알레르기는 AllergySettings에서 독립 저장) */
  async function handleSaveDiet(event) {
    event.preventDefault()
    if (submitLock.current || isSaving) return
    setCardStatus('diet', '', '')
    submitLock.current = true
    setSavingSection('diet')
    try {
      const dietBody = buildProfileSectionBody('diet', form, details.diet?.allergies ?? [])
      const saved = await save.mutateAsync({ section: 'diet', body: dietBody })
      setForm((prev) => ({
        ...prev,
        dietGoal: createProfileForm(saved).dietGoal,
        dietType: createProfileForm(saved).dietType,
        dislikedFoodsText: createProfileForm(saved).dislikedFoodsText,
        preferredFoodsText: createProfileForm(saved).preferredFoodsText,
        cookTime: createProfileForm(saved).cookTime,
        defaultServings: createProfileForm(saved).defaultServings,
        budgetPerMeal: createProfileForm(saved).budgetPerMeal,
        prioritizeFridge: createProfileForm(saved).prioritizeFridge,
      }))
      setCardStatus('diet', '식단 설정을 저장했습니다.', '')
    } catch (failure) {
      setCardStatus('diet', '', profileSaveErrorMessage(failure))
    } finally {
      submitLock.current = false
      setSavingSection(null)
    }
  }

  /** 카드 3: 기초 체력 테스트(tests) 저장 */
  async function handleSaveTests(event) {
    event.preventDefault()
    if (submitLock.current || isSaving) return
    setCardStatus('tests', '', '')
    submitLock.current = true
    setSavingSection('tests')
    try {
      const testsBody = buildProfileSectionBody('tests', form)
      const saved = await save.mutateAsync({ section: 'tests', body: testsBody })
      const nextTests = createProfileForm(saved)
      setForm((prev) => ({
        ...prev,
        restingHeartRate: nextTests.restingHeartRate,
        pushups: nextTests.pushups,
        squat30s: nextTests.squat30s,
        plankSeconds: nextTests.plankSeconds,
      }))
      setCardStatus('tests', '기초 체력 테스트를 저장했습니다.', '')
    } catch (failure) {
      setCardStatus('tests', '', profileSaveErrorMessage(failure))
    } finally {
      submitLock.current = false
      setSavingSection(null)
    }
  }

  return {
    form,
    updateField,
    isSaving,
    savingSection,
    statusByCard,
    handleSaveBodyFitness,
    handleSaveDiet,
    handleSaveTests,
    setIsAllergySaving,
  }
}

/** 화면 이동은 공통 인증 흐름에 맡기고 로그아웃 중복 클릭을 막습니다. */
export function useLogoutAction() {
  const logout = useLogout()
  const logoutLock = useRef(false)

  function handleLogout() {
    if (logoutLock.current || logout.isPending) return
    logoutLock.current = true
    logout.mutate(undefined, {
      // 서버 응답이 실패해도 useLogout이 로컬 로그인 정보는 정리합니다.
      onSettled: () => {
        logoutLock.current = false
      },
    })
  }

  return { handleLogout, isPending: logout.isPending }
}
