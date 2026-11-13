
/** 마이페이지 탭: 식단 기호와 알레르기 (화면만 담당, 상태·저장은 hooks/useMyPageForm) */
export function DietProfileForm({ form, updateField, onSubmit, isSaving }) {
  const { dietGoal, allergiesText, dislikedFoodsText, preferredFoodsText, cookTime, defaultServings, budgetPerMeal, prioritizeFridge } = form
  const setAllergiesText = (value) => updateField('allergiesText', value)
  const setBudgetPerMeal = (value) => updateField('budgetPerMeal', value)
  const setCookTime = (value) => updateField('cookTime', value)
  const setDefaultServings = (value) => updateField('defaultServings', value)
  const setDietGoal = (value) => updateField('dietGoal', value)
  const setDislikedFoodsText = (value) => updateField('dislikedFoodsText', value)
  const setPreferredFoodsText = (value) => updateField('preferredFoodsText', value)
  const setPrioritizeFridge = (value) => updateField('prioritizeFridge', value)

  return (
    <form
      onSubmit={onSubmit}
      className="bg-white rounded-2xl p-6 border border-gray-200 shadow-xs space-y-4 text-xs max-w-2xl"
    >
      <h4 className="font-bold text-sm text-gray-900 mb-2">
        식단 목표 & 선호도 설정
      </h4>

      <div>
        <label className="font-bold text-gray-700 block mb-1">
          식단 목표 *
        </label>
        <select
          value={dietGoal}
          onChange={(e) => setDietGoal(e.target.value)}
          className="w-full px-3 py-2 rounded-xl border border-gray-300 text-sm bg-white"
        >
          <option value="">
            선택하세요
          </option>
          <option value="loss">체중 감량 (칼로리 조절, 고단백 식이)</option>
          <option value="maintain">
            체중 유지 (탄단지 균형, 건강 증진)
          </option>
          <option value="gain">체중 증량 / 근비대 (영양 밀도 증가)</option>
        </select>
      </div>

      <div className="p-3 rounded-xl bg-rose-50 border border-rose-200 text-rose-900">
        <label className="font-bold block mb-1">
          🚨 알레르기 및 제외 식재료 (쉼표로 구분 - 엄격 준수)
        </label>
        <input
          type="text"
          placeholder="예: 땅콩, 갑각류, 복숭아, 우유"
          value={allergiesText}
          onChange={(e) => setAllergiesText(e.target.value)}
          className="w-full px-3 py-2 rounded-xl border border-rose-300 bg-white text-sm focus:outline-rose-500"
        />
        <p className="text-[11px] text-rose-700 mt-1">
          * 알레르기·제외 재료를 입력하세요.
        </p>
      </div>

      <div>
        <label className="font-bold text-gray-700 block mb-1">
          싫어하는 음식 (쉼표 구분)
        </label>
        <input
          type="text"
          placeholder="예: 오이, 가지, 고수"
          value={dislikedFoodsText}
          onChange={(e) => setDislikedFoodsText(e.target.value)}
          className="w-full px-3 py-2 rounded-xl border border-gray-300 text-sm focus:outline-emerald-500"
        />
      </div>

      <div>
        <label className="font-bold text-gray-700 block mb-1">
          선호 음식 (쉼표 구분)
        </label>
        <input
          type="text"
          placeholder="예: 닭가슴살 덮밥, 두부김치, 달걀 스크램블"
          value={preferredFoodsText}
          onChange={(e) => setPreferredFoodsText(e.target.value)}
          className="w-full px-3 py-2 rounded-xl border border-gray-300 text-sm focus:outline-emerald-500"
        />
      </div>

      <div className="grid grid-cols-2 gap-4">
        <div>
          <label className="font-bold text-gray-700 block mb-1">
            조리 가능 시간
          </label>
          <select
            value={cookTime}
            onChange={(e) => setCookTime((e.target.value === "" ? "" : Number(e.target.value)))}
            className="w-full px-3 py-2 rounded-xl border border-gray-300 text-sm bg-white"
          >
            <option value="">
              선택하세요
            </option>
            <option value={10}>10분 이내 (초간단)</option>
            <option value={20}>20분 이내 (표준)</option>
            <option value={30}>30분 이내 (풍성한 요리)</option>
          </select>
        </div>
        <div>
          <label className="font-bold text-gray-700 block mb-1">
            기본 식사 인분
          </label>
          <input
            type="number"
            min="1"
            max="6"
            value={defaultServings}
            onChange={(e) => setDefaultServings((e.target.value === "" ? "" : Number(e.target.value)))}
            className="w-full px-3 py-2 rounded-xl border border-gray-300 text-sm focus:outline-emerald-500"
          />
        </div>
      </div>

      <div>
        <label className="font-bold text-gray-700 block mb-1">
          끼니당 예산 (선택, 원)
        </label>
        <input
          type="number"
          step="1"
          min="1"
          max="2147483647"
          value={budgetPerMeal}
          onChange={(e) => setBudgetPerMeal((e.target.value === "" ? "" : Number(e.target.value)))}
          className="w-full px-3 py-2 rounded-xl border border-gray-300 text-sm focus:outline-emerald-500"
        />
      </div>

      <div className="flex items-center gap-2 pt-1">
        <input
          type="checkbox"
          id="prioritizeFridge"
          checked={prioritizeFridge}
          onChange={(e) => setPrioritizeFridge(e.target.checked)}
          className="w-4 h-4 rounded text-emerald-600 cursor-pointer"
        />
        <label
          htmlFor="prioritizeFridge"
          className="font-bold text-gray-800 cursor-pointer"
        >
          냉장고 기한 임박 재료 우선 소진 활성화
        </label>
      </div>

      <div className="pt-3">
        <button
          type="submit"
          className="w-full py-2.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-sm shadow-xs min-h-[44px] cursor-pointer"
          disabled={isSaving}
        >
          {isSaving ? "저장 중..." : "식단 설정 저장"}
        </button>
      </div>
    </form>
  )
}
