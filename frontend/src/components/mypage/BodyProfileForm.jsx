
/** 마이페이지 탭: 신체 기본 정보 (화면만 담당, 상태·저장은 hooks/useMyPageForm) */
export function BodyProfileForm({ form, updateField, onSubmit, isSaving }) {
  const { nickname, age, height, currentWeight, targetWeight, gender, activityLevel } = form
  const setActivityLevel = (value) => updateField('activityLevel', value)
  const setAge = (value) => updateField('age', value)
  const setCurrentWeight = (value) => updateField('currentWeight', value)
  const setGender = (value) => updateField('gender', value)
  const setHeight = (value) => updateField('height', value)
  const setNickname = (value) => updateField('nickname', value)
  const setTargetWeight = (value) => updateField('targetWeight', value)

  return (
    <form
      onSubmit={onSubmit}
      className="bg-white rounded-2xl p-6 border border-gray-200 shadow-xs space-y-4 text-xs max-w-2xl"
    >
      <h4 className="font-bold text-sm text-gray-900 mb-2">
        신체 기본 프로필 (식단·운동 공유)
      </h4>

      <div>
        <label className="font-bold text-gray-700 block mb-1">
          닉네임 *
        </label>
        <input
          type="text"
          required
          maxLength={50}
          value={nickname}
          onChange={(e) => setNickname(e.target.value)}
          className="w-full px-3 py-2 rounded-xl border border-gray-300 text-sm focus:outline-emerald-500"
        />
      </div>

      <div className="grid grid-cols-2 gap-4">
        <div>
          <label className="font-bold text-gray-700 block mb-1">
            나이 (만 18~80세) *
          </label>
          <input
            type="number"
            min="18"
            max="80"
            required
            value={age}
            onChange={(e) => setAge((e.target.value === "" ? "" : Number(e.target.value)))}
            className="w-full px-3 py-2 rounded-xl border border-gray-300 text-sm focus:outline-emerald-500"
          />
        </div>
        <div>
          <label className="font-bold text-gray-700 block mb-1">성별</label>
          <select
            value={gender}
            onChange={(e) => setGender(e.target.value)}
            className="w-full px-3 py-2 rounded-xl border border-gray-300 text-sm bg-white"
          >
            <option value="">
              선택하세요
            </option>
            <option value="male">남성</option>
            <option value="female">여성</option>
            <option value="unspecified">응답 안 함</option>
          </select>
        </div>
      </div>

      <div className="grid grid-cols-3 gap-3">
        <div>
          <label className="font-bold text-gray-700 block mb-1">
            키 (cm) *
          </label>
          <input
            type="number"
            step="0.1"
            min="100"
            max="240"
            required
            value={height}
            onChange={(e) => setHeight((e.target.value === "" ? "" : Number(e.target.value)))}
            className="w-full px-3 py-2 rounded-xl border border-gray-300 text-sm focus:outline-emerald-500"
          />
        </div>
        <div>
          <label className="font-bold text-gray-700 block mb-1">
            현재 체중 (kg) *
          </label>
          <input
            type="number"
            step="0.1"
            min="30"
            max="250"
            required
            value={currentWeight}
            onChange={(e) => setCurrentWeight((e.target.value === "" ? "" : Number(e.target.value)))}
            className="w-full px-3 py-2 rounded-xl border border-gray-300 text-sm focus:outline-emerald-500"
          />
        </div>
        <div>
          <label className="font-bold text-gray-700 block mb-1">
            목표 체중 (kg) *
          </label>
          <input
            type="number"
            step="0.1"
            min="30"
            max="250"
            required
            value={targetWeight}
            onChange={(e) => setTargetWeight((e.target.value === "" ? "" : Number(e.target.value)))}
            className="w-full px-3 py-2 rounded-xl border border-gray-300 text-sm focus:outline-emerald-500"
          />
        </div>
      </div>

      <div>
        <label className="font-bold text-gray-700 block mb-1">
          평소 활동량
        </label>
        <select
          value={activityLevel}
          onChange={(e) => setActivityLevel(e.target.value)}
          className="w-full px-3 py-2 rounded-xl border border-gray-300 text-sm bg-white"
        >
          <option value="">
            선택하세요
          </option>
          <option value="sedentary">
            거의 앉아서 생활 (운동 거의 안 함)
          </option>
          <option value="light">가벼운 활동 (주 1~2회 가벼운 운동)</option>
          <option value="moderate">보통 활동 (주 3~5회 보통 운동)</option>
          <option value="active">
            활동적인 생활 (주 6~7회 격렬한 운동)
          </option>
          <option value="very_active">
            매우 많은 활동량 (육체 노동 또는 전문 운동)
          </option>
        </select>
      </div>

      <div className="pt-3">
        <button
          type="submit"
          className="w-full py-2.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-sm shadow-xs min-h-[44px] cursor-pointer"
          disabled={isSaving}
        >
          {isSaving ? "저장 중..." : "신체 정보 저장"}
        </button>
      </div>
    </form>
  )
}
