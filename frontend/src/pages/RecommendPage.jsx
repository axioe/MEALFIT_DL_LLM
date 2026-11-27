import { MealConfirmation } from '@/components/recommend/MealConfirmation'
import { mealCardActions, recipePlanLink } from '@/models/cookingUx'
import { DailyMealInfo, DailyRecipePreview } from '@/components/recommend/DailyRecipePreview'
import { QuickExample } from '@/components/recommend/QuickExample'
import { QuickCookingPanel } from '@/components/recommend/QuickCookingPanel'
import { useRef, useState } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { RefreshCw, Sparkles, UtensilsCrossed } from 'lucide-react'
import { getErrorMessage } from '@/api/client'
import { useMealPlanAction, useMealPlans } from '@/hooks/useMealPlans'
import { validRecipeDate } from '@/models/recipeInventory'
import { visibleMealPlans } from '@/models/mealPlanQueries'
import { Spinner } from '@/components/common/Spinner'
import { MealPlanStatusBadge, RecipeSourceBadge } from '@/components/common/StatusBadge'
import { today } from '@/lib/date'
import { MEAL_PLAN_STATUS, MEAL_TYPE, RECIPE_SOURCE } from '@/lib/enums'
import { MEAL_TYPE_LABEL } from '@/lib/labels'
import { formatQuantity } from '@/lib/format'

const ORDER = Object.values(MEAL_TYPE)

function RecipeDetails({ plan }) {
  return <div data-meal-details className="flex min-w-0 flex-col border-t border-gray-100 px-4 pt-4">
    <DailyRecipePreview plan={plan} />
  </div>
}

