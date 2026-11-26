import { CheckCircle2, CircleAlert, RotateCcw } from 'lucide-react'

const TONE_STYLE = {
  good: { box: 'border-emerald-200 bg-emerald-50/60', count: 'text-emerald-800', Icon: CheckCircle2, icon: 'text-emerald-600' },
  mixed: { box: 'border-amber-200 bg-amber-50/60', count: 'text-amber-800', Icon: CircleAlert, icon: 'text-amber-600' },
  check: { box: 'border-rose-200 bg-rose-50/60', count: 'text-rose-800', Icon: CircleAlert, icon: 'text-rose-600' },
}

// [자세판별] 판정 결과 표시. 모든 판정은 참고용이다 (D20).
export function PoseResult({ result }) {
  if (result.retake) {
    return (
      <div role="status" className="mt-5 flex items-start gap-2 rounded-xl border border-amber-200 bg-amber-50 p-4 text-sm text-amber-900">
        <RotateCcw aria-hidden="true" className="mt-0.5 h-4 w-4 shrink-0 text-amber-600" />
        <p className="leading-6">{result.message}</p>
      </div>
    )
  }
  return (
    <section aria-label="자세 판정 결과" className="mt-5 space-y-3">
      <div className="flex flex-wrap items-baseline justify-between gap-2">
        <h4 className="text-sm font-bold text-gray-900">{result.exercise} · 반복 {result.repCount}회 <span className="ml-1 rounded-md bg-gray-100 px-1.5 py-0.5 text-[11px] font-semibold text-gray-600">참고</span></h4>
        <span className="text-xs text-gray-500">조건별 올바른 반복 수</span>
      </div>
      <ul className="space-y-2">
        {result.conditions.map((item) => {
          const style = TONE_STYLE[item.tone]
          return (
            <li key={item.name} className={`rounded-xl border p-3 ${style.box}`}>
              <div className="flex items-start justify-between gap-3">
                <span className="flex min-w-0 items-start gap-2 text-sm font-semibold text-gray-900">
                  <style.Icon aria-hidden="true" className={`mt-0.5 h-4 w-4 shrink-0 ${style.icon}`} />
                  <span className="break-words">{item.name}</span>
                </span>
                <span className={`shrink-0 text-sm font-bold ${style.count}`}>{item.correctReps}/{item.totalReps}회</span>
              </div>
              <p className="mt-1 pl-6 text-xs leading-5 text-gray-700">{item.feedback}</p>
              <p className="mt-0.5 pl-6 text-[11px] text-gray-500">모델 {item.accuracy}</p>
            </li>
          )
        })}
      </ul>
    </section>
  )
}
