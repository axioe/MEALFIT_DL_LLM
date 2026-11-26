import assert from 'node:assert/strict'
import test from 'node:test'
import { addCustomAllergy, allergySelection, bulkCodes, toggleAllergyCodes } from '../src/models/allergies.js'
import { buildProfileSectionBody } from '../src/models/profileForm.js'

const items = [
  { code: 'EGG', name: '알류', aliases: ['계란'], selectAll: true },
  { code: 'SESAME', name: '참깨', aliases: [], selectAll: true },
  { code: 'PORK', name: '돼지고기', aliases: [], selectAll: false },
  { code: 'SULFITE', name: '아황산류', aliases: [], selectAll: false },
]

test('저장 응답은 codes와 custom만 가진 다음 전체 교체 요청으로 변환한다', () => {
  const draft = allergySelection({ selected: [{ ...items[0], category: '알·유제품' }], custom: ['키위'] })
  assert.deepEqual(draft, { codes: ['EGG'], custom: ['키위'] })
  assert.deepEqual(allergySelection({ selected: [], custom: [] }), { codes: [], custom: [] })
})

test('전체 선택과 해제 모두 육류·첨가물의 수동 선택 및 직접 입력을 보존한다', () => {
  const eligible = bulkCodes(items)
  const original = { codes: ['PORK', 'EGG'], custom: ['키위'] }
  const selected = toggleAllergyCodes(original, eligible)
  assert.deepEqual(selected, { codes: ['PORK', 'EGG', 'SESAME'], custom: ['키위'] })
  assert.deepEqual(toggleAllergyCodes(selected, eligible), { codes: ['PORK'], custom: ['키위'] })
  assert.deepEqual(toggleAllergyCodes(original, ['SULFITE']).codes, ['PORK', 'EGG', 'SULFITE'])
  assert.deepEqual(original.codes, ['PORK', 'EGG'])
})

test('직접 입력한 이름과 별칭도 중복 없이 코드로 추가한다', () => {
  const empty = { codes: [], custom: [] }
  const known = addCustomAllergy(empty, ' 계 란 ', items)
  assert.deepEqual(known, { codes: ['EGG'], custom: [] })
  assert.deepEqual(addCustomAllergy(known, '알류', items), known)
  const custom = addCustomAllergy(known, ' 키위 ', items)
  assert.deepEqual(custom, { codes: ['EGG'], custom: ['키위'] })
  assert.deepEqual(addCustomAllergy(custom, '키위', items), custom)
  assert.deepEqual(addCustomAllergy(custom, '  ', items), custom)
})

test('식단·트레이너 설정 저장은 쉼표가 있는 직접 입력도 원래 배열 그대로 전송한다', () => {
  const saved = ['참깨', '재료 A, B']
  const diet = { dislikedFoodsText: '가지', preferredFoodsText: '' }
  const trainer = { trainerGoal: 'health', trainerLevel: 'starter', trainerDislikedFoodsText: '고수' }
  assert.deepEqual(buildProfileSectionBody('diet', diet, saved).allergies, saved)
  assert.deepEqual(buildProfileSectionBody('trainer', trainer, saved).allergies, saved)
})
