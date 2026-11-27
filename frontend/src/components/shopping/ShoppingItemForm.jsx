import { useId, useRef, useState } from 'react'
import { getErrorMessage } from '@/api/client'
import { useShoppingAction } from '@/hooks/useShopping'
import { buildPurchase, buildStockIn } from '@/models/shoppingValidation'
import { STORAGE_LOCATION } from '@/lib/enums'
import { STORAGE_LABEL } from '@/lib/labels'

export function ShoppingItemForm({ item, mode, disabled, onBusy, onReview, onSuccess }) {
  const lock = useRef(false)
  const id = useId()
  const mutation = useShoppingAction()
  const stockIn = mode === 'stockIn'
  const [form, setForm] = useState({ quantity: stockIn ? String(item.purchasedQty) : '',
    storageLocation: STORAGE_LOCATION.FRIDGE, expiryDate: '', minStockQty: '0' })
  const [error, setError] = useState('')
  const [uncertain, setUncertain] = useState(false)
  function change(event) {
    const { name, value } = event.target
    setForm((old) => ({ ...old, [name]: value }))
    setError('')
  }
  async function submit(event) {
    event.preventDefault()
    if (lock.current || uncertain || disabled) return
    let body
    try { body = stockIn ? buildStockIn(item, form) : buildPurchase(item, form.quantity) }
    catch (failure) { setError(failure.message); return }
    lock.current = true
    onBusy(true)
    try {
      await mutation.mutateAsync({ action: mode, body })
      onSuccess(stockIn ? '구매분을 새 재고 묶음으로 입고했습니다.' : '구매 수량을 기록했습니다. 냉장고 입고는 별도로 진행해 주세요.')
    } catch (failure) {
      setError(getErrorMessage(failure))
      if (!failure.response || failure.response.status >= 500) setUncertain(true)
    } finally { lock.current = false; onBusy(false) }
  }
  return <section aria-labelledby={id + '-title'} className="card mf-stack">
    <h2 id={id + '-title'} className="mf-section-title">{stockIn ? '냉장고에 넣기' : '구매 기록'}</h2>
    <p className="font-semibold">{item.ingredientName}</p>
    <p className="text-sm text-gray-600">{stockIn ? '구매한 양 중 냉장고에 넣을 수량을 확인하세요.' : '필요한 양보다 많이 샀어도 실제로 산 만큼 입력하세요.'}</p>
    <form onSubmit={submit} noValidate aria-busy={mutation.isPending}>
      <fieldset disabled={mutation.isPending || uncertain || disabled} className="min-w-0 space-y-4 disabled:opacity-60">
        <div><label htmlFor={`${id}-quantity`} className="label">{stockIn ? '입고할 수량' : '실제로 산 수량'} ({item.unit}) *</label>
          <input id={`${id}-quantity`} name="quantity" inputMode="decimal" value={form.quantity} onChange={change} className="input min-h-11" />
        </div>
        {stockIn && <>
          <div><label htmlFor={`${id}-location`} className="label">보관 위치 *</label><select id={`${id}-location`} name="storageLocation" value={form.storageLocation} onChange={change} className="input min-h-11">{Object.values(STORAGE_LOCATION).map((value) => <option key={value} value={value}>{STORAGE_LABEL[value]}</option>)}</select></div>
          <div><label htmlFor={`${id}-expiry`} className="label">소비기한 (선택)</label><input id={`${id}-expiry`} type="date" name="expiryDate" value={form.expiryDate} onChange={change} className="input min-h-11" /></div>
          <div><label htmlFor={`${id}-minimum`} className="label">최소 유지 수량 ({item.unit})</label><input id={`${id}-minimum`} inputMode="decimal" name="minStockQty" value={form.minStockQty} onChange={change} className="input min-h-11" /></div>
        </>}
        <button type="submit" className="btn-primary min-h-11 w-full">{mutation.isPending ? '처리 중...' : stockIn ? '냉장고에 입고하기' : '구매 기록하기'}</button>
      </fieldset>
      {error && <p role="alert" className="mt-4 whitespace-pre-wrap break-all rounded-xl bg-rose-50 p-3 text-sm text-rose-700">{error}</p>}
      {uncertain && <p role="alert" className="mt-3 text-sm leading-6 text-amber-800">서버 처리 결과가 불확실합니다. 중복 요청을 막기 위해 재전송을 중단했습니다. 목록을 다시 불러와 구매량과 입고 결과를 확인해 주세요.</p>}
    </form>
    {uncertain && <button type="button" className="btn-secondary" onClick={onReview}>목록 다시 확인</button>}
  </section>
}
