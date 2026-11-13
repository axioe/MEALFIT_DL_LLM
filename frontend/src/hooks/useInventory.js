import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { inventoryApi } from '@/api/inventory'
import { queryKeys } from '@/api/queryKeys'

export function useInventory() {
  return useQuery({
    queryKey: queryKeys.inventory.all,
    queryFn: inventoryApi.getLots,
    refetchOnMount: 'always',
  })
}

export function useStockIn() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: inventoryApi.stockIn,
    retry: false,
    onSuccess: () => queryClient.invalidateQueries({ queryKey: queryKeys.inventory.all }),
  })
}

export function useInventoryTransactions(lotId) {
  return useQuery({
    queryKey: queryKeys.inventory.transactions(lotId),
    queryFn: () => inventoryApi.getTransactions(lotId),
    refetchOnMount: 'always',
  })
}

export function useUpdateLot() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: inventoryApi.updateLot,
    retry: false,
    onSuccess: () => queryClient.invalidateQueries({ queryKey: queryKeys.inventory.all }),
  })
}
