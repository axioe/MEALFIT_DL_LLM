import { useNavigate } from 'react-router-dom'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { authApi } from '@/api/auth'
import { queryKeys } from '@/api/queryKeys'
import { useAuthStore } from '@/stores/authStore'

/**
 * 로그인 성공 시 이전 회원의 캐시를 비우고
 * 서버에서 받은 새 로그인 정보를 저장합니다.
 */
function useSessionMutation(mutationFn) {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn,

    // 인증 요청은 자동 반복하지 않습니다.
    retry: false,

    onSuccess: async (session) => {
      await queryClient.cancelQueries()
      queryClient.clear()
      useAuthStore.getState().setSession(session)
    },
  })
}

/** [이메일인증] 회원가입은 인증 메일 발송까지만 수행하고 토큰을 저장하지 않습니다. */
export function useSignup() {
  return useMutation({
    mutationFn: authApi.signup,
    retry: false,
  })
}

/** [이메일인증] 메일 링크의 토큰을 서버에 검증 요청합니다. */
export function useConfirmEmailVerification() {
  return useMutation({
    mutationFn: authApi.confirmEmailVerification,
    retry: false,
  })
}

/** [이메일인증] 인증 메일 재발송을 요청합니다. */
export function useResendEmailVerification() {
  return useMutation({
    mutationFn: authApi.resendEmailVerification,
    retry: false,
  })
}

/** 이메일 로그인 성공 후 토큰과 회원 정보를 저장합니다. */
export function useLogin() {
  return useSessionMutation(authApi.login)
}

/**
 * [HttpOnly쿠키] 서버에서 쿠키의 Refresh Token을 폐기한 뒤 로컬 상태를 정리합니다.
 * 서버 요청이 실패해도 이 브라우저의 로그인 정보는 제거합니다.
 */
export function useLogout() {
  const queryClient = useQueryClient()
  const navigate = useNavigate()

  return useMutation({
    retry: false,

    mutationFn: async () => {
      await authApi.logout()
    },

    onSettled: async () => {
      try {
        await navigate('/login', { replace: true, state: null })
      } finally {
        useAuthStore.getState().clear()
        try {
          await queryClient.cancelQueries()
        } finally {
          queryClient.clear()
        }
      }
    },
  })
}

/**
 * 서버가 인증한 현재 회원을 조회합니다. 저장된 토큰이 있을 때만 요청합니다.
 * 자동 갱신과 요청 재시도는 공통 Axios 클라이언트가 담당합니다.
 */
export function useCurrentUser({ enabled }) {
  const userId = useAuthStore((state) => state.user?.id)
  return useQuery({
    queryKey: queryKeys.auth.me(userId),
    queryFn: authApi.getMe,
    enabled,
    staleTime: 0,
    refetchOnMount: 'always',
    retry: false,
  })
}

/** [소셜로그인] 로그인한 회원의 소셜 연동 현황을 조회합니다. */
export function useSocialAccounts() {
  const userId = useAuthStore((state) => state.user?.id)
  const accessToken = useAuthStore((state) => state.accessToken)
  return useQuery({
    queryKey: ['auth', 'socialAccounts', userId],
    queryFn: authApi.getSocialAccounts,
    enabled: Boolean(userId && accessToken),
    staleTime: 30_000,
    retry: false,
  })
}

/** [소셜로그인] 마이페이지·최초 1회 팝업에서 OAuth2 연동 쿠키를 발급합니다. */
export function usePrepareSocialLink() {
  return useMutation({
    mutationFn: authApi.prepareSocialLink,
    retry: false,
  })
}

/** [소셜로그인] 연동된 소셜 계정을 해제하고 연동 현황 캐시를 갱신합니다. */
export function useUnlinkSocialAccount() {
  const queryClient = useQueryClient()
  const userId = useAuthStore((state) => state.user?.id)
  return useMutation({
    mutationFn: authApi.unlinkSocialAccount,
    retry: false,
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ['auth', 'socialAccounts', userId] })
    },
  })
}
