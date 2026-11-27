import { useQuery, useQueryClient } from '@tanstack/react-query'
import { workoutApi } from '@/api/workout'
import { queryKeys } from '@/api/queryKeys'
import { useSessionMutation } from '@/hooks/useSessionMutation'

export function useWorkoutWeek(week) {
  const client = useQueryClient()
  const routine = useQuery({ queryKey: queryKeys.workout.current(week), queryFn: ({ signal }) => workoutApi.getCurrent(week, signal), retry: false })
  const summary = useQuery({ queryKey: queryKeys.workout.summary(week), queryFn: ({ signal }) => workoutApi.getWeeklySummary(week, signal), retry: false, enabled: Boolean(routine.data?.routineId) })
  const change = useSessionMutation({ retry: false, mutationFn: input => {
    if (input.action === 'make') return workoutApi.recommend({ startDate: week })
    if (input.action === 'adjust') return workoutApi.adjustSession(input.routineId, input.date, input.prompt)
    return workoutApi.recordLog(input.body)
  }, onSettled: () => client.invalidateQueries({ queryKey: queryKeys.workout.all }) })
  return { routine, summary, change }
}
