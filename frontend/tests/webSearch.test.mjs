import test from 'node:test'
import assert from 'node:assert/strict'
import { SEARCH_TYPE } from '../src/lib/enums.js'
import { queryKeys } from '../src/api/queryKeys.js'
import { normalizeSearchTerm, nextSearchOffset, SEARCH_GROUPS } from '../src/models/webSearch.js'
import { exercisePreview, guestRecipeQuery, searchGuestEntries } from '../src/models/guestSearch.js'

test('게스트 식단·요리 검색은 카탈로그를 사용하고 기능명은 통합 검색에 남긴다', () => {
  for (const term of ['식단', '레시피', '식단 예시', '전체 레시피 보기']) assert.equal(guestRecipeQuery(term), '')
  assert.equal(guestRecipeQuery('달걀 레시피'), '달걀')
  assert.equal(guestRecipeQuery('두부요리'), '두부')
  for (const term of ['스쿼트', '장보기', '식단 조건 설정', '내 식단']) assert.equal(guestRecipeQuery(term), null)
  assert.ok(searchGuestEntries(['개인 맞춤 식단 추천']).features.some(item => item.memberOnly))
  assert.ok(searchGuestEntries(['내  냉장고']).features.some(item => item.to === '/fridge' && item.memberOnly))
  assert.deepEqual(searchGuestEntries(['   ']), { exercises: [], features: [] })
})

test('달걀·계란과 요리 이름은 공개 레시피 검색에 맡긴다', () => {
  assert.deepEqual(searchGuestEntries(['계란', '달걀']), { exercises: [], features: [] })
  assert.deepEqual(searchGuestEntries(['두부 달걀 덮밥']), { exercises: [], features: [] })
})

test('비로그인 하체 검색은 운동 그룹에 부위별 동작과 상세 정보를 제공한다', () => {
  const { exercises, features } = searchGuestEntries(['하체'])
  assert.deepEqual(features, [])
  assert.ok(exercises.length > 5)
  assert.ok(exercises.every(item => item.state.area === 'lower' && item.details[0] === '하체 운동'))
  const stairs = exercises.find(item => item.title === '계단 두 칸씩 두발 뛰기')
  assert.deepEqual(stairs.state.exercisePreview.details, stairs.details)
  assert.deepEqual(searchGuestEntries(['하체 운동 예시']).exercises, exercises)
})

test('코어 동작은 공개 상세로 연결하고 내 운동 루틴은 회원 전용으로 표시한다', () => {
  const plank = searchGuestEntries(['플랭크']).exercises.find(item => item.state?.area === 'core')
  assert.equal(plank.state.exercisePreview.title, '플랭크')
  assert.deepEqual(plank.details, ['코어 운동'])
  assert.ok(searchGuestEntries(['내 운동 루틴']).exercises.some(item => item.memberOnly))
  const catalog = exercisePreview('스쿼트', ['하체', '맨몸', null])
  assert.equal(catalog.to, '/workout')
  assert.deepEqual(catalog.state.exercisePreview.details, ['하체', '맨몸'])
})

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
