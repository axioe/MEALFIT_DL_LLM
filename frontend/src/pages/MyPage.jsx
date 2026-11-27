import { Link, useSearchParams } from 'react-router-dom'
import { Shield } from 'lucide-react'
import { BodyFitnessCard } from '@/components/mypage/BodyFitnessCard'
import { DietAllergyCard } from '@/components/mypage/DietAllergyCard'
import { FitnessTestForm } from '@/components/mypage/FitnessTestForm'
import { MyPageHeader } from '@/components/mypage/MyPageHeader'
import { MyPageTabs } from '@/components/mypage/MyPageTabs'
import { SocialAccountsCard } from '@/components/mypage/SocialAccountsCard'
import { WithdrawalSection } from '@/components/profile/WithdrawalSection'
import { useLogoutAction, useMyPageForm } from '@/hooks/useMyPageForm'
import { useProfileDetails } from '@/hooks/useProfile'
import { useAuthStore } from '@/stores/authStore'

const LEGACY_TAB_MAP = {
  body: 'body',
  profile: 'body',
  common: 'body',
  trainer: 'body',
  fitness: 'body',
  diet: 'diet',
  allergies: 'diet',
  tests: 'tests',
  account: 'account',
}

function resolveTab(params) {
  const raw = params.get('tab')
  if (raw && LEGACY_TAB_MAP[raw]) return LEGACY_TAB_MAP[raw]
  // [마이페이지통합] 소셜 연동·탈퇴 재인증 콜백으로 돌아온 경우 계정·보안 탭을 바로 연다
  if (params.has('withdrawal') || params.has('socialLinked') || params.has('socialError')) {
    return 'account'
  }
  return 'body'
}

/** [마이페이지통합] 데이터가 준비된 후 중복 없는 4개 탭 화면을 렌더링합니다. */
export function MyPage() {
  const query = useProfileDetails()
  const userId = useAuthStore((state) => state.user?.id)
  const [params, setParams] = useSearchParams()
  const activeTab = resolveTab(params)

  function setActiveTab(nextTab) {
    const next = new URLSearchParams(params)
    next.set('tab', nextTab)
    setParams(next, { replace: true })
  }

  if (query.isPending) return <p role="status">마이페이지를 불러오는 중입니다.</p>
  if (query.isError && !query.data) {
    return (
      <div role="alert" className="rounded-xl bg-rose-50 p-4 text-sm">
        <p>마이페이지를 불러오지 못했습니다.</p>
        <button
          type="button"
          onClick={() => query.refetch()}
          disabled={query.isFetching}
          className="mt-2 underline"
        >
          다시 시도
        </button>
      </div>
    )
  }

  return (
    <MyPageContent
      key={String(userId)}
      details={query.data}
      activeTab={activeTab}
      onChangeTab={setActiveTab}
    />
  )
}

function MyPageContent({ details, activeTab, onChangeTab }) {
  const user = useAuthStore((state) => state.user) ?? {}
  const logout = useLogoutAction()
  const {
    form,
    updateField,
    isSaving,
    savingSection,
    statusByCard,
    handleSaveBodyFitness,
    handleSaveDiet,
    handleSaveTests,
    setIsAllergySaving,
  } = useMyPageForm({ details })

  return (
    <div>
      <MyPageHeader
        user={user}
        onLogout={logout.handleLogout}
        logoutPending={logout.isPending}
        disabled={isSaving}
      />
      <nav aria-label="내 기록" className="mb-4 flex gap-2 md:hidden">
        <Link to="/calendar" className="btn-secondary">캘린더</Link>
        <Link to="/weight" className="btn-secondary">체중 관리</Link>
      </nav>
      <MyPageTabs activeTab={activeTab} onChange={onChangeTab} disabled={isSaving} />

      {/* 탭 1: 내 프로필 · 신체 · 운동 설정 */}
      {activeTab === 'body' && (
        <BodyFitnessCard
          form={form}
          updateField={updateField}
          onSubmit={handleSaveBodyFitness}
          isSaving={savingSection === 'bodyFitness'}
          status={statusByCard.bodyFitness}
        />
      )}

      {/* 탭 2: 식단 설정 · 내 알레르기 */}
      {activeTab === 'diet' && (
        <DietAllergyCard
          form={form}
          updateField={updateField}
          onSubmit={handleSaveDiet}
          isSaving={savingSection === 'diet'}
          status={statusByCard.diet}
          onAllergySavingChange={setIsAllergySaving}
        />
      )}

      {/* 탭 3: 기초 체력 테스트 (선택) */}
      {activeTab === 'tests' && (
        <div className="w-full space-y-3">
          <FitnessTestForm
            form={form}
            updateField={updateField}
            onSubmit={handleSaveTests}
            isSaving={savingSection === 'tests'}
          />
          {statusByCard.tests.message && (
            <p role="status" className="rounded-xl bg-emerald-50 p-3 text-sm text-emerald-800">
              {statusByCard.tests.message}
            </p>
          )}
          {statusByCard.tests.error && (
            <p role="alert" className="rounded-xl bg-rose-50 p-3 text-sm text-rose-800">
              {statusByCard.tests.error}
            </p>
          )}
        </div>
      )}

      {/* 탭 4: 계정 · 보안 관리 (소셜 연동 + 회원 탈퇴 좌우 2단 배치) */}
      {activeTab === 'account' && (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 items-start">
          <SocialAccountsCard disabled={isSaving || logout.isPending} />

          <div className="bg-white rounded-2xl p-6 border border-gray-200 shadow-xs w-full space-y-4">
            <h4 className="font-bold text-sm text-gray-900 flex items-center gap-2">
              <Shield className="w-4 h-4 text-emerald-600" />
              개인정보 보호 및 AI 전송 범위 고지
            </h4>
            <p className="text-xs text-gray-500 leading-relaxed">
              계정 및 개인정보 설정을 관리합니다.
            </p>
            <WithdrawalSection disabled={isSaving || logout.isPending} />
          </div>
        </div>
      )}
    </div>
  )
}
