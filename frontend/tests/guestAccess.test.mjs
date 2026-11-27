import test from 'node:test'
import assert from 'node:assert/strict'
import { guestScreenForPath } from '../src/models/guestAccess.js'
import { recipeCatalogPage } from '../src/models/recipeInventory.js'

test('비로그인은 홈과 식단·운동 예시로 진입한다', () => {
  for (const path of ['/', '/dashboard', '/DASHBOARD/']) assert.equal(guestScreenForPath(path), 'home')
  assert.equal(guestScreenForPath('/recommend/'), 'meals')
  assert.equal(guestScreenForPath('/workout'), 'workout')
})

test('공용 목록 및 숫자 ID 상세는 공개 조회 화면으로 진입한다', () => {
  assert.equal(guestScreenForPath('/recipes/'), 'catalog')
  assert.equal(guestScreenForPath('/recipes/2481'), 'recipe')
  for (const value of [null, '', 'wrong', '-1', '1.5', '99999999999']) assert.equal(recipeCatalogPage(value), 1)
  assert.equal(recipeCatalogPage('104'), 104)
})

test('회원 전용 경로와 잘못된 레시피 경로는 게스트 화면으로 열지 않는다', () => {
  for (const path of ['/fridge', '/shopping', '/recipes/0', '/recipes/1/extra', '/mypage', '/calendar', '/weight', '/dev/pose', '/workout/private']) {
    assert.equal(guestScreenForPath(path), undefined, path)
  }
})
