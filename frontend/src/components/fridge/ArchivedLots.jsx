import { LotCard } from '@/components/fridge/LotCard'

/** 소진·폐기된 묶음 기록 (접어 두는 영역) */
export function ArchivedLots({ groups, count, onHistory }) {
  return (
    <details className="rounded-2xl border border-gray-200 bg-white p-4 md:p-5">
      <summary className="min-h-11 cursor-pointer content-center text-sm font-semibold text-gray-600">소진·폐기 기록 보기 ({count}개 묶음)</summary>
      <p className="mt-2 text-xs text-gray-500">현재 검색·보관 필터에 맞는 기록입니다. 기본 재고와 합계에는 포함되지 않습니다.</p>
      {groups.length === 0 ? <p className="py-6 text-sm text-gray-500">조건에 맞는 소진·폐기 기록이 없습니다.</p> : (
        <div className="mt-4 space-y-4">{groups.map((group) => (
          <section key={JSON.stringify([group.ingredientName, group.unit])} aria-label={`${group.ingredientName} ${group.unit} 소진·폐기 기록`}>
            <h3 className="mb-2 break-all text-sm font-bold text-gray-700">{group.ingredientName} <span className="font-normal text-gray-500">({group.unit})</span></h3>
            <ul className="space-y-2">{group.lots.map((lot) => <LotCard key={lot.id} lot={lot} inactive onHistory={onHistory} />)}</ul>
          </section>
        ))}</div>
      )}
    </details>
  )
}
