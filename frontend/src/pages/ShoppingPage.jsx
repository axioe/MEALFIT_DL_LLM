import { useState } from 'react'
import { Link } from 'react-router-dom'
import { RefreshCw, ShoppingCart } from 'lucide-react'
import { getErrorMessage } from '@/api/client'
import { useShopping } from '@/hooks/useShopping'
import { ShoppingItemForm } from '@/components/shopping/ShoppingItemForm'
import { SHOPPING_ITEM_STATUS_LABEL } from '@/lib/labels'
import { formatQuantity } from '@/lib/format'

export function ShoppingPage() {
  const query = useShopping()
  const [selection, setSelection] = useState(null)
  const [busy, setBusy] = useState(false)
  const [revision, setRevision] = useState(0)
  const [message, setMessage] = useState('')
  const items = query.data ?? []
  const item = items.find(row => row.id === selection?.id) ?? items[0]
  const canStock = Number(item?.purchasedQty) > 0
  const canBuy = Number(item?.remainingQty) > 0
  const preferred = selection?.id === item?.id ? selection?.mode : null
  const mode = canStock && (!canBuy || preferred !== 'purchase') ? 'stockIn' : 'purchase'
  async function review() {
    const result = await query.refetch({ cancelRefetch: false })
    if (result.isSuccess) setRevision(value => value + 1)
  }
  return <div className="mf-stack"><header className="mf-heading"><div><h1>장보기</h1><p>확정한 식단에 필요한 재료와 실제로 산 양을 확인하세요.</p></div>
    <button className="btn-secondary" onClick={review} disabled={query.isFetching || busy}><RefreshCw size={15} />새로고침</button></header>
    {message && <p className="mf-note" role="status">{message}<Link className="mf-text-link" to="/fridge">냉장고 확인</Link></p>}
    {query.isError && <p className="card" role="alert">{getErrorMessage(query.error)}</p>}
    {query.isPending ? <p className="card" role="status">장보기 목록을 불러오는 중…</p> : !query.isError && !items.length ? <section className="card mf-stack"><ShoppingCart size={24} /><h2 className="mf-section-title">지금 살 재료가 없어요</h2><p className="mf-copy">식단을 정하면 부족한 재료가 여기에 모여요.</p><Link className="btn-secondary justify-self-start" to="/recommend">식단 보기</Link></section> :
      item && <div className="mf-two"><section className="card mf-stack"><div className="flex flex-wrap justify-between gap-2"><h2 className="mf-section-title">식단에 필요한 재료</h2><span className="mf-status">{items.length}종</span></div>
        <ul className="mf-stack">{items.map(row => <li key={row.id}><button className="mf-meal-row" aria-pressed={row.id === item.id} disabled={busy} onClick={() => { setMessage(''); setSelection({ id: row.id }) }}>
          <b>{row.ingredientName}</b><span>{SHOPPING_ITEM_STATUS_LABEL[row.status]}</span></button>
          {row.id === item.id && <dl className="mf-numbers">{[['필요한 구매량', row.requiredQty], ['구매 후 입고 대기', row.purchasedQty], ['더 살 수량', row.remainingQty]].map(([label, value]) => <div key={label}><dt>{label}</dt><dd>{formatQuantity(value,row.unit)}</dd></div>)}</dl>}
        </li>)}</ul></section>
        <div className="mf-stack">{canStock && canBuy && <div className="flex flex-wrap gap-2">{[['purchase','추가 구매 기록'],['stockIn','구매분 입고']].map(([key,label]) => <button key={key} type="button" className="mf-chip" aria-pressed={mode === key} disabled={busy} onClick={() => setSelection({ id: item.id, mode: key })}>{label}</button>)}</div>}
        {(canStock || canBuy) && <ShoppingItemForm key={[item.id, mode, item.purchasedQty, item.remainingQty, revision].join('-')} item={item} mode={mode} disabled={query.isFetching || query.isError} onBusy={setBusy} onReview={review}
          onSuccess={text => { setMessage(text); setSelection({ id: item.id }) }} />}</div>
      </div>}
  </div>
}
