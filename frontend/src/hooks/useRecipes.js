import { useQuery } from '@tanstack/react-query'
import { queryKeys } from '@/api/queryKeys'
import { recipesApi } from '@/api/recipes'

export function useRecipe(id, servings, enabled = true) {
  return useQuery({
    queryKey: queryKeys.recipes.detail(id, servings),
    queryFn: ({ signal }) => recipesApi.getDetail(id, servings, signal),
    enabled: Boolean(id) && enabled,
    retry: false,
    staleTime: 0,
    refetchOnMount: 'always',
  })
}
