import { AlertTriangle, Award, CheckCircle2, Clock, Sparkles, Target, Zap } from 'lucide-react'
import { DIET_TYPE_OPTIONS, EQUIPMENT_OPTIONS, INJURY_AREA_OPTIONS } from '@/lib/profileOptions'
import { toggleExclusiveItem, toggleItem } from '@/models/profileForm'

/** 마이페이지 탭: AI 트레이너 프로필: 신체 정보·운동 환경·식단 설정 (화면만 담당, 상태·저장은 hooks/useMyPageForm) */
export function TrainerProfileForm({ form, updateField, onSubmit, isSaving }) {
  const { trainerAge, trainerHeight, trainerWeight, trainerGoal, trainerLevel, trainerEnvironment, trainerEquipment, trainerAvailableTime, trainerInjuries, trainerAllergiesText, trainerDislikedFoodsText, trainerDietType, trainerBudget } = form
  const setTrainerAge = (value) => updateField('trainerAge', value)
  const setTrainerAllergiesText = (value) => updateField('trainerAllergiesText', value)
  const setTrainerAvailableTime = (value) => updateField('trainerAvailableTime', value)
  const setTrainerBudget = (value) => updateField('trainerBudget', value)
  const setTrainerDietType = (value) => updateField('trainerDietType', value)
  const setTrainerDislikedFoodsText = (value) => updateField('trainerDislikedFoodsText', value)
  const setTrainerEnvironment = (value) => updateField('trainerEnvironment', value)
  const setTrainerGoal = (value) => updateField('trainerGoal', value)
  const setTrainerHeight = (value) => updateField('trainerHeight', value)
  const setTrainerLevel = (value) => updateField('trainerLevel', value)
  const setTrainerWeight = (value) => updateField('trainerWeight', value)
  const toggleTrainerEquipment = (eq) => updateField('trainerEquipment', (previous) => toggleExclusiveItem(previous, eq))
  const toggleTrainerInjury = (area) => updateField('trainerInjuries', (previous) => toggleItem(previous, area))

  return (
    <form
      onSubmit={onSubmit}
      className="bg-white rounded-2xl p-6 border border-gray-200 shadow-xs space-y-6 text-xs max-w-2xl"
    >
      <div className="flex items-center justify-between pb-3 border-b border-gray-100">
        <div>
          <div className="flex items-center gap-2 mb-1">
            <span className="shrink-0 whitespace-nowrap text-xs font-bold px-2 py-0.5 rounded-md bg-emerald-100 text-emerald-800">
              AI 트레이너 프로필
            </span>
            <span className="text-[11px] text-gray-400"></span>
          </div>
          <h4 className="font-extrabold text-base text-gray-900">
            신체 정보와 운동 환경 설정
          </h4>
        </div>
        <div className="w-10 h-10 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center">
          <Zap className="w-5 h-5 fill-emerald-600" />
        </div>
      </div>

      {/* 1. 필수 항목 섹션 */}
      <div className="space-y-4">
        <h5 className="font-bold text-xs text-emerald-800 uppercase tracking-wider flex items-center gap-1.5">
          <Sparkles className="w-4 h-4 text-emerald-600" />
          1. 필수 항목 (첫 실행 시 수집)
        </h5>

        <div className="grid grid-cols-3 gap-3 p-3.5 rounded-2xl bg-emerald-50/40 border border-emerald-100">
          <div>
            <label className="font-bold text-gray-700 block mb-1">
              나이 (만) *
            </label>
            <input
              type="number"
              min="18"
              max="80"
              required
              value={trainerAge}
              onChange={(e) => setTrainerAge((e.target.value === "" ? "" : Number(e.target.value)))}
              className="w-full px-3 py-2 rounded-xl border border-gray-300 text-sm font-bold bg-white focus:outline-emerald-500"
            />
          </div>
          <div>
            <label className="font-bold text-gray-700 block mb-1">
              키 (cm) *
            </label>
            <input
              type="number"
              min="100"
              max="240"
              required
              step="0.1"
              value={trainerHeight}
              onChange={(e) => setTrainerHeight((e.target.value === "" ? "" : Number(e.target.value)))}
              className="w-full px-3 py-2 rounded-xl border border-gray-300 text-sm font-bold bg-white focus:outline-emerald-500"
            />
          </div>
          <div>
            <label className="font-bold text-gray-700 block mb-1">
              체중 (kg) *
            </label>
            <input
              type="number"
              min="30"
              max="250"
              required
              step="0.1"
              value={trainerWeight}
              onChange={(e) => setTrainerWeight((e.target.value === "" ? "" : Number(e.target.value)))}
              className="w-full px-3 py-2 rounded-xl border border-gray-300 text-sm font-bold bg-white focus:outline-emerald-500"
            />
          </div>
        </div>

        {/* 운동 목적 */}
        <div>
          <label className="font-bold text-gray-800 block mb-1.5 flex items-center gap-1">
            <Target className="w-3.5 h-3.5 text-emerald-600" />
            운동 목적 *
          </label>
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-2">
            {[
              { id: "loss", label: "체중 감량", desc: "체지방 연소" },
              {
                id: "hypertrophy",
                label: "근육 증가",
                desc: "근비대·근력",
              },
              { id: "stamina", label: "체력 향상", desc: "지구력 증진" },
              { id: "health", label: "건강 유지", desc: "체형·활력" },
            ].map((item) => (
              <button
                type="button"
                key={item.id}
                onClick={() => setTrainerGoal(item.id)}
                className={`p-2.5 rounded-xl border text-left transition-all cursor-pointer ${
                  trainerGoal === item.id
                    ? "bg-emerald-600 text-white border-emerald-600 shadow-xs"
                    : "bg-white border-gray-200 text-gray-700 hover:bg-gray-50"
                }`}
              >
                <span className="font-bold text-xs block">
                  {item.label}
                </span>
                <span
                  className={`text-[10px] block truncate ${trainerGoal === item.id ? "text-emerald-100" : "text-gray-400"}`}
                >
                  {item.desc}
                </span>
              </button>
            ))}
          </div>
        </div>

        {/* 운동 수준 */}
        <div>
          <label className="font-bold text-gray-800 block mb-1.5 flex items-center gap-1">
            <Award className="w-3.5 h-3.5 text-teal-600" />
            운동 수준 *
          </label>
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-2">
            {[
              { id: "starter", label: "입문", desc: "초보/오랜만" },
              { id: "beginner", label: "초급", desc: "3~6개월 기본" },
              { id: "intermediate", label: "중급", desc: "1년+ 규칙적" },
              { id: "advanced", label: "고급", desc: "분할/고강도" },
            ].map((item) => (
              <button
                type="button"
                key={item.id}
                onClick={() => setTrainerLevel(item.id)}
                className={`p-2.5 rounded-xl border text-left transition-all cursor-pointer ${
                  trainerLevel === item.id
                    ? "bg-teal-600 text-white border-teal-600 shadow-xs"
                    : "bg-white border-gray-200 text-gray-700 hover:bg-gray-50"
                }`}
              >
                <span className="font-bold text-xs block">
                  {item.label}
                </span>
                <span
                  className={`text-[10px] block truncate ${trainerLevel === item.id ? "text-teal-100" : "text-gray-400"}`}
                >
                  {item.desc}
                </span>
              </button>
            ))}
          </div>
        </div>
      </div>

      {/* 2. 선택 항목 섹션 (설정 화면에서 나중에 추가) */}
      <div className="space-y-4 pt-4 border-t border-gray-100">
        <div className="flex items-center justify-between">
          <h5 className="font-bold text-xs text-gray-700 uppercase tracking-wider flex items-center gap-1.5">
            <Clock className="w-4 h-4 text-emerald-600" />
            2. 선택 항목 (설정 화면에서 자유롭게 추가)
          </h5>
          <span className="text-[11px] text-gray-400">
            운동 환경·장비·식단 기호 저장
          </span>
        </div>

        {/* 운동 환경 */}
        <div>
          <label className="font-bold text-gray-700 block mb-1.5">
            운동 환경
          </label>
          <div className="grid grid-cols-3 gap-2">
            {[
              { id: "home", label: "🏠 집 (홈트레이닝)" },
              { id: "gym", label: "🏋️ 헬스장 (피트니스 센터)" },
              { id: "outdoor", label: "🌳 야외 / 공원" },
            ].map((env) => (
              <button
                type="button"
                key={env.id}
                onClick={() => setTrainerEnvironment(trainerEnvironment === env.id ? "" : env.id)}
                className={`p-2.5 rounded-xl border text-xs font-bold transition-all cursor-pointer ${
                  trainerEnvironment === env.id
                    ? "bg-emerald-50 border-emerald-500 text-emerald-800"
                    : "bg-white border-gray-200 text-gray-600 hover:bg-gray-50"
                }`}
              >
                {env.label}
              </button>
            ))}
          </div>
        </div>

        {/* 보유 기구 (다중 선택) */}
        <div>
          <label className="font-bold text-gray-700 block mb-1.5">
            보유 기구 (다중 선택):
          </label>
          <div className="grid grid-cols-3 sm:grid-cols-4 gap-2">
            {EQUIPMENT_OPTIONS.map((eq) => {
              const isChecked = trainerEquipment.includes(eq.id);
              return (
                <button
                  type="button"
                  key={eq.id}
                  onClick={() => toggleTrainerEquipment(eq.id)}
                  className={`p-2 rounded-xl border text-xs font-semibold transition-all cursor-pointer flex items-center justify-between ${
                    isChecked
                      ? "bg-emerald-50 border-emerald-500 text-emerald-800"
                      : "bg-white border-gray-200 text-gray-600 hover:bg-gray-50"
                  }`}
                >
                  <span>{eq.label}</span>
                  {isChecked && (
                    <CheckCircle2 className="w-3.5 h-3.5 text-emerald-600" />
                  )}
                </button>
              );
            })}
          </div>
        </div>

        {/* 하루 운동 가능 시간 (10~90분) */}
        <div className="p-3.5 rounded-2xl bg-gray-50 border border-gray-100 space-y-2">
          <div className="flex items-center justify-between">
            <label className="font-bold text-gray-800 flex items-center gap-1.5">
              <Clock className="w-4 h-4 text-emerald-600" />
              하루 운동 가능 시간 (10~90분)
            </label>
            <span className="font-extrabold text-emerald-800 text-sm">
              {trainerAvailableTime === "" ? "미설정" : trainerAvailableTime + "분"}
            </span>
          </div>
          <input
            type="range"
            min="10"
            max="90"
            step="5"
            value={trainerAvailableTime === "" ? 10 : trainerAvailableTime}
            onChange={(e) =>
              setTrainerAvailableTime((e.target.value === "" ? "" : Number(e.target.value)))
            }
            className="w-full accent-emerald-600 cursor-pointer"
          />
          <div className="flex justify-between text-[10px] text-gray-400">
            <span>10분 (가벼운 스트레칭)</span>
            <span>30분 (표준)</span>
            <span>60분 (집중)</span>
            <span>90분 (완전 분할)</span>
          </div>
        </div>

        <button type="button" onClick={() => setTrainerAvailableTime("")} className="text-xs underline">운동 시간 설정 해제</button>

        {/* 통증·부상 부위 (다중 선택) */}
        <div>
          <label className="font-bold text-gray-700 block mb-1.5 flex items-center gap-1 text-amber-900">
            <AlertTriangle className="w-3.5 h-3.5 text-amber-600" />
            통증·부상 부위 (선택):
          </label>
          <div className="flex flex-wrap gap-2">
            {INJURY_AREA_OPTIONS.map((area) => {
              const isSelected = trainerInjuries.includes(area);
              return (
                <button
                  type="button"
                  key={area}
                  onClick={() => toggleTrainerInjury(area)}
                  className={`px-3 py-1.5 rounded-xl border text-xs font-semibold transition-all cursor-pointer ${
                    isSelected
                      ? "bg-amber-100 border-amber-400 text-amber-900 shadow-2xs"
                      : "bg-white border-gray-200 text-gray-600 hover:bg-gray-50"
                  }`}
                >
                  {area} {isSelected && "✓"}
                </button>
              );
            })}
          </div>
        </div>

        {/* 알레르기 & 기피 음식 */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
          <div>
            <label className="font-bold text-gray-700 block mb-1">
              알레르기 유발 식재료 (쉼표 구분)
            </label>
            <input
              type="text"
              placeholder="예: 땅콩, 갑각류, 복숭아, 우유"
              value={trainerAllergiesText}
              onChange={(e) => setTrainerAllergiesText(e.target.value)}
              className="w-full px-3 py-2 rounded-xl border border-gray-300 text-xs focus:outline-emerald-500"
            />
          </div>
          <div>
            <label className="font-bold text-gray-700 block mb-1">
              기피/싫어하는 음식 (쉼표 구분)
            </label>
            <input
              type="text"
              placeholder="예: 오이, 가지, 고수"
              value={trainerDislikedFoodsText}
              onChange={(e) => setTrainerDislikedFoodsText(e.target.value)}
              className="w-full px-3 py-2 rounded-xl border border-gray-300 text-xs focus:outline-emerald-500"
            />
          </div>
        </div>

        {/* 식단 유형 & 한 끼 예산 */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
          <div>
            <label className="font-bold text-gray-700 block mb-1">
              식단 유형
            </label>
            <select
              value={trainerDietType}
              onChange={(e) => setTrainerDietType(e.target.value)}
              className="w-full px-3 py-2 rounded-xl border border-gray-300 text-xs bg-white"
            >
              <option value="">
                선택하세요
              </option>
              {DIET_TYPE_OPTIONS.map((d) => (
                <option key={d.id} value={d.id}>
                  {d.label}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="font-bold text-gray-700 block mb-1">
              한 끼 예산 (원)
            </label>
            <input
              type="number"
              step="1"
              min="1"
              max="2147483647"
              value={trainerBudget}
              onChange={(e) => setTrainerBudget((e.target.value === "" ? "" : Number(e.target.value)))}
              className="w-full px-3 py-2 rounded-xl border border-gray-300 text-xs focus:outline-emerald-500"
            />
          </div>
        </div>
      </div>

      <div className="pt-2">
        <button
          type="submit"
          className="w-full py-3 rounded-2xl bg-emerald-600 hover:bg-emerald-700 text-white font-extrabold text-sm shadow-md shadow-emerald-200 transition-all cursor-pointer min-h-[46px] disabled:opacity-50"
          disabled={isSaving}
        >
          {isSaving ? "저장 중..." : "프로필 저장"}
        </button>
      </div>
    </form>
  )
}
