import { useState } from 'react'
import { Link } from 'react-router-dom'
import { ArrowRight, ChefHat } from 'lucide-react'
import { getErrorMessage } from '@/api/client'
import { useMealPlanAction } from '@/hooks/useMealPlans'
import { useRecipe } from '@/hooks/useRecipes'
import { compareRecipeIngredient } from '@/models/recipeInventory'
import { mealCardActions, recipePlanLink } from '@/models/cookingUx'
import { menuStock } from '@/models/menuDiscovery'
import { MealConfirmation } from '@/components/recommend/MealConfirmation'
import { MemberLink } from '@/components/common/MemberLink'

function DinnerBanner({ first, title, description, children }) {
  return <section className={`card mf-hero ${first ? 'mf-hero-fridge' : 'mf-hero-dinner'}`}>
    <div className="mf-stack"><span className="mf-status flex items-center gap-2"><ChefHat size={19} aria-hidden="true" />{first ? '내 냉장고' : '오늘 저녁'}</span>
      <div><h2 className="mf-title">{title}</h2><p className="mf-copy">{description}</p></div>
      <div className="flex flex-wrap gap-2">{children}</div>
    </div><img className="mf-hero-art" src="/wireframe/meal.svg" alt="" />
  </section>
}

export function FirstFridgeBanner() {
  return <DinnerBanner first title="냉장고에 뭐가 있나요?" description="재료 하나만 등록하면 그걸로 만들 메뉴를 찾을 수 있어요.">
    <MemberLink className="btn-primary" to="/fridge?add=1" feature="재료 등록">첫 재료 등록하기 <ArrowRight size={16} /></MemberLink>
    <Link className="btn-secondary" to="/recommend?mode=quick&example=1">두부·달걀로 예시 보기</Link>
  </DinnerBanner>
}

export function HomeDinner({ dinner, inventory, date, first, busy }) {
  const [confirmation, setConfirmation] = useState(false)
  const [failure, setFailure] = useState('')
  const action = useMealPlanAction()
  const recipe = useRecipe(dinner?.recipe?.id, dinner?.servings, Boolean(dinner))
  const actions = dinner ? mealCardActions(dinner) : {}
  const comparisons = (recipe.data?.ingredients ?? []).map(item => ({ ...item, ...compareRecipeIngredient(item, inventory.groups) }))
  const stock = !recipe.isError && comparisons.length ? menuStock({ comparisons }) : null
  const shortage = comparisons.some(item => ['shortage','none'].includes(item.status))
  const cooking = dinner && recipePlanLink(dinner, true)
  async function confirm() {
    if (!dinner || busy || action.isPending) return
    setFailure('')
    try { await action.mutateAsync({ action: 'confirm', id: dinner.id, date }); setConfirmation(false) }
    catch (error) { setFailure(getErrorMessage(error)) }
  }
  if (first) return <FirstFridgeBanner />
  return <><DinnerBanner title={dinner?.recipe.name ?? '오늘 저녁은 뭘 먹을까요?'}
    description={dinner ? [dinner.recipe.cookTimeMin != null && dinner.recipe.cookTimeMin + '분', dinner.servings + '인분', actions.cooked ? '조리 완료' : stock?.label].filter(Boolean).join(' · ') : '냉장고에 있는 재료로 저녁 메뉴를 골라 보세요.'}>
        {actions.draft ? <button className="btn-primary" disabled={busy || action.isPending} onClick={() => { setFailure(''); setConfirmation(true) }}>이 메뉴로 정하기 <ArrowRight size={16} /></button> :
          actions.cooked ? <Link className="btn-primary" to={recipePlanLink(dinner) ?? '/recommend'}>조리 내역 보기</Link> :
          cooking ? <Link className="btn-primary" to={shortage ? '/shopping' : cooking}>{shortage ? '부족한 재료 장보기' : stock?.ready ? '요리 시작' : '조리 준비하기'} <ArrowRight size={16} /></Link> :
          <Link className="btn-primary" to={'/recommend?date=' + date}>오늘 저녁 메뉴 고르기 <ArrowRight size={16} /></Link>}
        {actions.draft && <Link to={'/recommend?date=' + date} className="btn-secondary">다른 저녁 보기</Link>}
        {cooking && <Link to={recipePlanLink(dinner)} className="btn-secondary">레시피 보기</Link>}
  </DinnerBanner>
  {confirmation && dinner && <MealConfirmation selection={{ action: 'confirm', plan: dinner }} busy={action.isPending} error={failure} onConfirm={confirm} onClose={() => setConfirmation(false)} />}</>
}
