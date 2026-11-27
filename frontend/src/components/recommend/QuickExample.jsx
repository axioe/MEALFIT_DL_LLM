import { RecipeSteps } from './RecipeSteps'
import { useState } from 'react'
import { Link } from 'react-router-dom'
import { menuStock } from '@/models/menuDiscovery'
import { MenuBrowser } from './QuickCookingPanel'

const items = [
  { key: 'tofu', ingredientName: '두부', quantity: 1, unit: '모', hint: '내일까지' },
  { key: 'egg', ingredientName: '달걀', quantity: 2, unit: '개' },
  { key: 'rice', ingredientName: '밥', quantity: 2, unit: '공기' },
].map(item => ({ ...item, lots: [] }))

const tofu = { ingredientName: '두부', quantity: '½', unit: '모', status: 'sufficient' }
const egg = { ingredientName: '달걀', quantity: 1, unit: '개', status: 'sufficient' }
const onion = { ingredientName: '양파', quantity: '½', unit: '개', status: 'none', shortageText: '½개' }
const recipes = [
  { key: 'pan', name: '두부 달걀 부침', cookTimeMin: 10, ingredients: [tofu, egg], steps: [
    ['두부 물기 빼고 썰기', '두부 ½모의 물기를 빼고, 1cm 두께로 썰어요.'],
    ['달걀옷 입히기', '달걀 1개를 풀고 두부 앞뒤에 고르게 묻혀요.'],
    ['아랫면이 노릇해지면 뒤집기', '팬에 식용유를 두르고 앞면을 부쳐요. 뒤집어 양면을 고르게 익혀요.'],
  ] },
  { key: 'steam', name: '달걀찜', cookTimeMin: 12, ingredients: [egg], steps: [['달걀 풀기', '달걀을 물과 섞어요.'], ['천천히 익히기', '작은 냄비에 붓고 약한 불에서 속까지 익혀요.']] },
  { key: 'bowl', name: '두부 달걀 덮밥', cookTimeMin: 15, ingredients: [tofu, egg, { ingredientName: '밥', quantity: 1, unit: '공기', status: 'sufficient' }, onion], steps: [['재료 손질하기', '양파와 두부를 한입 크기로 썰어요.'], ['익혀 밥에 올리기', '팬에 재료를 볶다가 달걀을 넣어 익히고 밥 위에 올려요.']] },
].map(recipe => ({ ...recipe, servings: 1, comparisons: recipe.ingredients }))

export function QuickExample() {
  const [selected, setSelected] = useState([])
  const [recipe, setRecipe] = useState(null)
  const [finished, setFinished] = useState(false)
  const [recorded, setRecorded] = useState(false)
  const intro = <div className="mf-note"><b>예시 체험</b><span>예시 냉장고로 둘러봐요. 내 기록은 바뀌지 않아요.</span><Link className="mf-text-link" to="/fridge?add=1">내 재료 등록하기</Link></div>
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
      {!stock.ready ? <Link className="btn-secondary" to="/fridge?add=1">내 냉장고에 재료 등록</Link> : !finished ? <button className="btn-primary" onClick={() => setFinished(true)}>조리 완료 체험</button> :
        <div className="mf-stack" role="status"><b>{recorded ? '예시 식사 기록을 남겼어요' : '예시 요리를 완료했어요'}</b>{!recorded && <button className="btn-primary" onClick={() => setRecorded(true)}>먹었어요 체험</button>}
          {!recorded && <button className="btn-secondary" onClick={() => setFinished(false)}>조리 취소 체험</button>}</div>}
    </aside></div>
  </div></>
}
