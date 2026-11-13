import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { mealPlansApi } from '@/api/mealPlans'
import { queryKeys } from '@/api/queryKeys'
import { mealPlanQueryOptions, refreshMealPlanQueries } from '@/models/mealPlanQueries'

export function useMealPlans(date) {
  return useQuery(mealPlanQueryOptions(date, mealPlansApi.getByDate))
}

export function useMealPlanAction() {
  const client = useQueryClient()
  return useMutation({
    retry: false,
    onMutate: ({ date }) => client.cancelQueries({ queryKey: queryKeys.mealPlans.byDate(date), exact: true }),
    mutationFn: ({ action, id, date, servings }) => action === 'recommend'
      ? mealPlansApi.recommend({ planDate: date, servings }) : mealPlansApi[action](id),
    // 처리 결과와 무관하게 서버 상태를 다시 확인한다.
    onSettled: (_result, _error, variables) => refreshMealPlanQueries(client, variables),
  })
}
