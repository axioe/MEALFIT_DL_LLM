import test from 'node:test'
import assert from 'node:assert/strict'
import { captureSession, SessionChangedError } from '../src/models/sessionScope.js'
import { deferred, fixture, outage, serialLock, session } from './helpers/sessionFixture.mjs'

for (const status of [undefined, 403, 429, 500, 503, 504]) {
  test(`초기 복구의 ${status ?? '연결 실패'}는 인증 만료로 처리하지 않고 재시도할 수 있다`, async () => {
    let broken = true
    const error = outage(status)
    const { store, client, recovery } = fixture(async () => {
      if (broken) throw error
      return { data: session() }
    })
    client.setQueryData(['fixture'], 'retained')
    await assert.rejects(recovery.restore(), (failure) => failure === error)
    assert.equal(store.getState().bootstrapped, false)
    assert.equal(store.getState().restoring, false)
    assert.equal(store.getState().restoreError, error)
    assert.equal(client.getQueryData(['fixture']), 'retained')
    broken = false
    assert.equal(await recovery.restore(), 'fixture-1')
    assert.equal(store.getState().bootstrapped, true)
    assert.equal(store.getState().restoreError, null)
    assert.equal(store.getState().user.id, 1)
    client.clear()
  })
}

test('초기 복구의 401은 세션·캐시를 정리하고 비로그인 상태를 확정한다', async () => {
  const { store, client, recovery } = fixture(async () => { throw outage(401) })
  client.setQueryData(['fixture'], 'old')
  assert.equal(await recovery.restore(), null)
  assert.equal(store.getState().bootstrapped, true)
  assert.equal(store.getState().restoreError, null)
  assert.equal(store.getState().accessToken, null)
  assert.equal(client.getQueryData(['fixture']), undefined)
})

for (const status of [undefined, 500, 503, 504]) {
  test(`로그인 후 재발급의 ${status ?? '연결 실패'}는 현재 세션과 캐시를 유지한다`, async () => {
    const { store, client, recovery } = fixture(async () => { throw outage(status) })
    store.getState().setSession(session())
    const before = captureSession(store.getState())
    client.setQueryData(['fixture'], 'retained')
    await assert.rejects(recovery.refresh())
    assert.deepEqual(captureSession(store.getState()), before)
    assert.equal(store.getState().accessToken, 'fixture-1')
    assert.equal(client.getQueryData(['fixture']), 'retained')
    client.clear()
  })
}

test('로그인 후 재발급의 401은 기존 토큰과 캐시를 폐기한다', async () => {
  const { store, client, recovery } = fixture(async () => { throw outage(401) })
  store.getState().setSession(session())
  client.setQueryData(['fixture'], 'old')
  await assert.rejects(recovery.refresh())
  assert.equal(store.getState().accessToken, null)
  assert.equal(client.getQueryData(['fixture']), undefined)
})

test('같은 세션의 동시 재발급을 공유하고 토큰 갱신은 세션 버전을 바꾸지 않는다', async () => {
  const pending = deferred(), started = deferred()
  let calls = 0
  const { store, client, recovery } = fixture(() => { calls++; started.resolve(); return pending.promise })
  store.getState().setSession(session())
  const before = captureSession(store.getState())
  const first = recovery.refresh(), second = recovery.refresh()
  assert.equal(first, second)
  await started.promise
  pending.resolve({ data: session(1, 'renewed') })
  await Promise.all([first, second])
  assert.equal(calls, 1)
  assert.deepEqual(captureSession(store.getState()), before)
  assert.equal(store.getState().accessToken, 'renewed')
  client.clear()
})

for (const failed of [false, true]) {
  test(`계정 전환 뒤 도착한 초기 복구 ${failed ? '401' : '성공'} 응답은 새 세션·캐시를 건드리지 않는다`, async () => {
    const pending = deferred(), started = deferred()
    const { store, client, recovery } = fixture(() => { started.resolve(); return pending.promise })
    const restoring = recovery.restore()
    const rejected = assert.rejects(restoring, SessionChangedError)
    await started.promise
    store.getState().setSession(session(2))
    client.setQueryData(['fixture'], 'new-session')
    if (failed) pending.reject(outage(401))
    else pending.resolve({ data: session(1) })
    await rejected
    assert.equal(store.getState().user.id, 2)
    assert.equal(client.getQueryData(['fixture']), 'new-session')
    client.clear()
  })
}

