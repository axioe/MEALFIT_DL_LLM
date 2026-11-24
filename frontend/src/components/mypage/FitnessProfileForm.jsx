import { EQUIPMENT_OPTIONS, INJURY_AREA_OPTIONS, WORKOUT_MINUTES_OPTIONS } from '@/lib/profileOptions'
import { toggleExclusiveItem, toggleItem } from '@/models/profileForm'

/** 마이페이지 탭: 운동 목표와 장비 (화면만 담당, 상태·저장은 hooks/useMyPageForm) */
export function FitnessProfileForm({ form, updateField, onSubmit, isSaving }) {
  const { fitnessGoal, experience, equipment, daysPerWeek, durationMinutes, fitnessInjuries } = form
  const setDaysPerWeek = (value) => updateField('daysPerWeek', value)
  const setDurationMinutes = (value) => updateField('durationMinutes', value)
  const setExperience = (value) => updateField('experience', value)
  const setFitnessGoal = (value) => updateField('fitnessGoal', value)
  const toggleEquipment = (eq) => updateField('equipment', (previous) => toggleExclusiveItem(previous, eq))
  // [운동조건설정] D3 합의 기준: 7개 부상 부위 토글 선택
  const toggleInjury = (area) => updateField('fitnessInjuries', (previous) => toggleItem(previous, area))

  return (
    <form
      onSubmit={onSubmit}
      className="bg-white rounded-2xl p-6 border border-gray-200 shadow-xs space-y-4 text-xs max-w-2xl"
    >
      <h4 className="font-bold text-sm text-gray-900 mb-2">
        운동 목표 & 보유 장비
      </h4>

      <div>
        <label className="font-bold text-gray-700 block mb-1">
          운동 목표
        </label>
        <select
          value={fitnessGoal}
          onChange={(e) => setFitnessGoal(e.target.value)}
          className="w-full px-3 py-2 rounded-xl border border-gray-300 text-sm bg-white"
        >
          <option value="">
            선택하세요
          </option>
          <option value="loss">체지방 감량 & 대사 활성화</option>
          <option value="hypertrophy">근비대 & 근력 향상</option>
          <option value="stamina">전신 지구력 & 심폐 강화</option>
          <option value="health">유연성 및 체형 교정</option>
        </select>
      </div>

      <div className="grid grid-cols-2 gap-4">
        <div>
          <label className="font-bold text-gray-700 block mb-1">
            운동 구력/경험
          </label>
          <select
            value={experience}
            onChange={(e) => setExperience(e.target.value)}
            className="w-full px-3 py-2 rounded-xl border border-gray-300 text-sm bg-white"
          >
            <option value="">
              선택하세요
            </option>
            <option value="starter">
              입문 (운동을 거의 해본 적 없음)
            </option>
            <option value="beginner">
              초급 (기본 동작 인지 및 3~6개월 경험)
            </option>
            <option value="advanced">고급 (고강도 트레이닝 가능)</option>
            <option value="intermediate">
              중급 (규칙적 운동 1년 이상)
            </option>
          </select>
        </div>
        <div>
          <label className="font-bold text-gray-700 block mb-1">
            주당 운동 일수 (2~6일)
          </label>
          <input
            type="number"
            min="2"
            max="6"
            value={daysPerWeek}
            onChange={(e) => setDaysPerWeek((e.target.value === "" ? "" : Number(e.target.value)))}
            className="w-full px-3 py-2 rounded-xl border border-gray-300 text-sm focus:outline-emerald-500"
          />
        </div>
      </div>

      {/* [운동조건설정] D1 합의 기준: 회당 운동 시간 15/30/45/60분 선택 */}
      <div>
        <div className="flex items-center justify-between mb-1.5">
          <label className="font-bold text-gray-700">
            1회 운동 시간 (15·30·45·60분)
          </label>
          {durationMinutes !== "" && (
            <button
              type="button"
              onClick={() => setDurationMinutes("")}
              className="text-[11px] text-gray-500 underline cursor-pointer"
            >
              설정 해제
            </button>
          )}
        </div>
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-2">
          {WORKOUT_MINUTES_OPTIONS.map((opt) => {
            const isSelected = Number(durationMinutes) === opt.value
            return (
              <button
                type="button"
                key={opt.value}
                onClick={() => setDurationMinutes(isSelected ? "" : opt.value)}
                className={`p-2.5 rounded-xl border text-center transition-all cursor-pointer ${
                  isSelected
                    ? "bg-emerald-600 text-white border-emerald-600 shadow-xs"
                    : "bg-white border-gray-200 text-gray-700 hover:bg-gray-50"
                }`}
              >
                <span className="font-bold text-xs block">{opt.label}</span>
                <span className={`text-[10px] block ${isSelected ? "text-emerald-100" : "text-gray-400"}`}>
                  {opt.desc}
                </span>
              </button>
            )
          })}
        </div>
      </div>

      {/* Equipment checkboxes */}
      <div>
        <label className="font-bold text-gray-700 block mb-1.5">
          보유 운동 장비 (선택):
        </label>
        <div className="grid grid-cols-3 gap-2">
          {EQUIPMENT_OPTIONS.map((item) => (
            <button
              type="button"
              key={item.id}
              onClick={() => toggleEquipment(item.id)}
              className={`p-2.5 rounded-xl border text-xs font-bold transition-all cursor-pointer ${
                equipment.includes(item.id)
                  ? "bg-emerald-50 border-emerald-500 text-emerald-800"
                  : "bg-white border-gray-200 text-gray-600 hover:bg-gray-50"
              }`}
            >
              {item.label}
            </button>
          ))}
        </div>
      </div>

      {/* [운동조건설정] D3 합의 기준: 허용된 7개 부상 부위만 선택 */}
      <div className="p-3.5 rounded-xl bg-amber-50 border border-amber-200 text-amber-900">
        <label className="font-bold block mb-2">
          불편한 부위 / 관절 통증 (해당 부위 선택)
        </label>
        <div className="flex flex-wrap gap-2">
          {INJURY_AREA_OPTIONS.map((area) => {
            const isSelected = (fitnessInjuries ?? []).includes(area)
            return (
              <button
                type="button"
                key={area}
                onClick={() => toggleInjury(area)}
                className={`px-3 py-1.5 rounded-xl border text-xs font-semibold transition-all cursor-pointer ${
                  isSelected
                    ? "bg-amber-200 border-amber-500 text-amber-950 shadow-2xs"
                    : "bg-white border-amber-200 text-amber-900 hover:bg-amber-100/60"
                }`}
              >
                {area} {isSelected && "✓"}
              </button>
            )
          })}
        </div>
        <p className="text-[11px] text-amber-800 mt-2">
          * 선택한 부위에 부담이 큰 운동은 루틴 추천·검증 시 자동으로 제외됩니다.
        </p>
      </div>

      <div className="pt-3">
        <button
          type="submit"
          className="w-full py-2.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-sm shadow-xs min-h-[44px] cursor-pointer"
          disabled={isSaving}
        >
          {isSaving ? "저장 중..." : "운동 프로필 저장"}
        </button>
      </div>
    </form>
  )
}
