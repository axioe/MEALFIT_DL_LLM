import { Dumbbell, Scale, Shield, Utensils } from 'lucide-react'

const TABS = [
  { key: 'body', label: '신체 · 운동', icon: Dumbbell },
  { key: 'diet', label: '식단 · 알레르기', icon: Utensils },
  { key: 'tests', label: '체력 테스트 (선택)', icon: Scale },
  { key: 'account', label: '계정 · 보안', icon: Shield },
]

/** [마이페이지통합] 중복 없는 4개 탭 네비게이션 바 */
export function MyPageTabs({ activeTab, onChange, disabled }) {
  return (
    <div
      role="tablist"
      aria-label="마이페이지 설정 탭"
      className="flex items-center gap-2 mb-6 border-b border-gray-200 pb-2.5 overflow-x-auto"
    >
      {TABS.map((t) => {
        const Icon = t.icon
        const isActive = activeTab === t.key
        return (
          <button
            key={t.key}
            type="button"
            role="tab"
            aria-selected={isActive}
            disabled={disabled}
            onClick={() => onChange(t.key)}
            className={`flex items-center gap-1.5 px-4 py-2.5 rounded-xl text-xs font-bold transition-all cursor-pointer shrink-0 disabled:opacity-50 ${
              isActive
                ? 'bg-emerald-600 text-white shadow-xs'
                : 'bg-white text-gray-600 border border-gray-200 hover:bg-gray-100'
            }`}
          >
            <Icon className="w-4 h-4" />
            <span>{t.label}</span>
          </button>
        )
      })}
    </div>
  )
}
