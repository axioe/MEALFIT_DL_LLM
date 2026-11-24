/** 로그인 경계만 추적합니다. 같은 세션의 Access Token 갱신은 경계가 아닙니다. */
export function captureSession(state) {
  return { version: state.sessionVersion, userId: state.user?.id ?? null }
}

export function isCurrentSession(scope, state) {
  return scope.version === state.sessionVersion && scope.userId === (state.user?.id ?? null)
}

export class SessionChangedError extends Error {
  constructor() {
    super('로그인 정보가 변경되었습니다. 현재 계정에서 다시 시도해 주세요.')
    this.name = 'SessionChangedError'
  }
}

export function assertCurrentSession(scope, state) {
  if (!isCurrentSession(scope, state)) throw new SessionChangedError()
}
