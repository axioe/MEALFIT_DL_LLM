import { RecipeSteps } from './RecipeSteps'
import { useState } from 'react'
import { MemberLink } from '@/components/common/MemberLink'
import { useGuestLogin } from '@/hooks/useGuestLogin'
import { menuStock } from '@/models/menuDiscovery'
import { MenuBrowser } from './QuickCookingPanel'
import { EXAMPLE_INVENTORY as items, EXAMPLE_RECIPES as recipes } from '@/lib/guestMealExamples'

export function QuickExample({ initialRecipeKey }) {
  const requestLogin = useGuestLogin()
  const [selected, setSelected] = useState([])
  const [recipe, setRecipe] = useState(() => recipes.find(item => item.key === initialRecipeKey) ?? null)
  const [finished, setFinished] = useState(false)
  const [recorded, setRecorded] = useState(false)
  const intro = <div className="mf-note"><b>예시 체험</b><span>예시 냉장고로 둘러봐요. 내 기록은 바뀌지 않아요.</span><MemberLink className="mf-text-link" to="/fridge?add=1" feature="재료 등록">내 재료 등록하기</MemberLink></div>
  const browser = <div hidden={Boolean(recipe)}><div className="mf-stack">{intro}<MenuBrowser example items={items} selected={selected} onSelect={setSelected} recipes={recipes} onRecipe={item => { setRecipe(item); setFinished(false); setRecorded(false) }} /></div></div>
  if (!recipe) return <>{browser}</>
  const stock = menuStock(recipe)
  return <>{browser}<div className="mf-stack">{intro}
    <div><button type="button" className="mf-text-link" onClick={() => setRecipe(null)}>← 메뉴 목록</button><h2 className="mf-title mt-3">{recipe.name}</h2><p className="mf-copy">{recipe.cookTimeMin}분 · 1인분</p></div>
    <div className="mf-two"><section className="card mf-stack"><h3 className="mf-section-title">만드는 순서</h3>
      <RecipeSteps name={recipe.name} steps={recipe.steps} />
    </section><aside className="card mf-stack"><h3 className="mf-section-title">사용할 재료</h3><strong className={'mf-status' + (stock.ready ? '' : ' warn')}>{stock.label}</strong>
      <ul className="mf-list">{recipe.ingredients.map(item => <li key={item.ingredientName}><span>{item.ingredientName}</span><strong>{item.quantity}{item.unit}</strong></li>)}</ul>
      {recipe.key === 'pan' && <p className="text-sm text-gray-600">기본 양념 · 식용유 사용</p>}
      {!stock.ready ? <MemberLink className="btn-secondary" to="/fridge?add=1" feature="재료 등록">내 냉장고에 재료 등록</MemberLink>
        : requestLogin ? <button type="button" className="btn-primary" aria-haspopup="dialog" onClick={() => requestLogin('조리 완료')}>조리 완료</button>
        : !finished ? <button className="btn-primary" onClick={() => setFinished(true)}>조리 완료 체험</button> :
        <div className="mf-stack" role="status"><b>{recorded ? '예시 식사 기록을 남겼어요' : '예시 요리를 완료했어요'}</b>{!recorded && <button className="btn-primary" onClick={() => setRecorded(true)}>먹었어요 체험</button>}
          {!recorded && <button className="btn-secondary" onClick={() => setFinished(false)}>조리 취소 체험</button>}</div>}
    </aside></div>
  </div></>
}
