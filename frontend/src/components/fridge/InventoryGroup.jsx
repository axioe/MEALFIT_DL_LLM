import { useId, useState } from 'react'
import { ChevronDown, TriangleAlert } from 'lucide-react'
import { ExpirationBadge } from '@/components/common/StatusBadge'
import { LotCard } from '@/components/fridge/LotCard'
import { formatQuantity } from '@/lib/format'
import { describeGroup } from '@/models/fridge'

/** 재료·단위 그룹 카드: 합계·사용 가능·기한 경과와 펼쳐 보는 묶음 목록 */
export function InventoryGroup({ group, onEdit, onDispose, onHistory }) {
  const [isExpanded, setIsExpanded] = useState(false)
  const panelId = useId()
  const { activeLots, usableLots, expiredLots, worstStatus, earliestExpiry } = describeGroup(group)

  return (
    <article className="min-w-0 overflow-hidden rounded-2xl border border-gray-200 bg-white">
      <h3>
        <button
          type="button"
          aria-expanded={isExpanded}
          aria-controls={panelId}
          onClick={() => setIsExpanded((expanded) => !expanded)}
          className="flex min-h-11 w-full cursor-pointer items-start gap-3 p-4 text-left transition hover:bg-gray-50 focus-visible:outline-2 focus-visible:outline-offset-[-3px] focus-visible:outline-emerald-600 md:p-5"
        >
          <span className={`flex h-10 w-10 shrink-0 items-center justify-center rounded-xl border text-sm font-bold ${activeLots.length ? 'border-emerald-100 bg-emerald-50 text-emerald-700' : 'border-gray-200 bg-gray-100 text-gray-500'}`}>
            {group.ingredientName.slice(0, 1)}
          </span>
          <span className="min-w-0 flex-1">
            <span className="flex flex-wrap items-baseline gap-x-2 gap-y-1">
              <span className="break-all text-base font-bold text-gray-900">{group.ingredientName}</span>
              <span className="min-w-0 break-all text-sm font-semibold text-gray-700">총 {formatQuantity(group.totalQuantity, group.unit)}</span>
            </span>
            <span className="mt-1 block text-xs font-normal leading-5 text-gray-500">
              {activeLots.length ? `보관 중 ${activeLots.length}개 묶음` : '활성 재고 없음'}

            </span>
            <span className="mt-2 flex flex-wrap items-center gap-2">
              {worstStatus && <ExpirationBadge status={worstStatus} />}
              <span className="text-xs font-normal text-gray-500">
                {earliestExpiry ? `가장 빠른 소비기한 ${earliestExpiry}` : activeLots.length ? '소비기한 미등록' : '보관 기록을 확인해 주세요'}
              </span>
            </span>
          </span>
          <ChevronDown aria-hidden="true" className={`mt-2 h-5 w-5 shrink-0 text-gray-400 transition-transform ${isExpanded ? 'rotate-180' : ''}`} />
        </button>
      </h3>
      <dl className="grid grid-cols-2 gap-3 border-t border-gray-100 px-4 py-3 text-xs md:px-5">
        <div>
          <dt className="text-gray-500">사용 가능</dt>
          <dd className="mt-1 break-all text-sm font-bold text-emerald-700">{formatQuantity(group.availableQuantity, group.unit)}</dd>
        </div>
        <div>
          <dt className="text-gray-500">기한 경과</dt>
          <dd className={`mt-1 break-all text-sm font-bold ${group.expiredQuantity > 0 ? 'text-rose-700' : 'text-gray-600'}`}>{formatQuantity(group.expiredQuantity, group.unit)}</dd>
        </div>
      </dl>
      <div id={panelId} hidden={!isExpanded} className="space-y-4 border-t border-gray-200 bg-gray-50 p-4 md:p-5">
        {usableLots.length > 0 && (
          <section aria-label="보관 중인 묶음">
            <h4 className="mb-2 text-xs font-bold text-gray-700">보관 중인 묶음</h4>
            <ul className="space-y-2">{usableLots.map((lot) => <LotCard key={lot.id} lot={lot} onEdit={onEdit} onDispose={onDispose} onHistory={onHistory} />)}</ul>
          </section>
        )}
        {expiredLots.length > 0 && (
          <section aria-label="소비기한 경과 묶음">
            <h4 className="mb-2 flex items-center gap-1.5 text-xs font-bold text-rose-700">
              <TriangleAlert aria-hidden="true" className="h-4 w-4" />소비기한이 지난 묶음
            </h4>
            <p className="mb-2 text-xs text-rose-700">사용 가능 수량에서 제외된 재고입니다.</p>
            <ul className="space-y-2">{expiredLots.map((lot) => <LotCard key={lot.id} lot={lot} onEdit={onEdit} onDispose={onDispose} onHistory={onHistory} />)}</ul>
          </section>
        )}
      </div>
    </article>
  )
}
