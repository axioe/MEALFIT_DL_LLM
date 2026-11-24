import { useSessionMutation } from '@/hooks/useSessionMutation'
import { quickRecipesApi } from '@/api/quickRecipes'

export function useQuickRecommendation() {
  return useSessionMutation({ mutationFn: quickRecipesApi.recommend, retry: false })
}
