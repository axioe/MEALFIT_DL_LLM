import { api } from '@/api/client'

/** 인증 요청도 기존 공통 Axios 인스턴스만 사용합니다. */
export const authApi = {
  // [이메일인증] 회원가입 시 토큰 없이 안내 응답(SignupResponse)을 받습니다.
  signup: (body) =>
    api.post('/auth/signup', body).then((response) => response.data),

  // [이메일인증] 메일 링크 토큰으로 이메일 인증 완료 처리
  confirmEmailVerification: (token) =>
    api.post('/auth/email-verification/confirm', { token }),

  // [이메일인증] 미인증 계정 인증 메일 재발송 요청
  resendEmailVerification: (email) =>
    api.post('/auth/email-verification/resend', { email }),

  login: (body) =>
    api.post('/auth/login', body).then((response) => response.data),

  getMe: () =>
    api.get('/me').then((response) => response.data),

  // [HttpOnly쿠키] 서버가 HttpOnly 쿠키의 Refresh Token을 읽어 폐기 및 삭제합니다.
  logout: () =>
    api.post('/auth/logout'),

  // [소셜로그인] 내 소셜 연동 현황 조회 (3개 도메인·소셜 연동 여부 포함)
  getSocialAccounts: () =>
    api.get('/me/social-accounts').then((response) => response.data),

  // [소셜로그인] OAuth2 연동 시작 전 1회용 연동 쿠키 발급 요청
  prepareSocialLink: (provider) =>
    api.post('/auth/social/link-intent', { provider }),

  // [소셜로그인] 연동된 특정 소셜 계정 해제
  unlinkSocialAccount: (provider) =>
    api.delete(`/me/social-accounts/${encodeURIComponent(provider)}`),
}
