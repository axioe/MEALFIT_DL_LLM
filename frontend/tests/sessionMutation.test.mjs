import test from 'node:test'
import assert from 'node:assert/strict'
import { MutationObserver } from '@tanstack/react-query'
import { captureSession, SessionChangedError } from '../src/models/sessionScope.js'
import { sessionMutationCallbacks, sessionMutationOptions } from '../src/hooks/sessionMutation.js'
import { deferred, fixture, session } from './helpers/sessionFixture.mjs'

for (const nextUser of [1, 2]) {
  test(`계정 ${nextUser}의 새 로그인 후 늦은 저장 결과는 캐시·콜백에 반영하지 않는다`, async () => {
    const { store, client } = fixture()
    const pending = deferred(), started = deferred(), calls = []
    store.getState().setSession(session(1))
    const options = sessionMutationOptions({
      retry: false,
      mutationFn: () => { started.resolve(); return pending.promise },
      onSuccess: (result) => { calls.push('success'); client.setQueryData(['shopping'], result) },
      onError: () => calls.push('error'),
      onSettled: () => calls.push('settled'),
    }, store.getState)
    const observer = new MutationObserver(client, options)
    const result = observer.mutate({ variables: { action: 'purchase' }, scope: captureSession(store.getState()) })
    const rejected = assert.rejects(result, SessionChangedError)
    await started.promise
    client.clear()
    store.getState().setSession(session(nextUser, 'new-login'))
    client.setQueryData(['shopping'], 'new-session')
    pending.resolve('old-session')
    await rejected
    assert.equal(client.getQueryData(['shopping']), 'new-session')
    assert.deepEqual(calls, [])
    client.clear()
  })
}

test('조회 취소를 기다리던 저장 요청은 계정이 바뀌면 서버에 보내지 않는다', async () => {
  const { store, client } = fixture()
  store.getState().setSession(session())
  const waiting = deferred(), started = deferred()
  let sent = false
  const observer = new MutationObserver(client, sessionMutationOptions({
    onMutate: () => { started.resolve(); return waiting.promise },
    mutationFn: () => { sent = true },
    retry: false,
  }, store.getState))
  const result = observer.mutate({ variables: {}, scope: captureSession(store.getState()) })
  const rejected = assert.rejects(result, SessionChangedError)
  await started.promise
  store.getState().setSession(session(2))
  waiting.resolve()
  await rejected
  assert.equal(sent, false)
  client.clear()
})

test('토큰 재발급 중인 정상 저장은 원래 변수·컨텍스트와 함께 성공 처리한다', async () => {
  const { store, client } = fixture()
  store.getState().setSession(session())
  const pending = deferred(), started = deferred(), calls = []
  const variables = { action: 'purchase', body: { quantity: 20 } }
  const observer = new MutationObserver(client, sessionMutationOptions({
    retry: false,
    onMutate: (input) => { assert.equal(input, variables); return 'context' },
    mutationFn: (input) => { assert.equal(input, variables); started.resolve(); return pending.promise },
    onSuccess: (data, input, context) => calls.push([data, input, context]),
    onSettled: (_data, _error, input) => assert.equal(input, variables),
  }, store.getState))
  const result = observer.mutate({ variables, scope: captureSession(store.getState()) })
  await started.promise
  store.getState().updateSession(session(1, 'renewed'))
  pending.resolve('saved')
  assert.equal(await result, 'saved')
  assert.deepEqual(calls, [['saved', variables, 'context']])
  client.clear()
})

test('호출자가 전달한 콜백도 옛 세션의 결과를 받지 않는다', () => {
  const { store, client } = fixture()
  store.getState().setSession(session())
  const scope = captureSession(store.getState()), calls = []
  const callbacks = sessionMutationCallbacks({
    onSuccess: () => calls.push('success'), onError: () => calls.push('error'), onSettled: () => calls.push('settled'),
  }, store.getState)
  store.getState().setSession(session(2))
  const packed = { variables: {}, scope }
  callbacks.onSuccess('old', packed)
  callbacks.onError(new Error('old'), packed)
  callbacks.onSettled('old', null, packed)
  assert.deepEqual(calls, [])
  client.clear()
})
