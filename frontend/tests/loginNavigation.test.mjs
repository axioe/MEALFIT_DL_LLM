import test from 'node:test'
import assert from 'node:assert/strict'
import { createMemoryRouter } from 'react-router-dom'
import { NAV_ITEMS } from '../src/components/layout/navItems.js'
import {
  DEFAULT_LOGIN_DESTINATION, LOGIN_RETURN_TTL,
  loginDestination, readLoginReturnIntent, safeLoginReturnPath,
} from '../src/models/loginNavigation.js'
import { createLoginReturnStore, loginAndNavigate, resumeSocialLogin } from '../src/hooks/loginNavigation.js'

function returnStore() {
  const entries = new Map()
  let time = 1_000_000
  const storage = {
    getItem: (key) => entries.get(key) ?? null,
    setItem: (key, value) => entries.set(key, value),
    removeItem: (key) => entries.delete(key),
  }
  return {
    entries,
    store: createLoginReturnStore({ getStorage: () => storage, now: () => time }),
    reload: () => createLoginReturnStore({ getStorage: () => storage, now: () => time }),
    advance: (duration) => { time += duration },
  }
}

function routerAt(t, entries) {
  const router = createMemoryRouter(
    ['/login', '/dashboard', '/fridge', '/shopping', '/mypage', '/recipes/:id']
      .map((path) => ({ path, Component: () => null })),
    { initialEntries: entries },
  )
  t.after(() => router.dispose())
  return router
}

test('PC·모바일 공통 메뉴의 모든 목적지는 로그인 복귀가 가능한 업무 경로다', () => {
  for (const item of NAV_ITEMS) assert.equal(safeLoginReturnPath(item.to), item.to)
  assert.equal(loginDestination('/'), '/dashboard')
  assert.equal(loginDestination('/shopping/'), '/shopping')
})

test('날짜·인분 쿼리와 앵커를 유지하며 유효한 레시피 상세로 복귀한다', () => {
  const target = '/recipes/9223372036854775807?servings=2&date=2026-11-24#ingredients'
  assert.equal(loginDestination(target), target)
  assert.equal(loginDestination('/recommend?date=2026-11-25#dinner'), '/recommend?date=2026-11-25#dinner')
})

test('외부 주소·우회 표기·공개 인증 화면·존재하지 않는 경로는 대시보드로 대체한다', () => {
  for (const value of [
    undefined, null, {}, '', 'shopping', 'https://example.com/shopping',
    '//example.com/shopping', '///example.com', '/\\example.com', '/%5c%5cexample.com',
    ' /shopping', '/shopping ', '/shop\nping', '/shopping\t',
    '/login', '/login?from=/shopping', '/signup', '/verify-email?token=fixture',
    '/api/v1/me', '/oauth2/authorization/google', '/unknown', '/shopping/unknown',
    '/recipes/0', '/recipes/-1', '/recipes/abc', '/recipes/9223372036854775808',
    '/recipes/1/extra', '/shopping/../login',
  ]) {
    assert.equal(safeLoginReturnPath(value), null, String(value))
    assert.equal(loginDestination(value), DEFAULT_LOGIN_DESTINATION, String(value))
  }
})

test('이메일 로그인 성공 후 원래 화면으로 replace하고 뒤로 가면 로그인 화면을 건너뛴다', async (t) => {
  const target = '/shopping?filter=unpurchased#items'
  const router = routerAt(t, ['/fridge', { pathname: '/login', state: { from: target } }])
  const { store } = returnStore()
  store.save('/mypage')
  let sentBody
  const session = { user: { id: 1 } }
  const result = await loginAndNavigate({
    form: { email: ' MEMBER@Example.com ', password: ' keep spaces ' },
    signIn: async (body) => { sentBody = body; return session },
    returnTo: router.state.location.state.from,
    navigate: router.navigate,
    returns: store,
  })
  assert.equal(result, session)
  assert.deepEqual(sentBody, { email: 'member@example.com', password: ' keep spaces ' })
  assert.equal(router.state.location.pathname, '/shopping')
  assert.equal(router.state.location.search, '?filter=unpurchased')
  assert.equal(router.state.location.hash, '#items')
  assert.equal(router.state.location.state, null)
  assert.equal(router.state.historyAction, 'REPLACE')
  assert.equal(store.peek(), null)
  await router.navigate(-1)
  assert.equal(router.state.location.pathname, '/fridge')
})

test('잘못된 복귀 주소를 넘겨도 실제 라우터는 대시보드로 이동한다', async (t) => {
  const router = routerAt(t, ['/login'])
  const { store } = returnStore()
  await loginAndNavigate({
    form: { email: 'member@example.com', password: 'fixture' },
    signIn: async () => ({}), returnTo: '//example.com', navigate: router.navigate, returns: store,
  })
  assert.equal(router.state.location.pathname, '/dashboard')
  assert.equal(router.state.historyAction, 'REPLACE')
})

