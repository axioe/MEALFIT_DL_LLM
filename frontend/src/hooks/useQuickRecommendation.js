import { useMutation } from '@tanstack/react-query'
import { quickRecipesApi } from '@/api/quickRecipes'

export function useQuickRecommendation() {
  return useMutation({ mutationFn: quickRecipesApi.recommend, retry: false })
}
