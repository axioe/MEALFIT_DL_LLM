import { useSessionMutation } from '@/hooks/useSessionMutation'
import { useQuery, useQueryClient } from '@tanstack/react-query'
import { inventoryApi } from '@/api/inventory'
import { queryKeys } from '@/api/queryKeys'
import { countImminentLots } from '@/models/fridge'

export function useInventory(enabled = true) {
  return useQuery({
    enabled,
    queryKey: queryKeys.inventory.all,
    queryFn: inventoryApi.getLots,
    refetchOnMount: 'always',
  })
}

export function useStockIn() {
  const queryClient = useQueryClient()
  return useSessionMutation({
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
  return useSessionMutation({
    mutationFn: inventoryApi.updateLot,
    retry: false,
    onSuccess: () => queryClient.invalidateQueries({ queryKey: queryKeys.inventory.all }),
  })
}

/** 오늘 만료·기한 임박인 보관 중 재고 묶음 수 (냉장고 API) */
export function useImminentLotCount() {
  const { data } = useInventory()
  return data ? countImminentLots(data.groups) : 0
}
