import { menuStock } from '@/models/menuDiscovery'

export function QuickRecipeResults({ recipes, onRecipe }) {
  return <ul className="mf-stack" aria-label="요리 목록">
    {recipes.map(recipe => {
      const stock = menuStock(recipe)
      return <li key={recipe.key} className="mf-result card">
        <div><span className={'mf-status' + (stock.ready ? '' : ' warn')}>{stock.label}</span>
          <h3>{recipe.name}</h3><p className="mf-copy text-sm">{recipe.cookTimeMin}분 · {recipe.servings}인분</p>
        </div>
        <button type="button" className="btn-secondary" onClick={() => onRecipe(recipe)} aria-label={recipe.name + ' ' + (stock.ready ? '레시피 보기' : '부족한 재료 보기')}>{stock.ready ? '레시피 보기' : '부족한 재료 보기'}</button>
      </li>
    })}
  </ul>
}
