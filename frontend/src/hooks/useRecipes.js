import { useQuery } from '@tanstack/react-query'
import { queryKeys } from '@/api/queryKeys'
import { recipesApi } from '@/api/recipes'

export function usePublicRecipeCatalog(page) {
  return useQuery({
    queryKey: queryKeys.recipes.catalog(page),
    queryFn: ({ signal }) => recipesApi.getPublicCatalog(page, signal),
    retry: false,
  })
}

export function useRecipe(id, servings, enabled = true, publicOnly = false) {
  const key = publicOnly ? queryKeys.recipes.publicDetail : queryKeys.recipes.detail
  const getDetail = publicOnly ? recipesApi.getPublicDetail : recipesApi.getDetail
  return useQuery({
    queryKey: key(id, servings),
    queryFn: ({ signal }) => getDetail(id, servings, signal),
    enabled: Boolean(id) && enabled,
    retry: false,
    staleTime: 0,
    refetchOnMount: 'always',
  })
}
