import { EQUIPMENT_OPTIONS } from '@/lib/profileOptions'
import { toggleExclusiveItem } from '@/models/profileForm'

/** 마이페이지 탭: 운동 목표와 장비 (화면만 담당, 상태·저장은 hooks/useMyPageForm) */
export function FitnessProfileForm({ form, updateField, onSubmit, isSaving }) {
  const { fitnessGoal, experience, equipment, daysPerWeek, durationMinutes, uncomfortableAreasText } = form
  const setDaysPerWeek = (value) => updateField('daysPerWeek', value)
  const setDurationMinutes = (value) => updateField('durationMinutes', value)
  const setExperience = (value) => updateField('experience', value)
  const setFitnessGoal = (value) => updateField('fitnessGoal', value)
  const setUncomfortableAreasText = (value) => updateField('uncomfortableAreasText', value)
  const toggleEquipment = (eq) => updateField('equipment', (previous) => toggleExclusiveItem(previous, eq))

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

      <div>
        <label className="font-bold text-gray-700 block mb-1">
          1회 운동 시간
        </label>
        <input type="number" min="10" max="90" step="5" value={durationMinutes}
          onChange={(e) => setDurationMinutes(e.target.value === "" ? "" : Number(e.target.value))}
          className="w-full px-3 py-2 rounded-xl border border-gray-300 text-sm" />
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

      <div className="p-3 rounded-xl bg-amber-50 border border-amber-200 text-amber-900">
        <label className="font-bold block mb-1">
          불편한 부위 / 관절 통증 (쉼표 구분)
        </label>
        <input
          type="text"
          placeholder="예: 허리, 무릎, 손목, 어깨"
          value={uncomfortableAreasText}
          onChange={(e) => setUncomfortableAreasText(e.target.value)}
          className="w-full px-3 py-2 rounded-xl border border-amber-300 bg-white text-sm focus:outline-amber-500"
        />
        <p className="text-[11px] text-amber-800 mt-1">
          * 불편한 부위를 프로필에 저장합니다. 운동 추천 적용은 별도로 연결합니다.
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
