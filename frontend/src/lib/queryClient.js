import { QueryClient } from '@tanstack/react-query'
import { SessionChangedError } from '../models/sessionScope.js'

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 30_000,
      retry: (failureCount, error) => !(error instanceof SessionChangedError) && failureCount < 1,
      refetchOnWindowFocus: false,
    },
  },
})
