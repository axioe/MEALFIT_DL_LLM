import { useEffect, useState } from 'react'
import { useInfiniteQuery, useQuery } from '@tanstack/react-query'
import { searchWeb } from '@/api/search'
import { queryKeys } from '@/api/queryKeys'
import { MAX_SEARCH_LENGTH, nextSearchOffset, normalizeSearchTerm, SEARCH_LIMIT } from '@/models/webSearch'
import { useAuthStore } from '@/stores/authStore'

export function useSearchInput() {
  const [input, setInput] = useState('')
  const [open, setOpen] = useState(false)
  const [composing, setComposing] = useState(false)
  const [ready, setReady] = useState('')
  const term = normalizeSearchTerm(input)
  const visible = open && term.length > 0

  useEffect(() => {
    if (!visible || composing || term.length > MAX_SEARCH_LENGTH) return
    const timer = setTimeout(() => setReady(term), 300)
    return () => clearTimeout(timer)
  }, [term, visible, composing])

  function change(value) {
    setInput(value)
    setOpen(true)
    if (normalizeSearchTerm(value) !== term) setReady('')
  }

  function submit() {
    if (composing) return
    setOpen(true)
    setReady(term)
  }

  return { input, term, visible, settled: !composing && term === ready, change, submit, setOpen, setComposing }
}

export function useWebSearch(term) {
  const userId = useAuthStore(state => state.user?.id)
  return useQuery({
    queryKey: queryKeys.search.all(userId, term),
    queryFn: ({ signal }) => searchWeb({ q: term, limit: SEARCH_LIMIT }, signal),
    enabled: Boolean(userId), gcTime: 0, staleTime: 0, retry: false,
  })
}

export function useMoreSearchResults(term, group, firstPage) {
  const userId = useAuthStore(state => state.user?.id)
  const firstOffset = nextSearchOffset(firstPage)
  const query = useInfiniteQuery({
    queryKey: queryKeys.search.more(userId, term, group.type),
    queryFn: async ({ pageParam, signal }) => {
      const response = await searchWeb({ q: term, type: group.type, offset: pageParam, limit: SEARCH_LIMIT }, signal)
      return response[group.field]
    },
    initialPageParam: firstOffset,
    getNextPageParam: (lastPage, _pages, offset) => nextSearchOffset(lastPage, offset),
    enabled: false, gcTime: 0, retry: false,
  })
  const pages = [firstPage, ...(query.data?.pages ?? [])]
  const results = new Map()
  for (const page of pages) {
    for (const item of page.items) {
      const result = group.result(item)
      results.set(result.id, result)
    }
  }
  return {
    results: [...results.values()], total: pages.at(-1).total,
    hasMore: query.data ? query.hasNextPage : firstOffset !== undefined,
    loading: query.isFetching, error: query.error,
    loadMore: () => query.fetchNextPage({ cancelRefetch: false }),
  }
}
