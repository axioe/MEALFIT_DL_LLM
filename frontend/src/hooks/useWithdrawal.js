import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { useNavigate } from 'react-router-dom'
import { api } from '@/api/client'
import { requestWithdrawal, requestSocialWithdrawal, clearWithdrawalSession } from '@/models/withdrawalFlow'
import { withdrawalApi } from '@/api/withdrawal'
import { useAuthStore } from '@/stores/authStore'
import { captureSession, isCurrentSession } from '@/models/sessionScope'

/** 탈퇴 성공 시에만 세션을 정리하며, 비밀번호를 로그인 Store 등에 저장하지 않습니다. */
export function useWithdraw() {
  const queryClient = useQueryClient()
  const navigate = useNavigate()

  return useMutation({
    retry: false,
    // 비밀번호가 포함된 요청 변수는 화면이 해제되면 캐시에 남기지 않습니다.
    gcTime: 0,
    mutationFn: async ({ password, confirmed, social }) => {
      const scope = captureSession(useAuthStore.getState())
      const userId = useAuthStore.getState().user?.id
      if (!userId) throw new Error('로그인이 필요합니다.')
      if (social) {
        await requestSocialWithdrawal(api, confirmed)
      } else {
        await requestWithdrawal(api, password, confirmed)
      }
      return { userId, scope }
    },
    onSuccess: ({ userId, scope }) => clearWithdrawalSession({
      isCurrentSession: () => isCurrentSession(scope, useAuthStore.getState()) && useAuthStore.getState().user?.id === userId,
      navigate,
      cancelQueries: () => queryClient.cancelQueries(),
      clearSession: () => useAuthStore.getState().clear(),
      clearCache: () => queryClient.clear(),
    }),
  })
}

export function useWithdrawalReauthentication(enabled) {
  const userId = useAuthStore((state) => state.user?.id)
  const queryClient = useQueryClient()
  const key = ['withdrawal', 'reauthentication', userId]
  const status = useQuery({
    queryKey: key,
    queryFn: withdrawalApi.status,
    enabled,
    gcTime: 0,
    refetchOnMount: 'always',
    retry: false,
  })
  const start = useMutation({ mutationFn: withdrawalApi.start, retry: false })
  const cancel = useMutation({
    mutationFn: withdrawalApi.cancel,
    retry: false,
    onSuccess: () => queryClient.setQueryData(key, { remainingMillis: 0 }),
  })
  return { status, start, cancel }
}
