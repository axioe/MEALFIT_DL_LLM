import test from 'node:test'
import assert from 'node:assert/strict'
import { AUTH_STORAGE_KEY, coordinateRefresh, LoggedOutError, readPersistedSession, withTabLock } from '../src/lib/tabSession.js'

/** localStorage 흉내 */
function memoryStorage() {
  const data = new Map()
  return { getItem: (k) => data.get(k) ?? null, setItem: (k, v) => data.set(k, String(v)) }
}

const save = (storage, state) => storage.setItem(AUTH_STORAGE_KEY, JSON.stringify({ state, version: 0 }))

/** navigator.locks 흉내: 같은 이름의 요청을 하나씩 순서대로 실행한다 */
function fakeLocks() {
  let tail = Promise.resolve()
  return {
    request(_name, fn) {
      const run = tail.then(() => fn())
      tail = run.catch(() => {})
      return run
    },
  }
}

/** 서버 흉내: 쓴 Refresh Token은 폐기, 폐기된 토큰을 다시 쓰면 재사용 오류 */
function fakeServer() {
  let n = 0
  const revoked = new Set()
  return {
    calls: 0,
    async refresh(token) {
      this.calls += 1
      await new Promise((r) => setTimeout(r, 5))
      if (revoked.has(token)) throw new Error('REUSE')
      revoked.add(token)
      n += 1
      return { accessToken: `A${n}`, refreshToken: `R${n}`, user: { id: 1 } }
    },
  }
}

function tab(storage, server, locks, original) {
  return coordinateRefresh({
    originalRefreshToken: original,
    readLatest: () => readPersistedSession(storage),
    refresh: (t) => server.refresh(t),
    apply: (session) => save(storage, session),
    withLock: (fn) => withTabLock(fn, 'lock', locks),
  })
}

test('두 탭이 동시에 재발급해도 서버 호출은 한 번이고 둘 다 새 토큰을 쓴다', async () => {
  const storage = memoryStorage()
  save(storage, { accessToken: 'A0', refreshToken: 'R0', user: { id: 1 } })
  const server = fakeServer()
  const locks = fakeLocks()

  const [a, b] = await Promise.all([tab(storage, server, locks, 'R0'), tab(storage, server, locks, 'R0')])

  assert.equal(server.calls, 1)
  assert.equal(a.session.refreshToken, 'R1')
  assert.equal(b.session.refreshToken, 'R1')
  assert.deepEqual([a.refreshed, b.refreshed].sort(), [false, true])
})

test('잠금이 없으면 두 번째 탭이 폐기된 토큰을 다시 써서 실패한다 (고치기 전 동작)', async () => {
  const storage = memoryStorage()
  save(storage, { accessToken: 'A0', refreshToken: 'R0', user: { id: 1 } })
  const server = fakeServer()
  const noLock = { request: (_n, fn) => fn() }
  const results = await Promise.allSettled([tab(storage, server, noLock, 'R0'), tab(storage, server, noLock, 'R0')])
  assert.equal(results.filter((r) => r.status === 'rejected').length, 1)
})

test('다른 탭에서 로그아웃했으면 재발급하지 않고 로그아웃으로 처리한다', async () => {
  const storage = memoryStorage()
  save(storage, { accessToken: null, refreshToken: null, user: null })
  const server = fakeServer()
  await assert.rejects(tab(storage, server, fakeLocks(), 'R0'), LoggedOutError)
  assert.equal(server.calls, 0)
})

test('저장값이 없거나 깨졌으면 null', () => {
  const storage = memoryStorage()
  assert.equal(readPersistedSession(storage), null)
  storage.setItem(AUTH_STORAGE_KEY, '{broken')
  assert.equal(readPersistedSession(storage), null)
})

test('Web Locks가 없으면 그대로 실행한다', async () => {
  assert.equal(await withTabLock(async () => 7, 'x', undefined), 7)
})
