import { Dumbbell, Scale, Shield, User, Utensils, Zap } from 'lucide-react'

const TABS = [
  { key: "profile", label: "내 프로필 · 식단 설정", icon: User },
  { key: "allergies", label: "내 알레르기", icon: Shield },
  { key: "trainer", label: "AI 트레이너 프로필 (필수 & 선택)", icon: Zap },
  { key: "common", label: "신체 기본 정보", icon: User },
  { key: "diet", label: "식단 기호", icon: Utensils },
  { key: "fitness", label: "운동 목표 & 장비", icon: Dumbbell },
  { key: "tests", label: "체력 테스트 측정", icon: Scale },
]

/** 마이페이지 탭 버튼 줄 */
export function MyPageTabs({ activeTab, onChange, disabled }) {
  return (
    <>
      <label className="mb-4 block md:hidden">
        <span className="label">설정 항목</span>
        <select className="input" value={activeTab} disabled={disabled} onChange={event => onChange(event.target.value)}>
          {TABS.map(tab => <option key={tab.key} value={tab.key}>{tab.label}</option>)}
        </select>
      </label>
      <div className="mb-6 hidden items-center gap-2 overflow-x-auto border-b border-gray-200 pb-2 md:flex">
        {TABS.map((t) => {
          const Icon = t.icon;
          const isActive = activeTab === t.key;
          return (
            <button
              key={t.key}
              disabled={disabled}
              onClick={() => onChange(t.key)}
              className={`flex items-center gap-1.5 px-4 py-2.5 rounded-xl text-xs font-bold transition-all cursor-pointer shrink-0 ${
                isActive
                  ? "bg-emerald-600 text-white shadow-xs"
                  : "bg-white text-gray-600 hover:bg-gray-100"
              }`}
            >
              <Icon className="w-4 h-4" />
              <span>{t.label}</span>
            </button>
          );
        })}
      </div>
    </>
  )
}
