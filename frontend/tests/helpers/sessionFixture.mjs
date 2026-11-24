import { createStore } from 'zustand/vanilla'
import { QueryClient } from '@tanstack/react-query'
import { createAuthState } from '../../src/stores/authStore.js'
import { createSessionRecovery } from '../../src/hooks/sessionRecovery.js'

export const session = (id = 1, accessToken = `fixture-${id}`) => ({ accessToken, user: { id } })
export function deferred() {
  let resolve, reject
  const promise = new Promise((done, fail) => { resolve = done; reject = fail })
  return { promise, resolve, reject }
}
export function outage(status) {
  const error = new Error('fixture failure')
  if (status) error.response = { status }
  return error
}
export function serialLock() {
  let tail = Promise.resolve()
  return (operation) => {
    const next = tail.then(operation)
    tail = next.catch(() => {})
    return next
  }
}
export function fixture(request, withLock = (operation) => operation()) {
  const store = createStore(createAuthState)
  const client = new QueryClient({ defaultOptions: { queries: { retry: false, gcTime: Infinity } } })
  const recovery = createSessionRecovery({ store, client, request, withLock })
  return { store, client, recovery }
}
