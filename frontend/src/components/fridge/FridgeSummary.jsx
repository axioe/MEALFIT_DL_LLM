/** 현재 조회 조건의 재고 요약 숫자 3개 */
export function FridgeSummary({ activeIngredientCount, activeLotCount, imminentCount }) {
  return (
    <section aria-label="현재 조회 조건의 재고 요약" className="grid grid-cols-3 gap-2 md:gap-4">
      {[
        { label: '보관 재료', count: activeIngredientCount, unit: '종' },
        { label: '활성 묶음', count: activeLotCount, unit: '개' },
        { label: '오늘·임박', count: imminentCount, unit: '개' },
      ].map(({ label, count, unit }) => (
        <div key={label} className="min-w-0 rounded-2xl border border-gray-200 bg-white p-3 md:p-5">
          <p className="text-xs text-gray-500">{label}</p>
          <p className="mt-2 text-2xl font-extrabold text-gray-900">{count}<span className="ml-1 text-sm font-medium text-gray-500">{unit}</span></p>
        </div>
      ))}
    </section>
  )
}
