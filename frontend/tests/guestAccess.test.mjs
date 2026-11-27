import test from 'node:test'
import assert from 'node:assert/strict'
import { guestScreenForPath } from '../src/models/guestAccess.js'

test('비로그인은 홈과 식단·운동 예시로 진입한다', () => {
  for (const path of ['/', '/dashboard', '/DASHBOARD/']) assert.equal(guestScreenForPath(path), 'home')
  assert.equal(guestScreenForPath('/recommend/'), 'meals')
  assert.equal(guestScreenForPath('/workout'), 'workout')
})

test('회원 전용 경로를 예시 화면으로 공개하지 않는다', () => {
  for (const path of ['/fridge', '/shopping', '/recipes/1', '/mypage', '/calendar', '/weight', '/dev/pose', '/workout/private']) {
    assert.equal(guestScreenForPath(path), undefined, path)
  }
})
