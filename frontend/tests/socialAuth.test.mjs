import test from 'node:test'
import assert from 'node:assert/strict'
import {
  getEligibleSocialProvider,
  getSocialErrorMessage,
  shouldShowSocialLinkPrompt,
} from '../src/models/socialAuth.js'

test('이메일 도메인에 따라 Google·Naver·Kakao만 매핑하고 그 외 도메인은 null을 반환한다', () => {
  assert.equal(getEligibleSocialProvider('user@gmail.com'), 'google')
  assert.equal(getEligibleSocialProvider('USER@NAVER.COM'), 'naver')
  assert.equal(getEligibleSocialProvider('hello@kakao.com'), 'kakao')
  assert.equal(getEligibleSocialProvider('hello@daum.net'), 'kakao')
  assert.equal(getEligibleSocialProvider('hello@hanmail.net'), 'kakao')
  assert.equal(getEligibleSocialProvider('hello@outlook.com'), null)
  assert.equal(getEligibleSocialProvider('hello@company.co.kr'), null)
  assert.equal(getEligibleSocialProvider(''), null)
})

test('최초 1회 소셜 연동 팝업은 3개 도메인 일반 가입·미연동·미확인 회원에게만 노출된다', () => {
  const base = {
    userId: 10,
    socialAccounts: {
      hasPassword: true,
      eligibleProvider: 'google',
      linkedProviders: [],
      canManageSocialLinks: true,
    },
    dismissed: false,
  }

  assert.equal(shouldShowSocialLinkPrompt(base), true)
  // 이미 한 번 봤거나 닫은 경우
  assert.equal(shouldShowSocialLinkPrompt({ ...base, dismissed: true }), false)
  // 이미 소셜 로그인으로 가입한 경우(비밀번호 없음)
  assert.equal(
    shouldShowSocialLinkPrompt({
      ...base,
      socialAccounts: { ...base.socialAccounts, hasPassword: false },
    }),
    false,
  )
  // 이미 소셜 연동된 경우
  assert.equal(
    shouldShowSocialLinkPrompt({
      ...base,
      socialAccounts: { ...base.socialAccounts, linkedProviders: ['google'] },
    }),
    false,
  )
  // 3개 도메인 외 이메일로 가입한 경우
  assert.equal(
    shouldShowSocialLinkPrompt({
      ...base,
      socialAccounts: {
        ...base.socialAccounts,
        eligibleProvider: null,
        canManageSocialLinks: false,
      },
    }),
    false,
  )
})

test('OAuth 오류 코드를 사용자 안내 문구로 변환한다', () => {
  assert.match(getSocialErrorMessage('email_exists'), /마이페이지/)
  assert.match(getSocialErrorMessage('domain_mismatch'), /일치하는 소셜/)
  assert.equal(getSocialErrorMessage(null), null)
})
