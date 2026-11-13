// 로그인·회원가입 입력 규칙 (화면 검증. 최종 검증·중복 검사는 서버가 한다)

/** 이메일은 앞뒤 공백 제거·소문자. 비밀번호의 공백은 임의로 제거하지 않는다 */
export function buildLoginBody({ email, password }) {
  return { email: email.trim().toLowerCase(), password }
}

export function buildSignupBody({ email, password, nickname }) {
  return { email: email.trim().toLowerCase(), password, nickname: nickname.trim() }
}

/** 가입 전 화면 검증. 문제가 없으면 빈 문자열 */
export function validateSignupForm({ password, nickname }) {
  if (!nickname.trim()) return '닉네임을 입력해 주세요.'
  // 글자 수와 UTF-8 바이트 수는 다르다. BCrypt 제한(72바이트)을 확인한다
  if (new TextEncoder().encode(password).length > 72) return '비밀번호는 UTF-8 기준 72바이트 이하로 입력해 주세요.'
  return ''
}
