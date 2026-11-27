import { useState } from 'react'
import { useSearchParams } from 'react-router-dom'
import { MemberLink } from '@/components/common/MemberLink'
import { Check, Plus, RefreshCw } from 'lucide-react'
import { getErrorMessage } from '@/api/client'
import { useInventory } from '@/hooks/useInventory'
import { useQuickMenu } from '@/hooks/useQuickMenu'
import { selectableIngredients, searchIngredients } from '@/models/quickCooking'
import { matchingMenus } from '@/models/menuDiscovery'
import { addDays } from '@/lib/date'
import { QuickRecipeDetail } from './QuickRecipeDetail'
import { QuickRecipeResults } from './QuickRecipeResults'

function expiryHint(item, date) {
  if (item.hint) return item.hint
  const expiry = item.lots.map(lot => lot.expiryDate).filter(Boolean).sort()[0]
  if (!expiry || !date) return ''
  if (expiry === date) return '오늘까지'
  if (expiry === addDays(date, 1)) return '내일까지'
  return expiry <= addDays(date, 3) ? expiry.slice(5).replace('-', '/') + '까지' : ''
}

export function MenuBrowser({ items, date, selected, onSelect, recipes = [], loading, error, onRetry, onRecipe, extra, example = false }) {
  const [readyOnly, setReadyOnly] = useState(false)
  const [search, setSearch] = useState('')
  const chosen = items.filter(item => selected.includes(item.key))
  const matches = matchingMenus(recipes, chosen.map(item => item.ingredientName), readyOnly)
  return <div className="mf-search">
    <aside className="card mf-stack"><h2 className="mf-section-title">오늘 쓰고 싶은 재료</h2>
      <div><p className="mf-label">{example ? '예시 냉장고' : '내 냉장고'}</p>
        {items.length > 7 && <input aria-label="재료 검색" className="input mb-3" placeholder="재료 검색" value={search} onChange={e => setSearch(e.target.value)} />}
        <div className="mf-ingredients">{searchIngredients(items, search).map(item => {
          const checked = selected.includes(item.key)
          const Icon = checked ? Check : Plus
          const hint = expiryHint(item, date)
          return <button key={item.key} type="button" aria-pressed={checked} className="mf-chip" onClick={() => onSelect(checked ? selected.filter(key => key !== item.key) : [...selected, item.key])}>
            <Icon size={15} aria-hidden="true" />{item.ingredientName} · {item.quantity}{item.unit}{hint && ' · ' + hint}
          </button>
        })}</div>
      </div>
      <p className="text-sm text-gray-600">선택한 재료를 모두 쓰는 메뉴를 찾아요.</p>
      {chosen.length > 0 && <button type="button" className="mf-text-link" onClick={() => onSelect([])}>재료 선택 해제</button>}
      <MemberLink className="mf-text-link" feature={example ? '재료 등록' : '내 냉장고'} to={example ? '/fridge?add=1' : '/fridge'}>{example ? '내 재료 등록하기' : '내 냉장고 보기'}</MemberLink>
      {extra}
    </aside>
    <section className="mf-stack" aria-label="검색 결과">
      <h2 className="mf-section-title" aria-live="polite">{loading ? '냉장고 재료로 메뉴 찾는 중…' : error ? '메뉴를 불러오지 못했어요' : '냉장고 재료로 찾은 요리 ' + matches.length + '개'}</h2>
      <div className="flex flex-wrap gap-2" aria-label="장보기 필터">{[[false, '전체 메뉴'], [true, '장보기 없이']].map(([value, text]) => <button key={text} type="button" aria-pressed={readyOnly === value} onClick={() => setReadyOnly(value)} className="mf-chip">{readyOnly === value && <Check size={15} aria-hidden="true" />}{text}</button>)}</div>
      {loading ? <div className="card" role="status">추천 메뉴를 준비하고 있어요.</div> : error ? <div className="card mf-stack" role="alert"><p>{error}</p>{onRetry && <button className="btn-secondary justify-self-start" onClick={onRetry}>다시 시도</button>}</div> :
        matches.length ? <QuickRecipeResults recipes={matches} onRecipe={onRecipe} /> :
          <div className="card mf-stack"><h3 className="font-bold">{items.length ? '조건에 맞는 메뉴가 없어요' : '냉장고에 쓸 수 있는 재료가 없어요'}</h3>
            {readyOnly ? <button className="btn-secondary justify-self-start" onClick={() => setReadyOnly(false)}>부족한 재료가 있는 메뉴도 보기</button> :
               chosen.length ? <button className="btn-secondary justify-self-start" onClick={() => onSelect([])}>재료 선택 해제하고 보기</button> : <MemberLink to="/fridge?add=1" feature="재료 등록" className="btn-secondary justify-self-start">재료 등록하기</MemberLink>}
          </div>}
    </section>
  </div>
}

export function QuickCookingPanel() {
  const inventory = useInventory()
  const [params] = useSearchParams()
  const [selected, setSelected] = useState(null)
  const [scope, setScope] = useState(null)
  const [minutes, setMinutes] = useState(15)
  const [detail, setDetail] = useState(null)
  const items = selectableIngredients(inventory.data)
  const active = selected ?? items.filter(item => item.ingredientName === params.get('ingredient')).map(item => item.key)
  const requested = scope ? items.filter(item => scope.includes(item.key)) : items
  const { query, tooMany } = useQuickMenu(requested, minutes, inventory.isSuccess)
  const error = inventory.isError ? getErrorMessage(inventory.error) : tooMany ? '재고 묶음이 100개를 넘어요. 사용할 재료를 고른 뒤 선택한 재료로 추천받기를 눌러 주세요.' : query.isError ? getErrorMessage(query.error, '요리 추천을 불러오지 못했어요.') : null
  function request() {
    if (!active.length) setScope(null)
    else setScope(active)
    if (JSON.stringify(scope ?? []) === JSON.stringify(active) && !tooMany && requested.length) query.refetch({ cancelRefetch: false })
  }
  return <><div hidden={Boolean(detail)}><MenuBrowser items={items} date={inventory.data?.asOfDate} selected={active} onSelect={setSelected} recipes={query.data?.recipes}
    loading={inventory.isPending || query.isFetching} error={error} onRetry={tooMany ? null : () => inventory.isError ? inventory.refetch() : query.refetch()} onRecipe={setDetail}
    extra={<details className="mf-options"><summary>추천 조건</summary>
      <p className="text-xs leading-6">MealFit 자체 AI가 현재 냉장고 재고로 추천해요. 추천만으로 재고는 바뀌지 않으며, 실제 사용량은 조리 전 서버 미리보기에서 다시 확인해요.</p>
      <label className="label mt-3" htmlFor="quick-minutes">최대 조리 시간</label>
      <select id="quick-minutes" className="input mb-3" value={minutes} onChange={e => setMinutes(Number(e.target.value))}>{[5, 10, 15].map(n => <option value={n} key={n}>{n}분</option>)}</select>
      <button className="btn-secondary" disabled={!items.length || query.isFetching || inventory.isError} onClick={request}><RefreshCw size={15} />{active.length ? '선택한 재료로 추천받기' : '전체 재료로 다시 추천'}</button></details>} /></div>{detail && <QuickRecipeDetail key={detail.key} recipe={detail} initialMode="detail" inventory={inventory} onBack={() => setDetail(null)} />}</>
}
