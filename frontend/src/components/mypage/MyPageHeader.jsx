import { LogOut } from 'lucide-react'

/** 마이페이지 상단: 닉네임·이메일과 로그아웃 버튼 */
export function MyPageHeader({ user, onLogout, logoutPending, disabled }) {
  const profile = { nickname: user.nickname }
  return (
    <div className="bg-white rounded-2xl p-6 border border-gray-200 shadow-xs mb-6 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div className="flex items-center gap-4">
        <div className="w-14 h-14 rounded-2xl bg-emerald-100 text-emerald-800 font-black text-xl flex items-center justify-center">
          {profile?.nickname?.[0] ||
            user?.nickname?.[0] ||
            user?.name?.[0] ||
            "M"}
        </div>
        <div>
          <h3 className="font-extrabold text-lg text-gray-900">
            {profile?.nickname || user?.nickname || user?.name || "프로필"}
          </h3>
          <p className="text-xs text-gray-500">{user?.email}</p>
          <p className="text-xs text-emerald-700 font-semibold mt-1">
            내 프로필과 식단 선호 정보를 관리하세요.
          </p>
        </div>
      </div>

      <button
        type="button"
        onClick={onLogout}
        disabled={logoutPending || disabled}
        className="px-4 py-2 rounded-xl border border-gray-300 text-gray-700 hover:bg-gray-50 text-xs font-semibold flex items-center gap-1.5 self-start sm:self-auto cursor-pointer min-h-[44px] disabled:opacity-50"
      >
        <LogOut className="w-4 h-4" />
        <span>{logoutPending ? "로그아웃 중..." : "로그아웃"}</span>
      </button>
    </div>
  )
}
