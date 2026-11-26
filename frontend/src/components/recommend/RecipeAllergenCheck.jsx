import { getErrorMessage } from '@/api/client'
import { useRecipeAllergenCheck } from '@/hooks/useAllergies'
import { ALLERGEN_REASON_LABEL } from '@/lib/labels'

export function RecipeAllergenCheck({ recipeId }) {
  const query = useRecipeAllergenCheck(recipeId)
  return <section aria-label="내 알레르기 확인" className="space-y-2 rounded-xl border border-gray-200 p-4 text-sm">
    <h3 className="font-bold">내 알레르기 확인</h3>
    {query.isFetching || query.isPending ? <p role="status">재료를 확인하고 있습니다.</p>
      : query.isError ? <div role="alert" className="space-y-2 text-rose-700">
        <p>알레르기 확인에 실패했습니다. {getErrorMessage(query.error)}</p>
        <button type="button" className="btn-secondary" onClick={() => query.refetch()}>다시 확인</button>
      </div>
      : query.data.safe ? <p className="text-emerald-800">등록한 알레르기와 겹치는 재료가 없습니다.</p>
      : <ul className="space-y-2">
        {query.data.warnings.map((warning) => <li key={JSON.stringify([warning.ingredientName, warning.allergen, warning.reason])}
          className="rounded-lg bg-amber-50 p-2 text-amber-950">
          <strong>{ALLERGEN_REASON_LABEL[warning.reason]} · {warning.ingredientName}</strong>
          <p>{warning.message}</p>
        </li>)}
      </ul>}
  </section>
}
