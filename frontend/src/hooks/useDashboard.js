import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { dashboardApi } from '@/api/dashboard'
import { queryKeys } from '@/api/queryKeys'

export function useDashboard(date) {
  return useQuery({
    queryKey: queryKeys.dashboard.byDate(date),
    queryFn: () => dashboardApi.getDashboard(date),
    // 냉장고·장보기 화면에서 바꾼 내용이 돌아왔을 때 바로 보이도록 매번 새로 받는다
    staleTime: 0,
  })
}

export function useRecordIntake() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: dashboardApi.recordIntake,
    retry: false,
    onSuccess: () => queryClient.invalidateQueries({ queryKey: queryKeys.dashboard.all }),
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
  return useMutation({
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
  return useMutation({
    mutationFn: dashboardApi.checkCondition,
    retry: false,
    onSuccess: (coaching) => queryClient.setQueryData(queryKeys.dashboard.coaching, coaching),
  })
}
