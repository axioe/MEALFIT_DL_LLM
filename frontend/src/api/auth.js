import { api } from '@/api/client'

/** 인증 요청도 기존 공통 Axios 인스턴스만 사용합니다. */
export const authApi = {
  signup: (body) =>
    api.post('/auth/signup', body).then((response) => response.data),

  login: (body) =>
    api.post('/auth/login', body).then((response) => response.data),

  getMe: () =>
    api.get('/me').then((response) => response.data),

  logout: (refreshToken) =>
    api.post('/auth/logout', { refreshToken }),
}
