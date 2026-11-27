import { AlertTriangle, Award, CheckCircle2, Clock, Dumbbell, Target, User } from 'lucide-react'
import { EQUIPMENT_OPTIONS, INJURY_AREA_OPTIONS, WORKOUT_MINUTES_OPTIONS } from '@/lib/profileOptions'
import { toggleExclusiveItem, toggleItem } from '@/models/profileForm'

const WORKOUT_GOALS = [
  { id: 'loss', label: '체중 감량', desc: '체지방 연소' },
  { id: 'hypertrophy', label: '근육 증가', desc: '근비대·근력' },
  { id: 'stamina', label: '체력 향상', desc: '지구력 증진' },
  { id: 'health', label: '건강 유지', desc: '체형·활력' },
]

const WORKOUT_LEVELS = [
  { id: 'starter', label: '입문', desc: '초보/오랜만' },
  { id: 'beginner', label: '초급', desc: '3~6개월 기본' },
  { id: 'intermediate', label: '중급', desc: '1년+ 규칙적' },
  { id: 'advanced', label: '고급', desc: '분할/고강도' },
]

const WORKOUT_ENVIRONMENTS = [
  { id: 'home', label: '🏠 홈트' },
  { id: 'gym', label: '🏋️ 헬스장' },
  { id: 'outdoor', label: '🌳 야외·공원' },
]

