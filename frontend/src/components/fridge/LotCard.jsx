import { ExpirationBadge } from '@/components/common/StatusBadge'
import { LOT_STATUS } from '@/lib/enums'
import { formatQuantity } from '@/lib/format'
import { LOT_STATUS_LABEL, STORAGE_LABEL } from '@/lib/labels'

/** 재고 묶음 하나: 수량·보관 위치·상태·기한과 수정·폐기·이력 버튼 */
export function LotCard({ lot, inactive = false, onEdit, onDispose, onHistory }) {
  return (
    <li className={`min-w-0 rounded-xl border p-4 ${inactive ? 'border-gray-200 bg-gray-100/70' : 'border-gray-200 bg-white'}`}>
      <div className="flex flex-wrap items-center gap-2">
        <span className={`min-w-0 break-all text-base font-bold ${inactive ? 'text-gray-500' : 'text-gray-900'}`}>
          {formatQuantity(lot.quantity, lot.unit)}
        </span>
        <span className="rounded-full bg-gray-100 px-2.5 py-1 text-xs font-medium text-gray-600">
          {STORAGE_LABEL[lot.storageLocation]}
        </span>
        <span className={`rounded-full px-2.5 py-1 text-xs font-semibold ${inactive ? 'bg-gray-200 text-gray-600' : 'bg-emerald-50 text-emerald-700'}`}>
          {LOT_STATUS_LABEL[lot.status]}
        </span>
      </div>
      <dl className="mt-3 grid gap-2 text-xs text-gray-500 sm:grid-cols-2">
        <div className="flex flex-wrap items-center gap-2">
          <dt>소비기한</dt>
          <dd className="min-w-0">
            <ExpirationBadge status={lot.expirationStatus} date={lot.expiryDate} />
          </dd>
        </div>
        <div className="flex items-center gap-2">
          <dt>최소 유지량</dt>
          <dd className="min-w-0 break-all text-gray-700">{formatQuantity(lot.minStockQty, lot.unit)}</dd>
        </div>
        <div className="flex items-center gap-2">
          <dt>묶음 번호</dt>
          <dd>#{lot.id}</dd>
        </div>
        {lot.memo && (
          <div className="min-w-0 sm:col-span-2">
            <dt className="sr-only">메모</dt>
            <dd className="whitespace-pre-wrap break-all text-gray-600">{lot.memo}</dd>
          </div>
        )}
      </dl>
      <div className="mt-3 flex flex-wrap gap-2 border-t border-gray-100 pt-3">
        {!inactive && lot.status === LOT_STATUS.ACTIVE && <>
          <button type="button" onClick={() => onEdit(lot)} className="btn-secondary min-h-11 text-xs">수정</button>
          <button type="button" onClick={() => onDispose(lot)} className="min-h-11 cursor-pointer rounded-xl border border-rose-200 bg-rose-50 px-3.5 py-2.5 text-xs font-semibold text-rose-700 hover:bg-rose-100">폐기</button>
        </>}
        <button type="button" onClick={() => onHistory(lot.id)} className="btn-secondary min-h-11 text-xs">이 묶음 이력</button>
      </div>
    </li>
  )
}
