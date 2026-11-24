import test from 'node:test'
import assert from 'node:assert/strict'
import { INGREDIENT_CLASS_LABELS, ingredientClassLabel } from '../src/lib/ingredientLabels.js'
import { readRecognitionResponse, confirmedRecognitionName } from '../src/models/ingredientRecognition.js'
import { STOCK_IN_INITIAL_FORM, buildStockInBody, buildLotAdjustBody } from '../src/models/inventoryForm.js'
import { buildFridgeView, ALL_STORAGE } from '../src/models/fridge.js'

// 검증한 체크포인트의 클래스명으로 누락과 잘못된 키를 검사함.
const checkpointClasses = ['anchovy','bean_sprouts','beef','bellflowerroot','bok_choy','bracken','broccoli','burdock',
  'button_mushroom','cabbage','carrot','chicken','chives','cucumber','dried_shrimp','dumpling','egg','eggplant',
  'enoki_mushroom','garlic','ginger','green_onion','ham','kimchi','king_trumpet_mushroom','lettuce','mackerel',
  'manila_clam','mussel','napa_cabbage','onion','oyster_mushroom','paprika','pepper','perilla_leaves','pork',
  'potato','pumpkin','radish','salmon','sausage','shepherd_s_purse','shiitake','shrimp','small_octopus','squid',
  'sweetpotato','tofu','tomato','watercress','zucchini']

test('체크포인트 51개 클래스에 누락·추가 없이 한국어 표시명이 존재한다', () => {
  assert.deepEqual(Object.keys(INGREDIENT_CLASS_LABELS).sort(), [...checkpointClasses].sort())
  assert.equal(Object.isFrozen(INGREDIENT_CLASS_LABELS), true)
  for (const name of checkpointClasses) assert.match(ingredientClassLabel(name), /[가-힣]/)
})

test('고추·파프리카와 상추·깻잎을 구분하고 승인된 미나리 표시를 사용한다', () => {
  for (const [name, label] of [['pepper','고추'],['paprika','파프리카'],['lettuce','상추'],['perilla_leaves','깻잎'],
    ['watercress','미나리'],['shepherd_s_purse','냉이'],['pumpkin','호박'],['zucchini','애호박']]) {
    assert.equal(ingredientClassLabel(name), label)
  }
})

test('알 수 없는 이름과 객체 기본 속성 이름은 잘못 번역하지 않고 원문으로 표시한다', () => {
  for (const value of ['new_ingredient','toString','constructor','__proto__','TOMATO']) assert.equal(ingredientClassLabel(value), value)
  assert.equal(ingredientClassLabel(null), '')
})

test('Top-3 표시만 한국어로 바꾸고 순위·확률·영문 키·UNMAPPED를 유지한다', () => {
  const original = { modelVersion:'efficientnet-b0-stage3-epoch19', candidates:[
    {className:'ham',confidence:0.959,mappingStatus:'UNMAPPED'},
    {className:'squid',confidence:0.016,mappingStatus:'UNMAPPED'},
    {className:'enoki_mushroom',confidence:0.007,mappingStatus:'UNMAPPED'},
  ] }
  const before = structuredClone(original)
  const response = readRecognitionResponse(original)
  assert.deepEqual(response.candidates.map(c => ingredientClassLabel(c.className)), ['햄','오징어','팽이버섯'])
  assert.deepEqual(response, before)
  assert.deepEqual(original, before)
})

test('한국어 후보 선택·직접 수정 결과만 기존 입고 API 필드로 전달한다', () => {
  const initial = ingredientClassLabel('ham')
  assert.equal(confirmedRecognitionName(initial), '햄')
  const body = buildStockInBody({ ...STOCK_IN_INITIAL_FORM, ingredientName:confirmedRecognitionName('  슬라이스 햄  '), quantity:'2',unit:'팩' })
  assert.deepEqual(body, {ingredientName:'슬라이스 햄',quantity:2,unit:'팩',storageLocation:'FRIDGE'})
  assert.equal(Object.hasOwn(body,'ingredientId'), false)
  assert.equal(STOCK_IN_INITIAL_FORM.ingredientName, '')
})

test('영어로 저장된 기존 재고 이름은 조회·수량 수정에서 자동 변환하지 않는다', () => {
  const lot = {id:7,ingredientName:'tomato',quantity:'100',unit:'g',status:'ACTIVE',expirationStatus:'NORMAL',
    storageLocation:'FRIDGE',expiryDate:null,minStockQty:0,memo:null}
  const groups = [{ingredientName:'tomato',unit:'g',lots:[lot]}]
  const view = buildFridgeView({groups,searchQuery:'tomato',storageFilter:ALL_STORAGE})
  assert.equal(view.visibleGroups[0].ingredientName, 'tomato')
  assert.deepEqual(buildLotAdjustBody({quantity:'80',storageLocation:'FRIDGE',expiryDate:'',minStockQty:'0',memo:''},lot),{quantity:80})
  assert.equal(lot.ingredientName, 'tomato')
})
