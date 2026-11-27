import { inventoryProductLabel } from '@/models/inventoryMemo'
import { useEffect, useId, useRef } from 'react'
import { X } from 'lucide-react'
import { useReceiptRecognition } from '@/hooks/useReceiptRecognition'
import { STOCK_IN_UNITS } from '@/models/inventoryForm'
import { STORAGE_LOCATION } from '@/lib/enums'
import { STORAGE_LABEL } from '@/lib/labels'

// 영수증 사진·품목 확인·확정 입고를 한 대화상자에서 구분해 표시함
export function ReceiptRecognitionDialog({ onClose }) {
  const ref = useRef(null)
  const id = useId()
  const receipt = useReceiptRecognition()
  useEffect(() => { const dialog = ref.current; dialog.showModal(); return () => dialog.close() }, [])
  const locked = receipt.busy || Boolean(receipt.pending)
  return <dialog ref={ref} aria-labelledby={`${id}-title`}
    onCancel={event => { event.preventDefault(); if (!receipt.saving) onClose() }}
    className="fixed inset-0 m-auto max-h-[90dvh] w-[calc(100%-1rem)] max-w-3xl overflow-y-auto rounded-2xl border border-gray-200 bg-white p-4 text-gray-900 shadow-xl backdrop:bg-black/40 md:p-6">
    <div className="mb-4 flex items-center justify-between gap-3"><h2 id={`${id}-title`} className="font-bold">영수증으로 등록</h2>
      <button type="button" onClick={onClose} disabled={receipt.saving} aria-label="영수증 등록 닫기" className="btn-secondary min-h-11"><X className="h-4 w-4" /></button></div>
    <p className="mb-4 text-sm leading-6 text-gray-600">영수증은 메모리에서만 분석합니다. 알려진 식재료만 후보로 표시하며, 확인 후 선택한 품목만 등록됩니다. 카드·회원 정보는 가리고 촬영해 주세요.</p>
    {receipt.pending && !receipt.saving && <p role="status" className="mb-3 rounded-xl bg-amber-50 p-3 text-sm">이전 저장 결과 확인이 필요합니다. 품목을 바꾸지 않고 같은 요청으로 다시 확인합니다. 새로고침 후에도 이 요청을 복원합니다.</p>}
    <label className="label" htmlFor={`${id}-image`}>영수증 JPEG·PNG (10MiB 이하)</label>
    <input id={`${id}-image`} type="file" accept="image/jpeg,image/png" capture="environment" disabled={locked}
      onChange={event => { const file = event.target.files?.[0]; event.target.value = ''; void receipt.select(file) }} className="input min-h-11 w-full max-w-full text-sm" />
    {receipt.selection && <p role="status" className="mt-2 text-xs text-emerald-700">영수증 사진 선택 완료 · 아래에서 분석할 수 있습니다.</p>}
    {receipt.selection && <img src={receipt.selection.preview} alt="선택한 영수증 미리보기" className="mt-3 max-h-64 w-full rounded-xl bg-gray-50 object-contain" />}
    <button type="button" onClick={receipt.recognize} disabled={!receipt.selection || locked} className="btn-primary mt-3 min-h-11 w-full">{receipt.busy && !receipt.saving ? '영수증 확인 중...' : '영수증 분석하기'}</button>
    {receipt.error && <p role="alert" className="mt-3 whitespace-pre-wrap break-words rounded-xl bg-rose-50 p-3 text-sm text-rose-800">{receipt.error}</p>}
    {receipt.message && <p role="status" className="mt-3 rounded-xl bg-emerald-50 p-3 text-sm">{receipt.message}</p>}
    {receipt.savedLots.length > 0 && <ul className="mt-3 space-y-1 rounded-xl bg-emerald-50 p-3 text-sm" aria-label="품목별 입고 결과">
      {receipt.savedLots.map(lot => <li key={lot.id} className="break-words">{inventoryProductLabel(lot)} · {lot.quantity}{lot.unit} · 저장 완료</li>)}
    </ul>}
    {receipt.info && <div className="my-4 text-sm leading-6"><p>구매일: {receipt.info.purchaseDate ?? '확인되지 않음'}</p>
      <p>{receipt.info.status === 'SUCCESS' ? '모든 품목은 사용자 확인이 필요합니다.' : '품목을 찾지 못했습니다. 선명하게 다시 촬영하거나 직접 추가해 주세요.'}</p>
      <p className="text-xs text-gray-500">UNMAPPED는 식재료 ID 미연결 상태입니다. 규격·구매 수량이 명확한 조합만 계산한 제안이며 직접 확인해야 합니다. 누락된 품목·할인·반품을 직접 확인해 주세요.</p></div>}
    <div className="mt-4 space-y-4">{receipt.rows.map((row, index) => <fieldset key={row.id} disabled={locked} className="min-w-0 rounded-xl border border-amber-200 p-3">
      <legend className="px-1 text-sm font-semibold">품목 {index + 1} · {row.ingredientName ? '확인 필요' : '식재료명 미확인 · 직접 입력 필요'}</legend>
      <label className="flex min-h-11 items-center gap-2 text-sm"><input type="checkbox" checked={row.selected} onChange={e => receipt.update(row.id, 'selected', e.target.checked)} />이 품목 등록</label>
      <div className="grid min-w-0 grid-cols-1 gap-3 sm:grid-cols-2">
        <label className="text-sm">추가 상품 정보 (괄호 표시용)<input className="input mt-1 w-full" value={row.productName} maxLength={100} onChange={e => receipt.update(row.id, 'productName', e.target.value)} /></label>
        <label className="text-sm">표준 식재료명 *<input className="input mt-1 w-full" value={row.ingredientName} maxLength={100} onChange={e => receipt.update(row.id, 'ingredientName', e.target.value)} /></label>
        <label className="text-sm">실제 입고 수량 *<input className="input mt-1 w-full" inputMode="decimal" value={row.quantity} onChange={e => receipt.update(row.id, 'quantity', e.target.value)} /></label>
        <label className="text-sm">입고 단위 *<select className="input mt-1 w-full" value={row.unit} onChange={e => receipt.update(row.id, 'unit', e.target.value)}><option value="">직접 확인 후 선택</option>{STOCK_IN_UNITS.map(unit => <option key={unit}>{unit}</option>)}</select></label>
        <label className="text-sm">보관 위치 *<select className="input mt-1 w-full" value={row.storageLocation} onChange={e => receipt.update(row.id, 'storageLocation', e.target.value)}>{Object.values(STORAGE_LOCATION).map(value => <option key={value} value={value}>{STORAGE_LABEL[value]}</option>)}</select></label>
        <label className="text-sm">소비기한 (비워 두기 가능)<input className="input mt-1 w-full" type="date" value={row.expiryDate} onChange={e => receipt.update(row.id, 'expiryDate', e.target.value)} /></label>
        <label className="text-sm">상품 표시 중량·용량 (참고)<input className="input mt-1 w-full" value={row.netQuantity} inputMode="decimal" onChange={e => receipt.update(row.id, 'netQuantity', e.target.value)} placeholder={row.netUnit || '표시된 값만 입력'} /></label>
        <label className="text-sm">최소 유지량 (선택)<input className="input mt-1 w-full" value={row.minStockQty} inputMode="decimal" onChange={e => receipt.update(row.id, 'minStockQty', e.target.value)} /></label>
        <label className="text-sm sm:col-span-2">사용자 메모 (선택)<textarea className="input mt-1 w-full" value={row.memo} maxLength={255} onChange={e => receipt.update(row.id, 'memo', e.target.value)} /></label>
      </div>
      <p className="mt-2 break-words text-sm font-semibold">{row.ingredientName || '식재료명 미입력'}{row.productName ? ` (${row.productName})` : ''} — {row.quantity || '수량 확인 필요'}{row.unit}</p>
      <p className="mt-2 text-xs text-amber-800">{row.quantityStatus === 'PROPOSED' ? '규칙으로 계산한 수량 제안 · 최종 확인 필요' : '구매 수량·총량이 불확실하거나 수동 입력한 품목입니다.'}</p>
      <p className="mt-1 text-xs text-gray-500">포장당 개수: {row.packageCount ?? '미확인'} · 구매 묶음: {row.purchaseQuantity ?? '미확인'}{row.purchaseUnit ?? ''}</p>
      <p className="mt-2 text-xs leading-5 text-gray-500">표시 중량 단위: {row.netUnit || '미확인'} · 금액: {row.price ?? '미확인'} · 문자 신뢰도: {row.textConfidence == null ? '수동 입력' : `${Math.round(row.textConfidence * 100)}%`} (상품·수량 정답 확률이 아님)</p>
    </fieldset>)}</div>
    <p className="mt-3 text-xs leading-5 text-gray-500">표준 사전에 없는 이름은 레시피 재료·재고 묶음과 일치하지 않을 수 있습니다. UNMAPPED는 표준 DB ID가 연결되지 않은 후보이며 자동 매핑을 보장하지 않습니다. 추가 상품 정보와 메모는 저장 표식을 포함해 255자 이내로 보존됩니다.</p>
    <button type="button" onClick={receipt.add} disabled={locked || receipt.rows.length >= 50} className="btn-secondary my-3 min-h-11">누락 품목 직접 추가</button>
    <label className="mb-3 flex min-h-11 items-center gap-2 text-sm"><input type="checkbox" checked={receipt.confirmed} disabled={locked} onChange={e => receipt.setConfirmed(e.target.checked)} />선택한 품목의 이름·수량·단위·기한을 확인했습니다.</label>
    <button type="button" onClick={receipt.submit} disabled={receipt.busy || (!receipt.pending && (!receipt.confirmed || !receipt.rows.some(row => row.selected)))} className="btn-primary min-h-11 w-full">{receipt.saving ? '입고 확인 중...' : receipt.pending ? '같은 요청으로 저장 결과 확인' : '선택 품목 한 번에 입고'}</button>
    <p className="mt-2 text-xs leading-5 text-gray-500">하나라도 실패하면 전체 입고가 취소됩니다. 저장 응답이 끊겨도 같은 요청으로 확인하여 중복 입고를 방지합니다.</p>
  </dialog>
}