function RecommendDay({ date, setDate }) {
  const [activeMeal, setActiveMeal] = useState(MEAL_TYPE.DINNER)
  const [servings, setServings] = useState('1')
  const [selection, setSelection] = useState(null)
  const [error, setError] = useState('')
  const [message, setMessage] = useState('')
  const [shortages, setShortages] = useState(null)
  const lock = useRef(false)
  const mutation = useMealPlanAction()
  const query = useMealPlans(date)
  const plans = visibleMealPlans(query.data, date, query)
  const canAct = validRecipeDate(date) && !query.isFetching && !query.isError && query.data?.planDate === date
  const allConfirmed = ORDER.every((type) => plans.some((plan) => plan.mealType === type && plan.status === MEAL_PLAN_STATUS.CONFIRMED))
  const busy = mutation.isPending
  const plan = plans.find(row => row.mealType === activeMeal) ?? plans[0]
  const actions = plan && mealCardActions(plan)
  const recipeLink = plan && recipePlanLink(plan)
  const cookingLink = plan && recipePlanLink(plan, true)
  const blocked = busy || Boolean(selection)

  async function run(action, plan) {
    if (lock.current || !canAct) return
    if (action !== 'recommend' && (!plan || plan.planDate !== date || !plans.some((row) => row.id === plan.id && row.status === plan.status))) {
      setError('선택한 식단이 현재 날짜의 최신 상태와 다릅니다. 다시 조회해 주세요.'); return
    }
    if (!date || !Number.isInteger(Number(servings)) || Number(servings) < 1 || Number(servings) > 10) {
      setError('날짜와 1~10 사이의 인분을 입력해 주세요.'); return
    }
    lock.current = true
    setError(''); setMessage('')
    try {
      const result = await mutation.mutateAsync({ action, id: plan?.id, date, servings: Number(servings) })
      setSelection(null)
      setShortages(action === 'confirm' ? result.shortages : null)
      setMessage(action === 'confirm' ? '식단을 확정했어요. 요리하기를 눌러 사용할 재료를 확인해 보세요.' : action === 'cancel' ? '식단을 취소했습니다.' : action === 'regenerate' ? '선택한 끼니를 다시 추천했습니다. 다른 끼니는 유지했습니다.' : '추천 초안을 저장했습니다. 끼니별로 확인 후 확정해 주세요.')
    } catch (failure) {
      setError(getErrorMessage(failure) + ((!failure.response || failure.response.status >= 500) ? ' 처리 여부가 불확실할 수 있으므로 같은 요청을 바로 반복하지 마세요. 날짜별 식단을 다시 조회해 서버 상태를 확인해 주세요.' : ''))
    } finally { lock.current = false }
  }
  function choose(action, plan) { if (!canAct || busy) return; setError(''); setSelection({ action, plan }) }
  return <div className="space-y-6">
    <details className="card" key={plans.length ? 'with-plans' : 'empty'} open={!plans.length || undefined}><summary className="cursor-pointer font-semibold">{date} · 날짜와 추천 설정</summary>
      <form onSubmit={(event) => { event.preventDefault(); if (!canAct || busy) return; if (plans.length) choose('recommend'); else run('recommend') }} className="mt-4 grid items-end gap-3 sm:grid-cols-[1fr_7rem_auto]">
        <div className="min-w-0"><label htmlFor="recommend-date" className="label">추천 날짜</label><input id="recommend-date" type="date" required value={date} disabled={busy || Boolean(selection)} onChange={(event) => { setDate(event.target.value); setShortages(null); setMessage(''); setError('') }} className="input min-h-11" /></div>
        <div><label htmlFor="recommend-servings" className="label">인분</label><input id="recommend-servings" type="number" min="1" max="10" step="1" required value={servings} disabled={busy || Boolean(selection)} onChange={(event) => setServings(event.target.value)} className="input min-h-11" /></div>
        <button type="submit" disabled={busy || !canAct || Boolean(selection) || allConfirmed} className="btn-primary min-h-11"><Sparkles aria-hidden="true" className="h-4 w-4" />{busy ? '처리 중...' : plans.length ? '미확정 끼니 다시 추천' : '추천 받기'}</button>
      </form>
      <p className="text-xs leading-5 text-gray-500">이미 정한 끼니는 유지돼요. 인분은 새로 추천받는 메뉴에 적용됩니다.</p>
    </details>
    {!validRecipeDate(date) && <p role="alert" className="rounded-xl bg-rose-50 p-4 text-sm text-rose-700">올바른 날짜를 선택해 주세요.</p>}
    {query.isFetching && <div role="status" className="card flex items-center gap-3 text-sm text-gray-600"><Spinner />{date} 식단을 서버에서 확인하고 있습니다.</div>}
    {query.isError && <div role="alert" className="space-y-3 rounded-xl bg-rose-50 p-4 text-sm text-rose-700"><p className="whitespace-pre-wrap break-all">{getErrorMessage(query.error, '날짜별 식단을 불러오지 못했습니다.')}</p><p>최신 서버 상태를 확인하지 못해 이전 식단은 표시하지 않습니다.</p><button type="button" disabled={query.isFetching} onClick={() => query.refetch({ cancelRefetch: false })} className="btn-secondary min-h-11">식단 다시 조회</button></div>}
    {busy && <div role="status" className="flex items-center gap-3 rounded-xl bg-emerald-50 p-4 text-sm text-emerald-800"><Spinner />요청을 처리하고 있습니다. 추천은 시간이 걸릴 수 있습니다.</div>}
    {message && <p role="status" className="rounded-xl bg-emerald-50 p-4 text-sm text-emerald-800">{message}</p>}
    {error && !selection && <p role="alert" className="whitespace-pre-wrap break-all rounded-xl bg-rose-50 p-4 text-sm text-rose-700">{error}</p>}
    {shortages && <section className="card space-y-3"><h3 className="text-base font-bold">방금 확정한 식단의 부족분</h3>{shortages.length === 0 ? <p className="text-sm text-gray-600">서버 확인 결과 더 구매할 재료가 없어요.</p> : <ul className="space-y-2 text-sm">{shortages.map((item) => <li key={item.id} className="flex flex-wrap justify-between gap-2"><span className="min-w-0 break-all">{item.ingredientName}</span><span className="break-all font-semibold">{formatQuantity(item.remainingQty, item.unit)}</span></li>)}</ul>}<Link to="/shopping" className="btn-secondary min-h-11">장보기 목록 확인</Link></section>}
    {!canAct ? null : plans.length === 0 ? <div className="card py-12 text-center"><UtensilsCrossed aria-hidden="true" className="mx-auto mb-4 h-10 w-10 text-gray-300" /><h3 className="font-bold">이 날짜에 저장된 식단이 없어요</h3><p className="mt-2 text-sm leading-6 text-gray-500">날짜와 인분을 확인하고 추천받기를 눌러 새 초안을 만들어 보세요.</p></div> : <div className="mf-plan">
      <section className="card mf-stack"><h2 className="mf-section-title">오늘의 세 끼</h2>
        <div className="mf-stack" aria-label="끼니 선택">{ORDER.map(type => {
          const row = plans.find(item => item.mealType === type)
          return <button type="button" className="mf-meal-row" key={type} aria-pressed={plan?.id === row?.id} disabled={!row || blocked} onClick={() => setActiveMeal(type)}>
            <span className="mf-label">{MEAL_TYPE_LABEL[type]}</span><b>{row?.recipe.name ?? '아직 메뉴가 없어요'}</b>
            <small>{row ? row.cooked ? '조리 완료' : row.status === MEAL_PLAN_STATUS.DRAFT ? '메뉴 후보' : '확정' : ''}</small>
          </button>
        })}</div>
      </section><article className="card mf-stack" data-meal-card={plan.mealType}>
        <div className="flex items-center justify-between gap-2"><h2 className="mf-section-title">선택한 {MEAL_TYPE_LABEL[plan.mealType]}</h2><MealPlanStatusBadge status={plan.status} /></div>
        <h3 className="mf-title">{plan.recipe.name}</h3>
        <p className="mf-copy">{plan.recipe.cookTimeMin != null && plan.recipe.cookTimeMin + '분 · '}{plan.servings}인분</p>
        {plan.recommendationReason && <p className="text-sm text-gray-600">{plan.recommendationReason}</p>}
        <div className="flex flex-wrap gap-2">
          {actions.draft && <button type="button" className="btn-primary" disabled={blocked} onClick={() => choose('confirm', plan)}>이 메뉴로 정하기</button>}
          {actions.draft && <button className="btn-secondary" disabled={blocked} onClick={() => choose('regenerate', plan)}><RefreshCw size={15} />{MEAL_TYPE_LABEL[plan.mealType]}만 다시 추천</button>}
          {cookingLink && <Link className="btn-primary" to={cookingLink}>요리 시작</Link>}
          {recipeLink && <Link className="btn-secondary" to={recipeLink}>레시피 보기</Link>}
        </div>
        <details className="mf-options" key={plan.id}><summary>재료·영양과 식단 관리</summary>
          <DailyMealInfo plan={plan} /><RecipeDetails plan={plan} />
          {Object.values(RECIPE_SOURCE).includes(plan.recipe.source) && <RecipeSourceBadge source={plan.recipe.source} />}
          {actions.canCancelPlan && <button className="btn-secondary ml-2" disabled={blocked} onClick={() => choose('cancel', plan)}>식단 취소</button>}
        </details>
      </article></div>}
    <div className="flex flex-wrap gap-3"><Link to="/fridge" className="btn-secondary min-h-11">냉장고 확인</Link><Link to="/shopping" className="btn-secondary min-h-11">장보기 목록 보기</Link></div>
    {selection && <MealConfirmation selection={selection} busy={busy} error={error} onClose={() => { setSelection(null); setError('') }} onConfirm={() => run(selection.action, selection.plan)} />}
  </div>
}


export function RecommendPage() {
  const [params, setParams] = useSearchParams()
  const date = params.has('date') ? params.get('date') : today()
  const quick = params.get('mode') === 'quick'
  const example = quick && params.get('example') === '1'
  function updateDate(value) {
    const next = new URLSearchParams(params)
    next.set('date', value)
    setParams(next, { replace: true })
  }
  return <div>
    <header className="mf-heading"><div><h1>{quick ? '15분 요리' : '오늘 식단'}</h1>
      <p>{quick ? '냉장고 재료와 남은 시간을 기준으로 고르세요.' : '아침·점심·저녁 메뉴를 고르고 필요한 재료를 확인하세요.'}</p></div>
      <Link className="btn-secondary" to={quick ? '/recommend?date=' + date : '/recommend?mode=quick&date=' + date}>{quick ? '하루 식단 보기' : '15분 요리 찾기'}</Link>
    </header>
    {example ? <QuickExample /> : quick ? <QuickCookingPanel /> : <RecommendDay key={date} date={date} setDate={updateDate} />}
  </div>
}
