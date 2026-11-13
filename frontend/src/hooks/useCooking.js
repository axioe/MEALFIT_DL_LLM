import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { cookingApi } from '@/api/cooking'
import { cookingKeys, refreshCookingQueries, validateCookingPreview } from '@/models/cookingFlows'

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
