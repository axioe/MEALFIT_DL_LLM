import { create } from 'zustand'
import { AUTH_STORAGE_KEY } from '../lib/tabSession.js'

/** [보안][JWT메모리] 과거 버전에서 localStorage에 저장됐던 인증 잔여 데이터를 정리합니다. */
function clearLegacyAuthStorage() {
  try {
    if (typeof window !== 'undefined' && window.localStorage) {
      window.localStorage.removeItem(AUTH_STORAGE_KEY)
    }
  } catch {
    // 스토리지 접근이 제한된 환경에서는 무시합니다.
  }
}

clearLegacyAuthStorage()

/**
 * [보안][JWT메모리] Access JWT와 회원 정보를 메모리에만 보관합니다.
 * 새로고침 시에는 HttpOnly Refresh 쿠키(/api/v1/auth/refresh)로 세션을 복구합니다.
 */
export const createAuthState = (set) => ({
  accessToken: null,
  user: null,
  // 새로고침 후 Refresh 쿠키 기반 초기 세션 복구가 끝났는지 여부
  bootstrapped: false,
  sessionVersion: 0,
  restoring: false,
  restoreError: null,

  /** 로그인·초기 복구 성공 시 새 세션과 회원 정보를 메모리에 저장합니다. */
  setSession: ({ accessToken, user }) => {
    clearLegacyAuthStorage()
    set((state) => ({
      accessToken,
      user,
      bootstrapped: true,
      sessionVersion: state.sessionVersion + 1,
      restoring: false,
      restoreError: null,
    }))
  },

  /** 같은 세션의 토큰 갱신은 진행 중인 업무 요청을 무효화하지 않습니다. */
  updateSession: ({ accessToken, user }) => set({ accessToken, user, bootstrapped: true }),

  startRestore: () => set({ restoring: true, restoreError: null }),
  failRestore: (error) => set({ restoring: false, restoreError: error }),

  /** 초기 복구 시도가 완료되었음을 표시합니다. */
  markBootstrapped: () => {
    set({ bootstrapped: true })
  },

  /** 로그아웃 또는 인증 만료가 확인된 경우 메모리 세션과 잔여 localStorage를 정리합니다. */
  clear: () => {
    clearLegacyAuthStorage()
    set((state) => ({
      accessToken: null,
      user: null,
      bootstrapped: true,
      sessionVersion: state.sessionVersion + 1,
      restoring: false,
      restoreError: null,
    }))
  },
})

export const useAuthStore = create(createAuthState)
