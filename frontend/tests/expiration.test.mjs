import test from 'node:test'
import assert from 'node:assert/strict'

// 한국 시간으로 계산되는지 보려면 시간대를 고정해야 한다 (Node는 실행 중 TZ 변경을 반영한다)
process.env.TZ = 'Asia/Seoul'

const { getExpirationStatus } = await import('../src/lib/expiration.js')
const { today } = await import('../src/lib/date.js')

// 2026-11-16 23:30 UTC = 2026-11-17 08:30 KST (UTC 날짜는 아직 하루 전)
const BEFORE_9AM_KST = Date.parse('2026-11-16T23:30:00Z')

test('한국 시간 오전 9시 전에도 오늘은 한국 날짜다', (t) => {
  t.mock.timers.enable({ apis: ['Date'], now: BEFORE_9AM_KST })
  assert.equal(today(), '2026-11-17')
})

test('기준일을 넘기지 않으면 한국 날짜로 기한 상태를 계산한다', (t) => {
  t.mock.timers.enable({ apis: ['Date'], now: BEFORE_9AM_KST })
  assert.equal(getExpirationStatus('2026-11-16'), 'expired')
  assert.equal(getExpirationStatus('2026-11-17'), 'today')
  assert.equal(getExpirationStatus('2026-11-20'), 'imminent')
  assert.equal(getExpirationStatus('2026-11-21'), 'normal')
  assert.equal(getExpirationStatus(null), 'unknown')
})

test('기준일을 넘기면 그 날짜로 계산한다', () => {
  assert.equal(getExpirationStatus('2026-11-20', 3, '2026-11-21'), 'expired')
  assert.equal(getExpirationStatus('2026-11-21', 3, '2026-11-21'), 'today')
})
