import { Utensils } from 'lucide-react'
import { AllergySettings } from '@/components/mypage/AllergySettings'
import { DIET_TYPE_OPTIONS } from '@/lib/profileOptions'

/** [마이페이지통합] 카드 2: 식단 목표·기호 설정 + 내 알레르기 통합 카드 */
export function DietAllergyCard({ form, updateField, onSubmit, isSaving, status, onAllergySavingChange }) {
  const {
    dietGoal, dietType, cookTime, defaultServings, budgetPerMeal,
    preferredFoodsText, dislikedFoodsText, prioritizeFridge,
  } = form

  const inputClass = 'w-full px-3 py-2 rounded-xl border border-gray-300 text-sm bg-white focus:outline-emerald-500'

  return (
    <section id="section-diet-allergy" className="scroll-mt-24 w-full grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
      <form
        onSubmit={onSubmit}
        className="lg:col-span-5 bg-white rounded-2xl p-6 border border-gray-200 shadow-xs space-y-5 text-xs"
      >
        <div className="flex items-center justify-between pb-3 border-b border-gray-100">
          <div>
            <span className="inline-flex items-center gap-1 text-[11px] font-bold px-2 py-0.5 rounded-md bg-emerald-100 text-emerald-800 mb-1">
              <Utensils className="w-3.5 h-3.5" />
              식단 설정 · 알레르기
            </span>
            <h3 className="font-extrabold text-base text-gray-900">
              식단 목표와 기호 설정
            </h3>
          </div>
          <div className="w-10 h-10 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center shrink-0">
            <Utensils className="w-5 h-5" />
          </div>
        </div>

        <fieldset disabled={isSaving} className="space-y-4 min-w-0 disabled:opacity-70">
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div>
              <label htmlFor="mp-diet-goal" className="font-bold text-gray-700 block mb-1">
                식단 목표
              </label>
              <select
                id="mp-diet-goal"
                value={dietGoal}
                onChange={(e) => updateField('dietGoal', e.target.value)}
                className={inputClass}
              >
                <option value="">선택하세요</option>
                <option value="loss">체중 감량 (칼로리 조절·고단백)</option>
                <option value="maintain">체중 유지 (탄단지 균형)</option>
                <option value="gain">체중 증량 / 근비대</option>
              </select>
            </div>
            <div>
              <label htmlFor="mp-diet-type" className="font-bold text-gray-700 block mb-1">
                식단 유형
              </label>
              <select
                id="mp-diet-type"
                value={dietType}
                onChange={(e) => updateField('dietType', e.target.value)}
                className={inputClass}
              >
                <option value="">선택하세요</option>
                {DIET_TYPE_OPTIONS.map((d) => (
                  <option key={d.id} value={d.id}>
                    {d.label}
                  </option>
                ))}
              </select>
            </div>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
            <div>
              <label htmlFor="mp-cook-time" className="font-bold text-gray-700 block mb-1">
                조리 가능 시간
              </label>
              <select
                id="mp-cook-time"
                value={cookTime}
                onChange={(e) => updateField('cookTime', e.target.value === '' ? '' : Number(e.target.value))}
                className={inputClass}
              >
                <option value="">선택하세요</option>
                <option value={10}>10분 이내</option>
                <option value={20}>20분 이내</option>
                <option value={30}>30분 이내</option>
              </select>
            </div>
            <div>
              <label htmlFor="mp-servings" className="font-bold text-gray-700 block mb-1">
                기본 식사 인분
              </label>
              <input
                id="mp-servings"
                type="number"
                min="1"
                max="6"
                value={defaultServings}
                onChange={(e) => updateField('defaultServings', e.target.value === '' ? '' : Number(e.target.value))}
                className={inputClass}
              />
            </div>
            <div>
              <label htmlFor="mp-budget" className="font-bold text-gray-700 block mb-1">
                한 끼 예산 (원)
              </label>
              <input
                id="mp-budget"
                type="number"
                step="1"
                min="1"
                max="2147483647"
                value={budgetPerMeal}
                onChange={(e) => updateField('budgetPerMeal', e.target.value === '' ? '' : Number(e.target.value))}
                className={inputClass}
              />
            </div>
          </div>

          <div>
            <label htmlFor="mp-preferred" className="font-bold text-gray-700 block mb-1">
              선호 음식 (쉼표 구분)
            </label>
            <input
              id="mp-preferred"
              type="text"
              placeholder="예: 닭가슴살 덮밥, 두부김치, 달걀 스크램블"
              value={preferredFoodsText}
              onChange={(e) => updateField('preferredFoodsText', e.target.value)}
              className={inputClass}
            />
          </div>

          <div>
            <label htmlFor="mp-disliked" className="font-bold text-gray-700 block mb-1">
              제외 · 기피 재료 (쉼표 구분)
            </label>
            <input
              id="mp-disliked"
              type="text"
              placeholder="예: 오이, 가지, 고수"
              value={dislikedFoodsText}
              onChange={(e) => updateField('dislikedFoodsText', e.target.value)}
              className={inputClass}
            />
          </div>

          <label className="flex items-center gap-2 text-xs font-semibold text-gray-700 cursor-pointer">
            <input
              type="checkbox"
              checked={Boolean(prioritizeFridge)}
              onChange={(e) => updateField('prioritizeFridge', e.target.checked)}
              className="rounded border-gray-300 text-emerald-600 focus:ring-emerald-500"
            />
            냉장고 보유 재료를 우선해서 식단을 추천받기
          </label>

          <button
            type="submit"
            disabled={isSaving}
            className="w-full py-3 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-sm shadow-xs min-h-[44px] cursor-pointer disabled:opacity-50"
          >
            {isSaving ? '저장 중...' : '식단 설정 저장'}
          </button>
        </fieldset>

        {status?.message && (
          <p role="status" className="rounded-xl bg-emerald-50 p-3 text-sm text-emerald-800">
            {status.message}
          </p>
        )}
        {status?.error && (
          <p role="alert" className="rounded-xl bg-rose-50 p-3 text-sm text-rose-800">
            {status.error}
          </p>
        )}
      </form>

      {/* [마이페이지통합] 알레르기 설정을 우측 7칸에 넓게 배치 */}
      <div id="section-allergies" className="lg:col-span-7 scroll-mt-24">
        <AllergySettings onDirtyChange={() => {}} onSavingChange={onAllergySavingChange} />
      </div>
    </section>
  )
}
