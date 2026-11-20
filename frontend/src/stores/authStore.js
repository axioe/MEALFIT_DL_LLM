import { create } from 'zustand'
import { AUTH_STORAGE_KEY } from '@/lib/tabSession'

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
export const useAuthStore = create((set) => ({
  accessToken: null,
  user: null,
  // 새로고침 후 Refresh 쿠키 기반 초기 세션 복구가 끝났는지 여부
  bootstrapped: false,

  /** 로그인·재발급·복구 성공 시 Access Token과 회원 정보를 메모리에 저장합니다. */
  setSession: ({ accessToken, user }) => {
    clearLegacyAuthStorage()
    set({
      accessToken,
      user,
      bootstrapped: true,
    })
  },

  /** 초기 복구 시도가 완료되었음을 표시합니다. */
  markBootstrapped: () => {
    set({ bootstrapped: true })
  },

  /** 로그아웃 또는 재발급 실패 시 메모리 세션과 잔여 localStorage를 정리합니다. */
  clear: () => {
    clearLegacyAuthStorage()
    set({
      accessToken: null,
      user: null,
      bootstrapped: true,
    })
  },
}))
