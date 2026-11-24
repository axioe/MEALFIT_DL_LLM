import { validRecipeId } from './recipeInventory.js'

export const DEFAULT_LOGIN_DESTINATION = '/dashboard'
export const LOGIN_RETURN_TTL = 15 * 60 * 1000

const APP_ORIGIN = 'https://mealfit.invalid'
const MAIN_PATHS = new Set([
  '/dashboard', '/recommend', '/fridge', '/shopping',
  '/workout', '/calendar', '/weight', '/mypage',
])

/** 로그인 화면이나 외부 주소로 되돌아가지 않고 실제 업무 화면만 허용합니다. */
export function safeLoginReturnPath(value) {
  if (typeof value !== 'string' || !value.startsWith('/') || value.startsWith('//')
      || value.trim() !== value || value.includes('\\')) return null
  if ([...value].some((character) => character.charCodeAt(0) < 32 || character.charCodeAt(0) === 127)) return null

  try {
    const url = new URL(value, APP_ORIGIN)
    if (url.origin !== APP_ORIGIN) return null
    const pathname = url.pathname === '/' ? DEFAULT_LOGIN_DESTINATION : url.pathname.replace(/\/$/, '')
    const recipeId = /^\/recipes\/([^/]+)$/.exec(pathname)?.[1]
    if (!MAIN_PATHS.has(pathname) && !validRecipeId(recipeId)) return null
    return pathname + url.search + url.hash
  } catch {
    return null
  }
}

export function loginDestination(value) {
  return safeLoginReturnPath(value) ?? DEFAULT_LOGIN_DESTINATION
}

/** 탭에 남은 오래된 OAuth 이동 의도나 조작된 주소는 사용하지 않습니다. */
export function readLoginReturnIntent(serialized, now = Date.now()) {
  try {
    const intent = JSON.parse(serialized)
    if (!Number.isFinite(now) || !Number.isFinite(intent?.createdAt)
        || intent.createdAt > now || now - intent.createdAt >= LOGIN_RETURN_TTL) return null
    return safeLoginReturnPath(intent.path)
  } catch {
    return null
  }
}
