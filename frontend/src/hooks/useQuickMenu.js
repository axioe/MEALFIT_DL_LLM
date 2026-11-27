import { useQuery } from '@tanstack/react-query'
import { queryKeys } from '@/api/queryKeys'
import { quickRecipesApi } from '@/api/quickRecipes'
import { prepareServerQuickInput } from '@/models/quickRecipeRequests'
import { useAuthStore } from '@/stores/authStore'

export function useQuickMenu(items, minutes, enabled) {
  const userId = useAuthStore(state => state.user?.id)
  const version = useAuthStore(state => state.sessionVersion)
  const inventory = items.flatMap(group => group.lots.map(lot => [lot.id, lot.quantity, group.ingredientName, group.unit, lot.expiryDate])).sort((a, b) => a[0] - b[0])
  const tooMany = inventory.length > 100
  const query = useQuery({
    queryKey: [...queryKeys.quickMenu(userId), version, minutes, inventory],
    queryFn: ({ signal }) => quickRecipesApi.recommend(prepareServerQuickInput(items, minutes), signal),
    enabled: Boolean(userId && enabled && inventory.length && !tooMany),
    staleTime: 5 * 60 * 1000,
    refetchOnWindowFocus: false, refetchOnReconnect: false, retry: false,
  })
  return { query, tooMany }
}
