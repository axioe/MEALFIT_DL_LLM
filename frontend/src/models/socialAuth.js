import { SOCIAL_PROVIDER } from '../lib/enums.js'

/**
 * [소셜로그인] Google·Naver·Kakao 도메인 매핑, 최초 1회 연동 팝업 노출 판정, 오류 메시지 변환 순수 모델입니다.
 */

export const SOCIAL_PROVIDERS = [
  {
    id: SOCIAL_PROVIDER.GOOGLE,
    label: 'Google',
    buttonText: 'Google로 계속하기',
    authPath: `/oauth2/authorization/${SOCIAL_PROVIDER.GOOGLE}`,
  },
  {
    id: SOCIAL_PROVIDER.NAVER,
    label: '네이버',
    buttonText: '네이버로 계속하기',
    authPath: `/oauth2/authorization/${SOCIAL_PROVIDER.NAVER}`,
  },
  {
    id: SOCIAL_PROVIDER.KAKAO,
    label: '카카오',
    buttonText: '카카오로 계속하기',
    authPath: `/oauth2/authorization/${SOCIAL_PROVIDER.KAKAO}`,
  },
]

const DOMAIN_TO_PROVIDER = {
  'gmail.com': SOCIAL_PROVIDER.GOOGLE,
  'naver.com': SOCIAL_PROVIDER.NAVER,
  'kakao.com': SOCIAL_PROVIDER.KAKAO,
  'daum.net': SOCIAL_PROVIDER.KAKAO,
  'hanmail.net': SOCIAL_PROVIDER.KAKAO,
}

const PROMPT_KEY_PREFIX = 'mealfit-social-link-prompt-seen:'

/** [소셜로그인] 이메일 도메인이 3개 소셜 플랫폼 중 하나에 해당하면 provider id를 반환합니다. */
export function getEligibleSocialProvider(email) {
  if (!email || typeof email !== 'string') return null
  const at = email.lastIndexOf('@')
  if (at < 0 || at === email.length - 1) return null
  const domain = email.slice(at + 1).trim().toLowerCase()
  return DOMAIN_TO_PROVIDER[domain] ?? null
}

/** [소셜로그인] provider id에 해당하는 화면 표시 정보를 반환합니다. */
export function getSocialProviderMeta(providerId) {
  return SOCIAL_PROVIDERS.find((item) => item.id === providerId) ?? null
}

/** [소셜로그인] 회원별 최초 1회 팝업 확인 키를 생성합니다. */
export function getSocialPromptStorageKey(userId) {
  return `${PROMPT_KEY_PREFIX}${String(userId)}`
}

/**
 * [소셜로그인] 최초 1회 소셜 연동 팝업을 띄워야 하는지 판정합니다.
 * - 기존 이메일 가입자(hasPassword=true)
 * - 3개 소셜 도메인(@gmail/@naver/@kakao·daum·hanmail) 중 하나(eligibleProvider != null)
 * - 아직 연동된 소셜 계정이 없음(linkedProviders.length === 0)
 * - 이 브라우저에서 아직 팝업을 본 적이 없음(dismissed === false)
 */
export function shouldShowSocialLinkPrompt({ userId, socialAccounts, dismissed }) {
  if (!userId || !socialAccounts || dismissed) return false
  if (!socialAccounts.hasPassword) return false
  if (!socialAccounts.eligibleProvider) return false
  const linked = Array.isArray(socialAccounts.linkedProviders)
    ? socialAccounts.linkedProviders
    : []
  return linked.length === 0
}

/** [소셜로그인] 로그인·연동 리다이렉트 쿼리의 오류 코드를 사용자 안내 문구로 바꿉니다. */
export function getSocialErrorMessage(code) {
  switch (code) {
    case 'email_exists':
      return '이미 이메일로 가입된 계정입니다. 일반 로그인 후 마이페이지에서 소셜 계정을 연동해 주세요.'
    case 'already_linked':
      return '이미 다른 계정에 연동된 소셜 계정입니다.'
    case 'domain_mismatch':
      return '현재 계정 이메일과 일치하는 소셜 플랫폼만 연동할 수 있습니다.'
    case 'invalid_intent':
      return '소셜 연동 요청이 만료되었습니다. 다시 시도해 주세요.'
    case 'oauth_failed':
      return '소셜 로그인을 완료하지 못했습니다. 다시 시도해 주세요.'
    default:
      return code ? '소셜 인증 처리 중 오류가 발생했습니다.' : null
  }
}
