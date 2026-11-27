import { useEffect, useRef } from 'react'
import { X } from 'lucide-react'
import { MEAL_TYPE_LABEL } from '@/lib/labels'

export function MealConfirmation({ selection, busy, error, onClose, onConfirm }) {
  const dialog = useRef(null)
  const title = selection.action === 'confirm' ? '이 식단으로 결정할까요?' : selection.action === 'cancel' ? '이 식단을 취소할까요?' : '다시 추천받을까요?'
  useEffect(() => { const node = dialog.current; node.showModal(); return () => node.close() }, [])
  return <dialog ref={dialog} aria-label={title} onCancel={(event) => { event.preventDefault(); if (!busy) onClose() }} className="fixed inset-0 m-auto max-h-[90dvh] w-[calc(100%-2rem)] max-w-md overflow-y-auto rounded-2xl border border-gray-200 bg-white p-5 shadow-xl backdrop:bg-black/40">
    <div className="flex items-start justify-between gap-2"><h3 className="font-bold">{title}</h3><button type="button" disabled={busy} onClick={onClose} aria-label="식단 확인 창 닫기" className="btn-secondary min-h-11 px-3"><X aria-hidden="true" className="h-4 w-4" /></button></div>
    {selection.plan && <p className="mt-3 break-all text-sm font-semibold">{MEAL_TYPE_LABEL[selection.plan.mealType]} · {selection.plan.recipe.name}</p>}
    <p className="my-4 text-sm leading-6 text-gray-600">{selection.action === 'confirm' ? '식단을 확정하면 부족한 재료가 장보기 목록에 반영돼요. 냉장고 재고는 요리를 완료했을 때 차감됩니다.' : selection.action === 'cancel' ? '취소한 식단은 되돌릴 수 없으며, 확정 식단의 장보기 부족분은 다시 계산됩니다.' : selection.action === 'regenerate' ? '선택한 끼니만 다시 추천해요. 다른 끼니는 유지됩니다.' : '기존 추천 초안은 취소하고 새 초안을 만듭니다. 이미 확정한 끼니는 유지합니다.'}</p>
    {error && <p role="alert" className="mb-4 whitespace-pre-wrap break-all rounded-xl bg-rose-50 p-3 text-sm text-rose-700">{error}</p>}
    <div className="flex flex-wrap justify-end gap-2"><button type="button" disabled={busy} onClick={onClose} className="btn-secondary min-h-11">돌아가기</button><button type="button" disabled={busy} onClick={onConfirm} className="btn-primary min-h-11">{busy ? '처리 중...' : selection.action === 'confirm' ? '식단 확정' : selection.action === 'cancel' ? '식단 취소' : '추천 실행'}</button></div>
  </dialog>
}
