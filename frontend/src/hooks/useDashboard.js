import { useInventory } from '@/hooks/useInventory'
import { useShopping } from '@/hooks/useShopping'
import { useMealPlans } from '@/hooks/useMealPlans'
import { intakeApi } from '@/api/intake'
import { pickExpiringLots } from '@/models/dashboard'
import { SHOPPING_ITEM_STATUS } from '@/lib/enums'
import { useSessionMutation } from '@/hooks/useSessionMutation'
import { useQuery, useQueryClient } from '@tanstack/react-query'
import { dashboardApi } from '@/api/dashboard'
import { queryKeys } from '@/api/queryKeys'

export function useDashboard(date) {
  const plans = useMealPlans(date)
  const fridge = useInventory()
  const shopping = useShopping()
  const logs = useQuery({ queryKey: queryKeys.intake.byDate(date), queryFn: ({ signal }) => intakeApi.getByDate(date, signal), staleTime: 0, retry: false })
  const intake = new Map((logs.data ?? []).map(log => [log.mealPlanId, log.intakeStatus]))
  const meals = (plans.data?.mealPlans ?? []).map(plan => ({ ...plan, intakeStatus: intake.get(plan.id) ?? null }))
  return {
    plans, fridge,
    meals: { data: { meals }, isPending: plans.isPending || logs.isPending, isError: plans.isError || logs.isError,
      error: plans.error ?? logs.error, refetch: () => Promise.all([plans.refetch(), logs.refetch()]) },
    inventory: { ...fridge, data: fridge.data && { expiringLots: pickExpiringLots(fridge.data) } },
    shopping: { ...shopping, data: shopping.data && { shortages: shopping.data.filter(item => item.status !== SHOPPING_ITEM_STATUS.PURCHASED) } },
  }
}

export function useRecordIntake() {
  const queryClient = useQueryClient()
  return useSessionMutation({
    mutationFn: dashboardApi.recordIntake,
    retry: false,
    onSuccess: () => Promise.all([queryClient.invalidateQueries({ queryKey: queryKeys.dashboard.all }), queryClient.invalidateQueries({ queryKey: queryKeys.intake.all })]),
  })
}

export function useProfileSummary() {
  return useQuery({ queryKey: queryKeys.dashboard.profile, queryFn: dashboardApi.getProfile })
}

export function useTodayWorkout(date) {
  return useQuery({ queryKey: queryKeys.dashboard.workout(date), queryFn: () => dashboardApi.getTodayWorkout(date) })
}

export function useSetWorkoutCompleted() {
  const queryClient = useQueryClient()
  return useSessionMutation({
    mutationFn: dashboardApi.setWorkoutCompleted,
    retry: false,
    onSuccess: (_, { date }) => queryClient.invalidateQueries({ queryKey: queryKeys.dashboard.workout(date) }),
  })
}

export function useWeightSummary() {
  return useQuery({ queryKey: queryKeys.dashboard.weight, queryFn: dashboardApi.getWeightSummary })
}

export function useCoaching() {
  return useQuery({ queryKey: queryKeys.dashboard.coaching, queryFn: dashboardApi.getCoaching })
}

export function useCheckCondition() {
  const queryClient = useQueryClient()
  return useSessionMutation({
    mutationFn: dashboardApi.checkCondition,
    retry: false,
    onSuccess: (coaching) => queryClient.setQueryData(queryKeys.dashboard.coaching, coaching),
  })
}
