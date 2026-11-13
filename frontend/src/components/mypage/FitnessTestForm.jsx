import { Scale } from 'lucide-react'

/** 마이페이지 탭: 체력 테스트 측정 (화면만 담당, 상태·저장은 hooks/useMyPageForm) */
export function FitnessTestForm({ form, updateField, onSubmit, isSaving }) {
  const { restingHeartRate, pushups, squat30s, plankSeconds } = form
  const setPlankSeconds = (value) => updateField('plankSeconds', value)
  const setPushups = (value) => updateField('pushups', value)
  const setRestingHeartRate = (value) => updateField('restingHeartRate', value)
  const setSquat30s = (value) => updateField('squat30s', value)

  return (
    <form
      onSubmit={onSubmit}
      className="bg-white rounded-2xl p-6 border border-gray-200 shadow-xs space-y-4 text-xs max-w-2xl"
    >
      <div className="flex items-center gap-2 mb-1">
        <Scale className="w-4 h-4 text-emerald-600" />
        <h4 className="font-bold text-sm text-gray-900">
          기초 체력 테스트 (선택 입력)
        </h4>
      </div>
      <p className="text-gray-500 leading-relaxed">
        측정하기 어려운 항목은 비워두셔도 됩니다. 무리한 측정을 자제하시고
        신체 상태에 맞게 진행하세요.
      </p>

      <div className="grid grid-cols-2 gap-4">
        <div>
          <label className="font-bold text-gray-700 block mb-1">
            안정시 심박수 (bpm)
          </label>
          <input
            type="number"
            placeholder="예: 68"
            min="20" max="250" step="1"
            value={restingHeartRate}
            onChange={(e) =>
              setRestingHeartRate(
                e.target.value === "" ? "" : (e.target.value === "" ? "" : Number(e.target.value)),
              )
            }
            className="w-full px-3 py-2 rounded-xl border border-gray-300 text-sm focus:outline-emerald-500"
          />
        </div>
        <div>
          <label className="font-bold text-gray-700 block mb-1">
            푸시업 (회)
          </label>
          <input
            type="number"
            placeholder="예: 15"
            min="0" max="1000" step="1"
            value={pushups}
            onChange={(e) =>
              setPushups(
                e.target.value === "" ? "" : (e.target.value === "" ? "" : Number(e.target.value)),
              )
            }
            className="w-full px-3 py-2 rounded-xl border border-gray-300 text-sm focus:outline-emerald-500"
          />
        </div>
      </div>

      <div className="grid grid-cols-2 gap-4">
        <div>
          <label className="font-bold text-gray-700 block mb-1">
            30초 의자 스쿼트 (회)
          </label>
          <input
            type="number"
            placeholder="예: 20"
            min="0" max="200" step="1"
            value={squat30s}
            onChange={(e) =>
              setSquat30s(
                e.target.value === "" ? "" : (e.target.value === "" ? "" : Number(e.target.value)),
              )
            }
            className="w-full px-3 py-2 rounded-xl border border-gray-300 text-sm focus:outline-emerald-500"
          />
        </div>
        <div>
          <label className="font-bold text-gray-700 block mb-1">
            플랭크 버티기 (초)
          </label>
          <input
            type="number"
            placeholder="예: 45"
            min="0" max="7200" step="1"
            value={plankSeconds}
            onChange={(e) =>
              setPlankSeconds(
                e.target.value === "" ? "" : (e.target.value === "" ? "" : Number(e.target.value)),
              )
            }
            className="w-full px-3 py-2 rounded-xl border border-gray-300 text-sm focus:outline-emerald-500"
          />
        </div>
      </div>

      <div className="pt-3">
        <button
          type="submit"
          className="w-full py-2.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-sm shadow-xs min-h-[44px] cursor-pointer"
          disabled={isSaving}
        >
          {isSaving ? "저장 중..." : "체력 테스트 저장"}
        </button>
      </div>
    </form>
  )
}
