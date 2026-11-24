import { assertCurrentSession, isCurrentSession } from '../models/sessionScope.js'

async function runInSession(scope, getState, operation) {
  assertCurrentSession(scope, getState())
  try {
    const result = await operation()
    assertCurrentSession(scope, getState())
    return result
  } catch (error) {
    assertCurrentSession(scope, getState())
    throw error
  }
}

/** 호출 시점의 세션을 변수와 함께 보관해, 대기·응답·콜백 사이의 계정 전환을 감지합니다. */
export function sessionMutationOptions(options, getState) {
  return {
    ...options,
    mutationFn: ({ variables, scope }, context) =>
      runInSession(scope, getState, () => options.mutationFn(variables, context)),
    onMutate: async ({ variables, scope }, context) =>
      runInSession(scope, getState, () => options.onMutate?.(variables, context)),
    onSuccess: async (data, { variables, scope }, ...context) => {
      assertCurrentSession(scope, getState())
      await options.onSuccess?.(data, variables, ...context)
      assertCurrentSession(scope, getState())
    },
    onError: (error, { variables, scope }, ...context) => {
      if (isCurrentSession(scope, getState())) return options.onError?.(error, variables, ...context)
    },
    onSettled: (data, error, { variables, scope }, ...context) => {
      if (isCurrentSession(scope, getState())) return options.onSettled?.(data, error, variables, ...context)
    },
  }
}

export function sessionMutationCallbacks(callbacks, getState) {
  if (!callbacks) return undefined
  return {
    onSuccess: (data, { variables, scope }, ...context) => {
      if (isCurrentSession(scope, getState())) callbacks.onSuccess?.(data, variables, ...context)
    },
    onError: (error, { variables, scope }, ...context) => {
      if (isCurrentSession(scope, getState())) callbacks.onError?.(error, variables, ...context)
    },
    onSettled: (data, error, { variables, scope }, ...context) => {
      if (isCurrentSession(scope, getState())) callbacks.onSettled?.(data, error, variables, ...context)
    },
  }
}
