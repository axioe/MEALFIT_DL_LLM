import { api } from '@/api/client'

/** 회원별로 프로필 조회 캐시를 구분합니다. */
export const profileKeys = {
  detail: (userId) => ['profile', userId],
  settings: (userId) => ['profileDetails', userId],
}

/** 로그인한 회원의 프로필 조회·수정 요청입니다. */
export const profileApi = {
  getDetails: () => api.get('/me/profile/details').then((response) => response.data),
  updateSection: ({ section, body }) =>
    api.put('/me/profile/details/' + section, body).then((response) => response.data),
  getProfile: () =>
    api.get('/me/profile').then((response) => response.data),

  updateProfile: (body) =>
    api.put('/me/profile', body).then((response) => response.data),
}
