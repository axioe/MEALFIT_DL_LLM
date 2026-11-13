import test from 'node:test'
import assert from 'node:assert/strict'
import { buildLoginBody, buildSignupBody, validateSignupForm } from '../src/models/authForm.js'
import { buildMonthGrid, shiftMonth } from '../src/models/calendar.js'
import { countCompletedDays, mondayBasedDayIndex, weeklyProgress } from '../src/models/workout.js'
import { buildWeightChart, CHART } from '../src/models/weightChart.js'
import { quickInventoryStatus } from '../src/models/quickCooking.js'
import { countWaitingStockIn } from '../src/models/shoppingValidation.js'
import { buildLotAdjustBody, buildStockInBody, isValidQuantity, validateStockInForm, STOCK_IN_INITIAL_FORM } from '../src/models/inventoryForm.js'
import { countImminentLots } from '../src/models/fridge.js'

test('로그인·가입 요청: 이메일은 소문자·공백 제거, 비밀번호 공백은 유지', () => {
  assert.deepEqual(buildLoginBody({ email: ' A@B.com ', password: ' pw ' }), { email: 'a@b.com', password: ' pw ' })
  assert.deepEqual(buildSignupBody({ email: 'X@Y.COM', password: 'p', nickname: ' 밀핏 ' }), { email: 'x@y.com', password: 'p', nickname: '밀핏' })
})

test('가입 검증: 닉네임 필수, 비밀번호는 UTF-8 72바이트 이하', () => {
  assert.equal(validateSignupForm({ password: 'pw', nickname: '  ' }), '닉네임을 입력해 주세요.')
  assert.equal(validateSignupForm({ password: '가'.repeat(25), nickname: 'n' }), '비밀번호는 UTF-8 기준 72바이트 이하로 입력해 주세요.')
  assert.equal(validateSignupForm({ password: '가'.repeat(24), nickname: 'n' }), '')
})

test('달력: 2026년 11월은 일요일 시작이고 앞뒤 칸 날짜가 하루 밀리지 않는다', () => {
  const days = buildMonthGrid(new Date(2026, 10, 1))
  assert.equal(days.length % 7, 0)
  assert.deepEqual(days[0], { dateStr: '2026-11-01', dayNum: 1, isCurrentMonth: true })
  const last = days.at(-1)
  assert.equal(last.isCurrentMonth, false)
  assert.equal(last.dateStr, `2026-12-${String(last.dayNum).padStart(2, '0')}`)
  const oct = buildMonthGrid(new Date(2026, 9, 1)) // 10월 1일은 목요일 → 앞에 9월 27~30일
  assert.deepEqual(oct.slice(0, 4).map((d) => d.dateStr), ['2026-09-27', '2026-09-28', '2026-09-29', '2026-09-30'])
  assert.deepEqual(shiftMonth(new Date(2026, 0, 31), -1), new Date(2025, 11, 1))
})

test('운동 진행률: 휴식일 제외, 100% 상한, 월요일=0', () => {
  const routine = [{ isRestDay: false }, { isRestDay: true }, { isRestDay: false }]
  assert.equal(weeklyProgress(routine, [{ completed: true }]), 50)
  assert.equal(weeklyProgress(routine, [{ completed: true }, { completed: true }, { completed: true }]), 100)
  assert.equal(weeklyProgress([], []), 0)
  assert.equal(countCompletedDays([{ completed: true }, { completed: false }]), 1)
  assert.equal(mondayBasedDayIndex(new Date(2026, 10, 16)), 0) // 월요일
  assert.equal(mondayBasedDayIndex(new Date(2026, 10, 15)), 6) // 일요일
})

test('체중 그래프: 날짜순 정렬, 점 1개면 가운데, 목표선 위치', () => {
  const chart = buildWeightChart([{ date: '2026-11-02', weight: 70 }, { date: '2026-11-01', weight: 72 }], 68)
  assert.deepEqual(chart.sortedRecords.map((r) => r.weight), [72, 70])
  assert.equal(chart.getX(0, 2), CHART.paddingX)
  assert.equal(chart.getX(0, 1), CHART.width / 2)
  assert.ok(chart.targetLineY > chart.getY(72))
  assert.equal(chart.polylinePoints.split(' ').length, 2)
})

test('15분 요리 냉장고 현황과 장보기 입고 대기 수', () => {
  const inventory = { groups: [{ lots: [
    { status: 'ACTIVE', expirationStatus: 'TODAY' }, { status: 'ACTIVE', expirationStatus: 'IMMINENT' },
    { status: 'ACTIVE', expirationStatus: 'EXPIRED' }, { status: 'DISPOSED', expirationStatus: 'EXPIRED' },
  ] }] }
  assert.deepEqual(quickInventoryStatus(inventory), { imminent: 2, expired: 1 })
  assert.deepEqual(quickInventoryStatus(undefined), { imminent: 0, expired: 0 })
  assert.equal(countImminentLots(inventory.groups), 2)
  assert.equal(countWaitingStockIn([{ purchasedQty: '0' }, { purchasedQty: '1.5' }]), 1)
})

test('입고 폼 검증과 요청 본문', () => {
  const form = { ...STOCK_IN_INITIAL_FORM, ingredientName: ' 두부 ', quantity: '1', unit: '모' }
  assert.deepEqual(validateStockInForm(form), {})
  assert.deepEqual(buildStockInBody(form), { ingredientName: '두부', quantity: 1, unit: '모', storageLocation: 'FRIDGE' })
  const errors = validateStockInForm({ ...form, ingredientName: '', quantity: '0', unit: '?', expiryDate: '2026-02-30' })
  assert.deepEqual(Object.keys(errors).sort(), ['expiryDate', 'ingredientName', 'quantity', 'unit'])
})

test('묶음 수정: 수량 형식과 바뀐 항목만 담은 본문', () => {
  assert.equal(isValidQuantity('1.234'), true)
  assert.equal(isValidQuantity('1.2345'), false)
  assert.equal(isValidQuantity('0', true), false)
  const lot = { quantity: '2', storageLocation: 'FRIDGE', expiryDate: '2026-11-20', minStockQty: '0', memo: null }
  assert.deepEqual(buildLotAdjustBody({ quantity: '2', storageLocation: 'FRIDGE', expiryDate: '2026-11-20', minStockQty: '0', memo: '' }, lot), {})
  assert.deepEqual(buildLotAdjustBody({ quantity: '1', storageLocation: 'FREEZER', expiryDate: '', minStockQty: '1', memo: 'm' }, lot),
    { quantity: 1, storageLocation: 'FREEZER', clearExpiryDate: true, minStockQty: 1, memo: 'm' })
})