test('같은 계정으로 다시 로그인해도 이전 재발급 응답을 버린다', async () => {
  const pending = deferred(), started = deferred()
  const { store, client, recovery } = fixture(() => { started.resolve(); return pending.promise })
  store.getState().setSession(session(1, 'old'))
  const refreshing = recovery.refresh()
  const rejected = assert.rejects(refreshing, SessionChangedError)
  await started.promise
  store.getState().setSession(session(1, 'new-login'))
  pending.resolve({ data: session(1, 'obsolete-refresh') })
  await rejected
  assert.equal(store.getState().accessToken, 'new-login')
  client.clear()
})

test('옛 복구 요청의 종료가 새 세션의 재발급 중복 방지를 해제하지 않는다', async () => {
  const old = deferred(), next = deferred(), started = deferred()
  let calls = 0
  const { store, client, recovery } = fixture(() => {
    calls++
    if (calls === 1) { started.resolve(); return old.promise }
    return next.promise
  })
  const first = recovery.restore(), rejected = assert.rejects(first, SessionChangedError)
  await started.promise
  store.getState().setSession(session(2))
  const second = recovery.refresh()
  old.resolve({ data: session(1) })
  await rejected
  assert.equal(recovery.refresh(), second)
  next.resolve({ data: session(2, 'new-refresh') })
  await second
  assert.equal(calls, 2)
  client.clear()
})

test('로그인과 복구는 같은 쿠키 잠금을 사용하고 오래된 복구는 새 로그인을 덮지 않는다', async () => {
  const pending = deferred(), started = deferred(), calls = []
  const { store, client, recovery } = fixture((path) => {
    calls.push(path)
    if (path === '/auth/refresh') { started.resolve(); return pending.promise }
    return Promise.resolve({ data: session(2) })
  }, serialLock())
  const restoring = recovery.restore(), rejected = assert.rejects(restoring, SessionChangedError)
  await started.promise
  const loggingIn = recovery.login({ fixture: true })
  assert.deepEqual(calls, ['/auth/refresh'])
  pending.resolve({ data: session(1) })
  await rejected
  await loggingIn
  assert.deepEqual(calls, ['/auth/refresh', '/auth/login'])
  assert.equal(store.getState().user.id, 2)
  client.clear()
})

test('늦게 실패한 로그아웃은 이후 로그인한 계정과 캐시를 지우지 않는다', async () => {
  const pending = deferred(), started = deferred()
  const { store, client, recovery } = fixture(() => { started.resolve(); return pending.promise })
  store.getState().setSession(session(1))
  const loggingOut = recovery.logout(), rejected = assert.rejects(loggingOut)
  assert.equal(store.getState().accessToken, null)
  await started.promise
  store.getState().setSession(session(2))
  client.setQueryData(['fixture'], 'new-session')
  pending.reject(outage(503))
  await rejected
  assert.equal(store.getState().user.id, 2)
  assert.equal(client.getQueryData(['fixture']), 'new-session')
  client.clear()
})

test('Web Locks가 없는 환경에서도 로그인·복구의 쿠키 요청 순서를 유지한다', async () => {
  const pending = deferred(), started = deferred(), calls = []
  const { store, client, recovery } = fixture(async (path) => {
    calls.push(path)
    if (path === '/auth/refresh') { started.resolve(); return pending.promise }
    return { data: session(2) }
  })
  const restoring = recovery.restore(), rejected = assert.rejects(restoring, SessionChangedError)
  await started.promise
  const loggingIn = recovery.login({ fixture: true })
  assert.deepEqual(calls, ['/auth/refresh'])
  pending.resolve({ data: session(1) })
  await Promise.all([rejected, loggingIn])
  assert.deepEqual(calls, ['/auth/refresh', '/auth/login'])
  assert.equal(store.getState().user.id, 2)
  client.clear()
})
