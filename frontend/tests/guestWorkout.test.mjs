import test from 'node:test'
import assert from 'node:assert/strict'
import { GUEST_WORKOUT_AREAS, GUEST_WORKOUT_PREVIEW_COUNT, doseText, detailText, guestWorkoutList } from '../src/models/guestWorkout.js'
import { GUEST_WORKOUT_EXAMPLES, GUEST_WORKOUT_SOURCE } from '../src/lib/guestWorkoutExamples.js'

test('세트·횟수·시간 문구를 있는 값만 이어 붙인다', () => {
  assert.equal(doseText({ sets: '3~5', reps: '10~15' }), '3~5세트 · 10~15회')
  assert.equal(doseText({ time: '30초' }), '30초')
  assert.equal(doseText({ sets: '1~3', reps: '10~20', time: '10~20초' }), '1~3세트 · 10~20회 · 10~20초')
  assert.equal(doseText({}), '')
  assert.equal(doseText(null), '')
})

test('부위·도구·장소 문구', () => {
  assert.equal(detailText({ part: '가슴', tool: '밴드', place: '실내' }), '가슴 · 밴드 · 실내')
  assert.equal(detailText({ part: '등' }), '등')
})

test('처음엔 6개만 보여 주고 모두 보기면 전체를 보여 준다', () => {
  const examples = { upper: Array.from({ length: 10 }, (_, i) => ({ name: `운동${i}` })) }
  assert.deepEqual(guestWorkoutList(examples, 'upper'), { items: examples.upper.slice(0, 6), total: 10, hidden: 4 })
  assert.equal(guestWorkoutList(examples, 'upper', true).items.length, 10)
  assert.deepEqual(guestWorkoutList(examples, 'lower'), { items: [], total: 0, hidden: 0 })
})

test('국민체력100 예시 데이터: 부위마다 운동이 있고, 세트·횟수 있는 운동이 앞에 오며, 서비스와 관련 없는 운동이 없다', () => {
  assert.match(GUEST_WORKOUT_SOURCE, /국민체력100/)
  for (const { key } of GUEST_WORKOUT_AREAS) {
    const items = GUEST_WORKOUT_EXAMPLES[key]
    assert.ok(items.length >= GUEST_WORKOUT_PREVIEW_COUNT, key)
    const firstNoDose = items.findIndex((i) => !i.hasDose)
    assert.ok(firstNoDose === -1 || items.slice(firstNoDose).every((i) => !i.hasDose), `${key}: 세트·횟수 있는 운동이 앞`)
    for (const item of items) {
      assert.ok(item.name)
      assert.ok(!['수영장', '실외'].includes(item.place), `${item.name}: ${item.place}`)
      assert.ok(!['아쿠아봉', '킥판', '사다리', '줄사다리'].includes(item.tool), `${item.name}: ${item.tool}`)
    }
  }
})
