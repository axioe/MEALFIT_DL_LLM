import { Link, useSearchParams } from 'react-router-dom'
import { Shield } from "lucide-react";
import { BodyProfileForm } from "@/components/mypage/BodyProfileForm";
import { AllergySettings } from "@/components/mypage/AllergySettings";
import { DietProfileForm } from "@/components/mypage/DietProfileForm";
import { FitnessProfileForm } from "@/components/mypage/FitnessProfileForm";
import { FitnessTestForm } from "@/components/mypage/FitnessTestForm";
import { MyPageHeader } from "@/components/mypage/MyPageHeader";
import { MyPageTabs } from "@/components/mypage/MyPageTabs";
import { SocialAccountsCard } from "@/components/mypage/SocialAccountsCard";
import { TrainerProfileForm } from "@/components/mypage/TrainerProfileForm";
import { ProfileSettings } from "@/components/profile/ProfileSettings";
import { WithdrawalSection } from "@/components/profile/WithdrawalSection";
import { useLogoutAction, useMyPageForm } from "@/hooks/useMyPageForm";
import { useProfileDetails } from "@/hooks/useProfile";
import { useAuthStore } from "@/stores/authStore";

const TAB_FORMS = {
  trainer: TrainerProfileForm,
  common: BodyProfileForm,
  diet: DietProfileForm,
  fitness: FitnessProfileForm,
  tests: FitnessTestForm,
};

/** 데이터가 준비된 후 입력 폼을 생성하고 회원·탭 변경 시 초기화합니다. */
export function MyPage() {
  const query = useProfileDetails();
  const userId = useAuthStore((state) => state.user?.id);
  const [params, setParams] = useSearchParams();
  const selected = params.get('tab');
  const activeTab = ['profile','allergies',...Object.keys(TAB_FORMS)].includes(selected) ? selected : 'profile';
  function setActiveTab(tab) {
    const next = new URLSearchParams(params);
    next.set('tab', tab);
    setParams(next, { replace: true });
  }
  if (query.isPending) return <p role="status">마이페이지를 불러오는 중입니다.</p>;
  if (query.isError && !query.data) return (
    <div role="alert" className="rounded-xl bg-rose-50 p-4 text-sm">
      <p>마이페이지를 불러오지 못했습니다.</p>
      <button type="button" onClick={() => query.refetch()} disabled={query.isFetching} className="mt-2 underline">다시 시도</button>
    </div>
  );
  return <MyPageContent key={String(userId) + ':' + activeTab} details={query.data}
    activeTab={activeTab} setActiveTab={setActiveTab} />;
}

function MyPageContent({ details, activeTab, setActiveTab }) {
  const user = useAuthStore((state) => state.user) ?? {};
  const logout = useLogoutAction();
  const { form, updateField, changeTab, handleSave, isSaving, message, error, setDirty, setIsProfileSaving } =
    useMyPageForm({ details, activeTab, setActiveTab });
  const TabForm = TAB_FORMS[activeTab];
  const openAllergies = () => changeTab("allergies");

  return (
    <>
      <MyPageHeader user={user} onLogout={logout.handleLogout} logoutPending={logout.isPending} disabled={isSaving} />
      <nav aria-label="내 기록" className="mb-4 flex gap-2 md:hidden"><Link to="/calendar" className="btn-secondary">캘린더</Link><Link to="/weight" className="btn-secondary">체중 관리</Link></nav>
      <MyPageTabs activeTab={activeTab} onChange={changeTab} disabled={isSaving} />

      {activeTab === "profile" && <ProfileSettings onDirtyChange={setDirty} onSavingChange={setIsProfileSaving} onEditAllergies={openAllergies} />}
      {activeTab === "allergies" && <AllergySettings onDirtyChange={setDirty} onSavingChange={setIsProfileSaving} />}
      {message && <p role="status" className="mb-4 rounded-xl bg-emerald-50 p-3 text-sm text-emerald-800">{message}</p>}
      {error && <p role="alert" className="mb-4 rounded-xl bg-rose-50 p-3 text-sm text-rose-800">{error}</p>}
      {/* 저장 중에는 입력을 잠가 응답과 작성 내용이 엇갈리지 않도록 합니다. */}
      <fieldset disabled={isSaving} className="min-w-0">
        {TabForm && <TabForm form={form} updateField={updateField} onSubmit={handleSave} isSaving={isSaving}
          allergies={details[activeTab]?.allergies} onEditAllergies={openAllergies} />}
      </fieldset>

      {/* [소셜로그인] Google·Naver·Kakao 이메일 가입자 및 소셜 연동 회원에게만 표시됩니다. */}
      <SocialAccountsCard disabled={isSaving || logout.isPending} />

      {/* Privacy Notice & Account Deletion */}
      <div className="mt-8 bg-white rounded-2xl p-6 border border-gray-200 shadow-xs max-w-2xl space-y-4">
        <h4 className="font-bold text-sm text-gray-900 flex items-center gap-2">
          <Shield className="w-4 h-4 text-emerald-600" />
          개인정보 보호 및 AI 전송 범위 고지
        </h4>
        <p className="text-xs text-gray-500 leading-relaxed">
          계정 및 개인정보 설정을 관리합니다.
        </p>

        <WithdrawalSection disabled={isSaving || logout.isPending} />
      </div>
    </>
  );
}
