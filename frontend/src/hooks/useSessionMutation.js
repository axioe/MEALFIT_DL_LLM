import { useMutation } from '@tanstack/react-query'
import { useAuthStore } from '@/stores/authStore'
import { captureSession, assertCurrentSession } from '@/models/sessionScope'
import { sessionMutationCallbacks, sessionMutationOptions } from '@/hooks/sessionMutation'

/** 로그인 상태를 유지하는 업무 저장 요청에 사용합니다. 로그인·로그아웃·탈퇴는 별도 처리합니다. */
export function useSessionMutation(options) {
  const getState = useAuthStore.getState
  const mutation = useMutation(sessionMutationOptions(options, getState))
  const pack = (variables) => ({ variables, scope: captureSession(getState()) })
  return {
    ...mutation,
    variables: mutation.variables?.variables,
    mutate: (variables, callbacks) => mutation.mutate(pack(variables), sessionMutationCallbacks(callbacks, getState)),
    mutateAsync: async (variables, callbacks) => {
      const input = pack(variables)
      const data = await mutation.mutateAsync(input, sessionMutationCallbacks(callbacks, getState))
      assertCurrentSession(input.scope, getState())
      return data
    },
  }
}