test('인증 오류나 통신 실패 시 이동하지 않고 소셜 로그인 복귀 주소도 유지한다', async (t) => {
  const router = routerAt(t, ['/login'])
  const { store } = returnStore()
  for (const error of [new Error('fixture network failure'), { response: { status: 401 } }]) {
    store.save('/shopping')
    await assert.rejects(loginAndNavigate({
      form: { email: 'member@example.com', password: 'fixture' },
      signIn: async () => { throw error }, returnTo: '/shopping', navigate: router.navigate, returns: store,
    }), (received) => received === error)
    assert.equal(router.state.location.pathname, '/login')
    assert.equal(store.peek(), '/shopping')
  }
})

test('OAuth 페이지 왕복 후에도 주소만 보관하며 인증·회원 확인이 끝나기 전에는 이동하지 않는다', async (t) => {
  const router = routerAt(t, ['/dashboard'])
  const { store, reload, entries } = returnStore()
  const target = '/recipes/12?servings=3#steps'
  store.save(target)
  assert.deepEqual(JSON.parse([...entries.values()][0]), { path: target, createdAt: 1_000_000 })
  const afterReload = reload()
  for (const status of ['restoring', 'checking-user', 'restore-error', 'user-error', 'anonymous']) {
    assert.equal(await resumeSocialLogin({ status, location: router.state.location, navigate: router.navigate, returns: afterReload }), false)
    assert.equal(afterReload.peek(), target)
    assert.equal(router.state.location.pathname, '/dashboard')
  }
  assert.equal(await resumeSocialLogin({ status: 'authenticated', location: router.state.location, navigate: router.navigate, returns: afterReload }), true)
  assert.equal(router.state.location.pathname, '/recipes/12')
  assert.equal(router.state.location.search, '?servings=3')
  assert.equal(router.state.location.hash, '#steps')
  assert.equal(router.state.historyAction, 'REPLACE')
  assert.equal(afterReload.peek(), null)
  await router.navigate('/dashboard')
  assert.equal(await resumeSocialLogin({ status: 'authenticated', location: router.state.location, navigate: router.navigate, returns: afterReload }), false)
  assert.equal(router.state.location.pathname, '/dashboard')
})

test('소셜 계정 연동의 마이페이지 복귀와 다른 업무 화면 진입은 가로채지 않는다', async (t) => {
  const router = routerAt(t, ['/mypage?socialLinked=google'])
  const { store } = returnStore()
  store.save('/shopping')
  assert.equal(await resumeSocialLogin({ status: 'authenticated', location: router.state.location, navigate: router.navigate, returns: store }), false)
  assert.equal(router.state.location.pathname, '/mypage')
  assert.equal(router.state.location.search, '?socialLinked=google')
  assert.equal(store.peek(), null)
})

test('기본 대시보드 목적지는 OAuth 복귀를 반복하지 않는다', async (t) => {
  const router = routerAt(t, ['/dashboard'])
  const { store } = returnStore()
  store.save('/dashboard')
  assert.equal(await resumeSocialLogin({ status: 'authenticated', location: router.state.location, navigate: router.navigate, returns: store }), false)
  assert.equal(router.state.historyAction, 'POP')
  assert.equal(store.peek(), null)
})

test('만료·미래 시각·조작된 주소·깨진 저장 값은 복귀에 쓰지 않는다', () => {
  const serialized = (path, createdAt) => JSON.stringify({ path, createdAt })
  assert.equal(readLoginReturnIntent(serialized('/shopping', 100), 100 + LOGIN_RETURN_TTL - 1), '/shopping')
  const now = 1_000_000
  for (const value of [
    serialized('/shopping', now - LOGIN_RETURN_TTL), serialized('/shopping', now + 1),
    serialized('https://example.com', now), serialized('/login', now),
    serialized('/shopping', '1000000'), '{}', 'null', 'broken json',
  ]) assert.equal(readLoginReturnIntent(value, now), null)
  const { store, advance } = returnStore()
  store.save('/shopping')
  advance(LOGIN_RETURN_TTL)
  assert.equal(store.take(), null)
})

test('탭 저장소 사용이 막혀도 이메일 로그인과 기존 대시보드 복귀는 동작한다', async (t) => {
  const router = routerAt(t, ['/login'])
  const store = createLoginReturnStore({ getStorage: () => { throw new Error('fixture storage denied') } })
  assert.doesNotThrow(() => store.save('/shopping'))
  assert.equal(store.peek(), null)
  await loginAndNavigate({
    form: { email: 'member@example.com', password: 'fixture' }, signIn: async () => ({}),
    returnTo: '/shopping', navigate: router.navigate, returns: store,
  })
  assert.equal(router.state.location.pathname, '/shopping')
})
