import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import { AUTH_STORAGE_KEY } from '@/lib/tabSession'

/**
 * 로그인 정보와 토큰을 관리합니다.
 * 화면에서는 토큰을 직접 저장하지 않고 이 Store를 사용합니다.
 */
export const useAuthStore = create(
  persist(
    (set) => ({
      accessToken: null,
      refreshToken: null,
      user: null,

      /**
       * 회원가입·로그인·재발급 응답을 저장합니다.
       * TokenResponse의 필드명과 동일하게 받습니다.
       */
      setSession: ({ accessToken, refreshToken, user }) => {
        set({
          accessToken,
          refreshToken,
          user,
        })
      },

      /** 로그아웃 또는 재발급 실패 시 로그인 정보를 제거합니다. */
      clear: () => {
        set({
          accessToken: null,
          refreshToken: null,
          user: null,
        })
      },
    }),
    {
      // 다른 프로젝트의 저장 정보와 구분하는 키입니다.
      name: AUTH_STORAGE_KEY,

      // 로그인 데이터만 저장하고 함수는 저장하지 않습니다.
      partialize: (state) => ({
        accessToken: state.accessToken,
        refreshToken: state.refreshToken,
        user: state.user,
      }),
    },
  ),
)

// 다른 탭이 로그인·재발급·로그아웃으로 저장값을 바꾸면 이 탭의 메모리에도 반영합니다.
// 반영하지 않으면 이 탭이 폐기된 Refresh Token으로 재발급을 시도해 모든 탭이 로그아웃됩니다.
if (typeof window !== 'undefined') {
  window.addEventListener('storage', (event) => {
    if (event.key === AUTH_STORAGE_KEY || event.key === null) {
      void useAuthStore.persist.rehydrate()
    }
  })
}