/** [마이페이지통합] 카드 1: 내 프로필 · 신체 기본 정보 · 운동 조건 통합 카드 */
export function BodyFitnessCard({ form, updateField, onSubmit, isSaving, status }) {
  const {
    nickname, age, gender, height, currentWeight, targetWeight, activityLevel,
    fitnessGoal, experience, daysPerWeek, durationMinutes, environment, equipment, fitnessInjuries,
  } = form

  const toggleEquipment = (eq) => updateField('equipment', (previous) => toggleExclusiveItem(previous, eq))
  const toggleInjury = (area) => updateField('fitnessInjuries', (previous) => toggleItem(previous, area))
  const inputClass = 'w-full px-3 py-2 rounded-xl border border-gray-300 text-sm bg-white focus:outline-emerald-500'

  return (
    <section id="section-body-fitness" className="scroll-mt-24">
      <form
        onSubmit={onSubmit}
        className="bg-white rounded-2xl p-6 border border-gray-200 shadow-xs space-y-5 text-xs w-full"
      >
        <div className="flex items-center justify-between pb-3 border-b border-gray-100">
          <div>
            <span className="inline-flex items-center gap-1 text-[11px] font-bold px-2 py-0.5 rounded-md bg-emerald-100 text-emerald-800 mb-1">
              <User className="w-3.5 h-3.5" />
              기본 · 신체 · 운동 설정
            </span>
            <h3 className="font-extrabold text-base text-gray-900">
              내 프로필과 운동 조건
            </h3>
          </div>
          <div className="w-10 h-10 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center shrink-0">
            <Dumbbell className="w-5 h-5" />
          </div>
        </div>

        <fieldset disabled={isSaving} className="space-y-5 min-w-0 disabled:opacity-70">
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
          {/* 1-1. 기본 · 신체 정보 + 통증·부상 부위 (좌측 5칸) */}
          <div className="lg:col-span-5 space-y-4">
            <h4 className="font-bold text-xs text-emerald-800 tracking-wide">기본 · 신체 정보</h4>

            <div>
              <label htmlFor="mp-nickname" className="font-bold text-gray-700 block mb-1">
                닉네임 *
              </label>
              <input
                id="mp-nickname"
                type="text"
                required
                maxLength={50}
                value={nickname}
                onChange={(e) => updateField('nickname', e.target.value)}
                className={inputClass}
              />
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
              <div>
                <label htmlFor="mp-age" className="font-bold text-gray-700 block mb-1">
                  나이 (만 18~80세) *
                </label>
                <input
                  id="mp-age"
                  type="number"
                  min="18"
                  max="80"
                  required
                  value={age}
                  onChange={(e) => updateField('age', e.target.value === '' ? '' : Number(e.target.value))}
                  className={inputClass}
                />
              </div>
              <div>
                <label htmlFor="mp-gender" className="font-bold text-gray-700 block mb-1">성별</label>
                <select
                  id="mp-gender"
                  value={gender}
                  onChange={(e) => updateField('gender', e.target.value)}
                  className={inputClass}
                >
                  <option value="">선택하세요</option>
                  <option value="male">남성</option>
                  <option value="female">여성</option>
                  <option value="unspecified">응답 안 함</option>
                </select>
              </div>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
              <div>
                <label htmlFor="mp-height" className="font-bold text-gray-700 block mb-1">
                  키 (cm) *
                </label>
                <input
                  id="mp-height"
                  type="number"
                  step="0.1"
                  min="100"
                  max="240"
                  required
                  value={height}
                  onChange={(e) => updateField('height', e.target.value === '' ? '' : Number(e.target.value))}
                  className={inputClass}
                />
              </div>
              <div>
                <label htmlFor="mp-weight" className="font-bold text-gray-700 block mb-1">
                  현재 체중 (kg) *
                </label>
                <input
                  id="mp-weight"
                  type="number"
                  step="0.1"
                  min="30"
                  max="250"
                  required
                  value={currentWeight}
                  onChange={(e) => updateField('currentWeight', e.target.value === '' ? '' : Number(e.target.value))}
                  className={inputClass}
                />
              </div>
              <div>
                <label htmlFor="mp-target-weight" className="font-bold text-gray-700 block mb-1">
                  목표 체중 (kg) *
                </label>
                <input
                  id="mp-target-weight"
                  type="number"
                  step="0.1"
                  min="30"
                  max="250"
                  required
                  value={targetWeight}
                  onChange={(e) => updateField('targetWeight', e.target.value === '' ? '' : Number(e.target.value))}
                  className={inputClass}
                />
              </div>
            </div>

            <div>
              <label htmlFor="mp-activity" className="font-bold text-gray-700 block mb-1">
                평소 활동량
              </label>
              <select
                id="mp-activity"
                value={activityLevel}
                onChange={(e) => updateField('activityLevel', e.target.value)}
                className={inputClass}
              >
                <option value="">선택하세요</option>
                <option value="sedentary">좌식 위주 (사무직, 운동 거의 안 함)</option>
                <option value="light">가벼운 활동 (주 1~2회 가벼운 산책/운동)</option>
                <option value="moderate">보통 활동 (주 3~4회 규칙적 운동)</option>
                <option value="active">활동적 (주 5회 이상 강도 높은 운동)</option>
              </select>
            </div>

            {/* [운동조건설정] D3 합의 기준: 통증·부상 부위 7종 (신체 정보와 함께 좌측 배치해 좌우 균형 맞춤) */}
            <div className="pt-3 border-t border-gray-100">
              <span className="font-bold text-amber-900 mb-2 flex items-center gap-1">
                <AlertTriangle className="w-3.5 h-3.5 text-amber-600" />
                통증·부상 부위 (선택)
              </span>
              <div className="flex flex-wrap gap-2">
                {INJURY_AREA_OPTIONS.map((area) => {
                  const isSelected = fitnessInjuries.includes(area)
                  return (
                    <button
                      type="button"
                      key={area}
                      onClick={() => toggleInjury(area)}
                      className={`px-3 py-1.5 rounded-xl border text-xs font-semibold transition-all cursor-pointer ${
                        isSelected
                          ? 'bg-amber-100 border-amber-400 text-amber-900 shadow-2xs'
                          : 'bg-white border-gray-200 text-gray-600 hover:bg-gray-50'
                      }`}
                    >
                      {area} {isSelected && '✓'}
                    </button>
                  )
                })}
              </div>
            </div>
          </div>

          {/* 1-2. 운동 목표 · 환경 · 조건 (우측 7칸) */}
          <div className="lg:col-span-7 space-y-4 pt-5 border-t border-gray-100 lg:pt-0 lg:border-t-0 lg:border-l lg:pl-6">
            <h4 className="font-bold text-xs text-emerald-800 tracking-wide">운동 목표 · 환경 · 조건</h4>

            <div>
              <span className="font-bold text-gray-800 mb-1.5 flex items-center gap-1">
                <Target className="w-3.5 h-3.5 text-emerald-600" />
                운동 목적
              </span>
              <div className="grid grid-cols-2 sm:grid-cols-4 gap-2">
                {WORKOUT_GOALS.map((item) => {
                  const active = fitnessGoal === item.id
                  return (
                    <button
                      type="button"
                      key={item.id}
                      onClick={() => updateField('fitnessGoal', active ? '' : item.id)}
                      className={`p-2.5 rounded-xl border text-left transition-all cursor-pointer ${
                        active
                          ? 'bg-emerald-600 text-white border-emerald-600 shadow-xs'
                          : 'bg-white border-gray-200 text-gray-700 hover:bg-gray-50'
                      }`}
                    >
                      <span className="font-bold text-xs block">{item.label}</span>
                      <span className={`text-[10px] block truncate ${active ? 'text-emerald-100' : 'text-gray-400'}`}>
                        {item.desc}
                      </span>
                    </button>
                  )
                })}
              </div>
            </div>

            <div>
              <span className="font-bold text-gray-800 mb-1.5 flex items-center gap-1">
                <Award className="w-3.5 h-3.5 text-teal-600" />
                운동 수준
              </span>
              <div className="grid grid-cols-2 sm:grid-cols-4 gap-2">
                {WORKOUT_LEVELS.map((item) => {
                  const active = experience === item.id
                  return (
                    <button
                      type="button"
                      key={item.id}
                      onClick={() => updateField('experience', active ? '' : item.id)}
                      className={`p-2.5 rounded-xl border text-left transition-all cursor-pointer ${
                        active
                          ? 'bg-teal-600 text-white border-teal-600 shadow-xs'
                          : 'bg-white border-gray-200 text-gray-700 hover:bg-gray-50'
                      }`}
                    >
                      <span className="font-bold text-xs block">{item.label}</span>
                      <span className={`text-[10px] block truncate ${active ? 'text-teal-100' : 'text-gray-400'}`}>
                        {item.desc}
                      </span>
                    </button>
                  )
                })}
              </div>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-12 gap-3">
              <div className="sm:col-span-4">
                <label htmlFor="mp-days-per-week" className="font-bold text-gray-700 block mb-1">
                  주당 운동 일수 (2~6일)
                </label>
                <input
                  id="mp-days-per-week"
                  type="number"
                  min="2"
                  max="6"
                  value={daysPerWeek}
                  onChange={(e) => updateField('daysPerWeek', e.target.value === '' ? '' : Number(e.target.value))}
                  className={inputClass}
                />
              </div>
              <div className="sm:col-span-8">
                <span className="font-bold text-gray-700 block mb-1">운동 환경</span>
                <div className="grid grid-cols-3 gap-2">
                  {WORKOUT_ENVIRONMENTS.map((env) => {
                    const active = environment === env.id
                    return (
                      <button
                        type="button"
                        key={env.id}
                        onClick={() => updateField('environment', active ? '' : env.id)}
                        className={`px-2.5 py-2 rounded-xl border text-xs font-bold whitespace-nowrap transition-all cursor-pointer ${
                          active
                            ? 'bg-emerald-50 border-emerald-500 text-emerald-800'
                            : 'bg-white border-gray-200 text-gray-600 hover:bg-gray-50'
                        }`}
                      >
                        {env.label}
                      </button>
                    )
                  })}
                </div>
              </div>
            </div>

            {/* [운동조건설정] D1 합의 기준: 1회 운동 시간 15/30/45/60분 */}
            <div className="p-3.5 rounded-2xl bg-gray-50 border border-gray-100 space-y-2.5">
              <div className="flex items-center justify-between">
                <span className="font-bold text-gray-800 flex items-center gap-1.5">
                  <Clock className="w-4 h-4 text-emerald-600" />
                  1회 운동 시간 (15·30·45·60분)
                </span>
                {durationMinutes !== '' && (
                  <button
                    type="button"
                    onClick={() => updateField('durationMinutes', '')}
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
                      onClick={() => updateField('durationMinutes', isSelected ? '' : opt.value)}
                      className={`p-2 rounded-xl border text-center transition-all cursor-pointer ${
                        isSelected
                          ? 'bg-emerald-600 text-white border-emerald-600 shadow-xs'
                          : 'bg-white border-gray-200 text-gray-700 hover:bg-gray-50'
                      }`}
                    >
                      <span className="font-bold text-xs block">{opt.label}</span>
                      <span className={`text-[10px] block ${isSelected ? 'text-emerald-100' : 'text-gray-400'}`}>
                        {opt.desc}
                      </span>
                    </button>
                  )
                })}
              </div>
            </div>

            {/* 보유 기구 (바벨 포함, 다중 선택) */}
            <div>
              <span className="font-bold text-gray-700 block mb-1.5">보유 기구 (다중 선택)</span>
              <div className="grid grid-cols-2 sm:grid-cols-4 gap-2">
                {EQUIPMENT_OPTIONS.map((eq) => {
                  const isChecked = equipment.includes(eq.id)
                  return (
                    <button
                      type="button"
                      key={eq.id}
                      onClick={() => toggleEquipment(eq.id)}
                      className={`p-2 rounded-xl border text-xs font-semibold whitespace-nowrap transition-all cursor-pointer flex items-center justify-between ${
                        isChecked
                          ? 'bg-emerald-50 border-emerald-500 text-emerald-800'
                          : 'bg-white border-gray-200 text-gray-600 hover:bg-gray-50'
                      }`}
                    >
                      <span>{eq.label}</span>
                      {isChecked && <CheckCircle2 className="w-3.5 h-3.5 text-emerald-600 shrink-0" />}
                    </button>
                  )
                })}
              </div>
            </div>
          </div>
          </div>

          <div className="pt-2 border-t border-gray-100 flex justify-end">
            <button
              type="submit"
              disabled={isSaving}
              className="w-full sm:w-auto sm:min-w-[220px] px-6 py-3 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-sm shadow-xs min-h-[44px] cursor-pointer disabled:opacity-50"
            >
              {isSaving ? '저장 중...' : '신체 · 운동 설정 저장'}
            </button>
          </div>
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
    </section>
  )
}
