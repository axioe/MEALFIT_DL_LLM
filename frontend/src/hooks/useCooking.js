import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { cookingApi } from '@/api/cooking'
import { queryKeys } from '@/api/queryKeys'
import { cookingKeys, refreshCookingQueries, validateCookingPreview } from '@/models/cookingFlows'
import { validateUsagePreview } from '@/models/cookingUsage'

export function useCookingPreview(plan, enabled) {
  return useQuery({
    queryKey: cookingKeys.preview(plan?.id, plan?.servings),
    queryFn: async ({ signal }) => validateCookingPreview(await cookingApi.preview(plan.id, signal), plan),
    enabled: Boolean(plan) && enabled,
    staleTime: 0, retry: false, refetchOnMount: 'always',
  })
}

export function useCookingAction(date) {
  const client = useQueryClient()
  return useMutation({
    mutationFn: ({ action, id }) => action === 'complete' ? cookingApi.complete(id) : cookingApi.cancel(id),
    retry: false,
    onSettled: () => refreshCookingQueries(client, date),
  })
}

/** 실제 사용량(식단 조리·재료 직접 입력)으로 차감 전 미리보기를 서버에서 확인한다 */
export function useActualUsagePreview({ mode, body, snapshot, enabled }) {
  return useQuery({
    queryKey: ['cooking', 'actual-preview', mode, snapshot],
    queryFn: async ({ signal }) => validateUsagePreview(await (mode === 'meal' ? cookingApi.previewUsages(body, signal) : cookingApi.previewIngredients(body, signal)), body, mode),
    enabled,
    retry: false, staleTime: 0, refetchOnMount: 'always',
  })
}

/** 실제 사용량으로 조리 완료하거나 조리를 취소하고, 식단·재고 조회를 다시 받는다 */
export function useActualCookingAction({ mode, date }) {
  const client = useQueryClient()
  return useMutation({ retry: false,
    mutationFn: ({ action, payload, eventId }) => action === 'cancel' ? cookingApi.cancel(eventId)
      : mode === 'meal' ? cookingApi.completeUsages(payload) : cookingApi.completeIngredients(payload),
    onSettled: () => Promise.allSettled([refreshCookingQueries(client, date), client.invalidateQueries({ queryKey: queryKeys.mealPlans.all })]),
  })
}
