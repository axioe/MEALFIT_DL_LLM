import test from 'node:test'
import assert from 'node:assert/strict'
import axios from 'axios'
import { installSessionInterceptors } from '../src/hooks/sessionClient.js'
import { createSessionRecovery } from '../src/hooks/sessionRecovery.js'
import { SessionChangedError } from '../src/models/sessionScope.js'
import { deferred, fixture, session } from './helpers/sessionFixture.mjs'

function httpFailure(config, status) {
  return new axios.AxiosError('fixture HTTP failure', 'ERR_BAD_RESPONSE', config, null,
    { config, status, statusText: 'fixture', data: { code: status === 401 ? 'AUTH_005' : 'FIXTURE' }, headers: {} })
}
function setup(handler) {
  const { store, client } = fixture()
  const api = axios.create({ adapter: async (config) => ({
    data: await handler(config), config, status: 200, statusText: 'OK', headers: {},
  }) })
  const recovery = createSessionRecovery({ store, client, request: (path, body) => api.post(path, body), withLock: (run) => run() })
  installSessionInterceptors(api, store, recovery)
  return { store, client, api, recovery }
}

test('실제 Axios의 401은 같은 세션의 토큰을 재발급하고 원래 요청을 한 번 재시도한다', async () => {
  const sent = []
  const { store, client, api } = setup(async (config) => {
    sent.push([config.url, config.headers.get('Authorization')])
    if (config.url === '/auth/refresh') return session(1, 'renewed')
    if (config.headers.get('Authorization') === 'Bearer old') throw httpFailure(config, 401)
    return { quantity: 20 }
  })
  store.getState().setSession(session(1, 'old'))
  const version = store.getState().sessionVersion
  assert.deepEqual((await api.get('/inventory/lots')).data, { quantity: 20 })
  assert.deepEqual(sent, [
    ['/inventory/lots', 'Bearer old'], ['/auth/refresh', undefined], ['/inventory/lots', 'Bearer renewed'],
  ])
  assert.equal(store.getState().sessionVersion, version)
  client.clear()
})

for (const failure of ['network', 'timeout', 503]) {
  test(`실제 Axios 재발급의 ${failure} 실패는 현재 계정·캐시를 유지한다`, async () => {
    const { store, client, api } = setup(async (config) => {
      if (config.url !== '/auth/refresh') throw httpFailure(config, 401)
      if (failure === 'network') throw new axios.AxiosError('fixture', 'ERR_NETWORK', config)
      if (failure === 'timeout') throw new axios.AxiosError('fixture', 'ECONNABORTED', config)
      throw httpFailure(config, failure)
    })
    store.getState().setSession(session(1, 'retained'))
    client.setQueryData(['shopping'], 'retained')
    await assert.rejects(api.get('/inventory/lots'))
    assert.equal(store.getState().accessToken, 'retained')
    assert.equal(client.getQueryData(['shopping']), 'retained')
    client.clear()
  })
}

test('실제 Axios 재발급 401은 세션과 캐시를 종료한다', async () => {
  const { store, client, api } = setup(async (config) => { throw httpFailure(config, 401) })
  store.getState().setSession(session())
  client.setQueryData(['shopping'], 'old')
  await assert.rejects(api.get('/inventory/lots'))
  assert.equal(store.getState().accessToken, null)
  assert.equal(client.getQueryData(['shopping']), undefined)
})

test('갱신 후에도 401이면 다시 재발급하지 않는다', async () => {
  const paths = []
  const { store, client, api } = setup(async (config) => {
    paths.push(config.url)
    if (config.url === '/auth/refresh') return session(1, 'renewed')
    throw httpFailure(config, 401)
  })
  store.getState().setSession(session())
  await assert.rejects(api.get('/inventory/lots'))
  assert.deepEqual(paths, ['/inventory/lots', '/auth/refresh', '/inventory/lots'])
  assert.equal(store.getState().accessToken, null)
  client.clear()
})

for (const status of [200, 401, 503]) {
  test(`다른 계정 로그인 뒤 도착한 조회 ${status} 응답은 새 계정에서 재시도·반영하지 않는다`, async () => {
    const pending = deferred(), started = deferred(), paths = []
    const { store, client, api } = setup(async (config) => {
      paths.push(config.url)
      started.resolve()
      await pending.promise
      if (status !== 200) throw httpFailure(config, status)
      return 'old-account'
    })
    store.getState().setSession(session(1))
    let applied = false
    const result = api.get('/shopping-items').then(() => { applied = true })
    const rejected = assert.rejects(result, SessionChangedError)
    await started.promise
    store.getState().setSession(session(2))
    pending.resolve()
    await rejected
    assert.equal(applied, false)
    assert.equal(store.getState().user.id, 2)
    assert.deepEqual(paths, ['/shopping-items'])
    client.clear()
  })
}

test('동시에 도착한 401은 실제 Axios에서도 재발급을 하나만 보낸다', async () => {
  const refreshing = deferred(), started = deferred()
  let refreshCalls = 0
  const { store, client, api } = setup(async (config) => {
    if (config.url === '/auth/refresh') {
      refreshCalls++
      started.resolve()
      await refreshing.promise
      return session(1, 'renewed')
    }
    if (config.headers.get('Authorization') !== 'Bearer renewed') throw httpFailure(config, 401)
    return config.url
  })
  store.getState().setSession(session(1, 'old'))
  const first = api.get('/inventory/lots'), second = api.get('/shopping-items')
  await started.promise
  refreshing.resolve()
  await Promise.all([first, second])
  assert.equal(refreshCalls, 1)
  client.clear()
})
