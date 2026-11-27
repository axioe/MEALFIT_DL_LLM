import { Link, useSearchParams } from 'react-router-dom'
import { usePublicRecipeCatalog } from '@/hooks/useRecipes'
import { getErrorMessage } from '@/api/client'
import { recipeCatalogPage } from '@/models/recipeInventory'

export function RecipeCatalogPage() {
  const [params] = useSearchParams()
  const page = recipeCatalogPage(params.get('page'))
  const query = usePublicRecipeCatalog(page)
  const data = query.data
  return <div className="mf-stack">
    <header className="mf-heading mb-0">
      <h1>전체 레시피</h1>
      {data && <span className="mf-label">총 {data.total.toLocaleString()}개</span>}
    </header>
    {query.isPending && <p role="status">레시피를 불러오는 중이에요.</p>}
    {query.isError && <div role="alert" className="card mf-stack">
      <p>{getErrorMessage(query.error)}</p>
      <button type="button" className="btn-secondary justify-self-start" onClick={() => query.refetch()}>다시 시도</button>
    </div>}
    {data && <>
      {data.items.length ? <ul className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
        {data.items.map(recipe => <li key={recipe.id}>
          <Link to={'/recipes/' + recipe.id} state={{ catalogPage: page }} className="card block h-full hover:border-emerald-600">
            <strong>{recipe.name}</strong><p className="mf-copy">{recipe.cookTimeMin}분 · {recipe.servingSize}인분</p>
          </Link>
        </li>)}
      </ul> : <p className="card">{data.total ? '이 페이지에 레시피가 없어요.' : '등록된 공용 레시피가 없어요.'}</p>}
      {data.totalPages > 0 && <nav aria-label="레시피 목록 페이지" className="flex flex-wrap items-center justify-center gap-2">
        {page > 1 && <Link className="btn-secondary" to="/recipes">처음</Link>}
        {page > 1 && page <= data.totalPages && <Link className="btn-secondary" to={'?page=' + (page - 1)}>이전</Link>}
        {page <= data.totalPages && <span aria-current="page" className="px-2">{page} / {data.totalPages}</span>}
        {page < data.totalPages && <Link className="btn-secondary" to={'?page=' + (page + 1)}>다음</Link>}
        {page !== data.totalPages && <Link className="btn-secondary" to={'?page=' + data.totalPages}>마지막</Link>}
      </nav>}
    </>}
  </div>
}
