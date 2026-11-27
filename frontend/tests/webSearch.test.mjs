import test from 'node:test'
import assert from 'node:assert/strict'
import { SEARCH_TYPE } from '../src/lib/enums.js'
import { queryKeys } from '../src/api/queryKeys.js'
import { normalizeSearchTerm, nextSearchOffset, SEARCH_GROUPS } from '../src/models/webSearch.js'

test('검색어의 앞뒤와 연속 공백을 정리하고 한글·특수문자를 보존한다', () => {
  assert.equal(normalizeSearchTerm('   김치  찌개  '), '김치 찌개')
  assert.equal(normalizeSearchTerm('  %계란_ '), '%계란_')
  assert.equal(normalizeSearchTerm('  '), '')
})

test('대상별로 실제 응답 항목 수만큼 이동하고 마지막·빈 페이지에서 멈춘다', () => {
  assert.equal(nextSearchOffset({ total: 12, items: [1, 2, 3, 4, 5] }), 5)
  assert.equal(nextSearchOffset({ total: 12, items: [6, 7, 8, 9, 10] }, 5), 10)
  assert.equal(nextSearchOffset({ total: 12, items: [11, 12] }, 10), undefined)
  assert.equal(nextSearchOffset({ total: 12, items: [] }, 10), undefined)
})

test('모든 검색 대상의 식별자와 목적지, 날짜, 알레르기 경고를 응답에서 읽는다', () => {
  const samples = [
    ['recipes', { id: 7, name: '달걀볶음', cookTimeMin: 10, restricted: true, restrictedIngredients: ['달걀'] }, 7, '/recipes/7'],
    ['inventory', { lotId: 9, ingredientName: '달걀', quantity: 2, unit: '개' }, 9, '/fridge'],
    ['mealPlans', { id: 1, planDate: '2026-11-25', recipeName: '달걀찜', mealType: 'LUNCH' }, 1, '/recommend?date=2026-11-25'],
    ['shoppingItems', { id: 13, ingredientName: '달걀', requiredQty: 3, unit: '개' }, 13, '/shopping'],
    ['exercises', { code: 'WALK', name: '걷기' }, 'WALK', '/workout'],
    ['workouts', { sessionId: 5, title: '아침 걷기', plannedMinutes: 20 }, 5, '/workout'],
  ]
  assert.deepEqual(SEARCH_GROUPS.map(group => group.type), Object.values(SEARCH_TYPE))
  for (const [field, item, id, to] of samples) {
    const { result } = SEARCH_GROUPS.find(group => group.field === field)
    const row = result(item)
    assert.equal(row.id, id)
    assert.equal(row.to, to)
    assert.ok(row.title)
    if (field === 'recipes') {
      assert.equal(row.warning, true)
      assert.deepEqual(row.restrictedIngredients, ['달걀'])
    }
  }
})

test('다른 사용자·검색어·대상의 검색 결과 캐시를 구분한다', () => {
  const { all, more } = queryKeys.search
  assert.notDeepEqual(all(1, '계란'), all(2, '계란'))
  assert.notDeepEqual(more(1, '계란', SEARCH_TYPE.RECIPE), more(1, '달걀', SEARCH_TYPE.RECIPE))
  assert.notDeepEqual(more(1, '계란', SEARCH_TYPE.SHOPPING), more(1, '계란', SEARCH_TYPE.RECIPE))
})

test('운동 종목의 부위·장비 코드를 한글로 표시하고 운동 세션의 부위 이름을 보존한다', () => {
  const exercise = SEARCH_GROUPS.find(group => group.type === SEARCH_TYPE.EXERCISE)
  assert.deepEqual(exercise.result({ focusArea: 'LOWER', equipment: 'BODYWEIGHT' }).details, ['하체', '맨몸'])
  const workout = SEARCH_GROUPS.find(group => group.type === SEARCH_TYPE.WORKOUT)
  assert.deepEqual(workout.result({ sessionDate: '2026-11-25', focusArea: '전신 회복', plannedMinutes: 15 }).details,
    ['2026-11-25', '전신 회복', '15분'])
})
