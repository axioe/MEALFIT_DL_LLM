import test from 'node:test'
import assert from 'node:assert/strict'
import {
  buildProfileSectionBody,
  createProfileForm,
  toggleExclusiveItem,
  toggleItem,
} from '../src/models/profileForm.js'

test('Fitness 탭 폼은 부상 부위 배열과 15/30/45/60분 운동 시간을 그대로 변환한다', () => {
  const details = {
    body: { nickname: '운동러', age: 28, height: 175, currentWeight: 70, targetWeight: 67, gender: 'male', activityLevel: 'moderate' },
    trainer: {
      age: 28, height: 175, currentWeight: 70, workoutGoal: 'hypertrophy', workoutLevel: 'intermediate',
      environment: 'gym', equipment: ['barbell', 'dumbbell'], workoutMinutes: 45,
      injuries: ['무릎'], allergies: [], excludedIngredients: [], dietType: 'high_protein', mealBudget: 10000,
    },
    diet: { goal: 'LOSE', cookTimeMin: 20, mealBudget: 10000, allergies: [], excludedIngredients: [], preferredFoods: [], defaultServings: 1, prioritizeFridge: true },
    fitness: { workoutGoal: 'hypertrophy', workoutLevel: 'intermediate', workoutMinutes: 45, daysPerWeek: 4, equipment: ['barbell', 'dumbbell'], injuries: ['무릎', '허리'] },
    tests: {},
  }

  const form = createProfileForm(details)
  assert.deepEqual(form.fitnessInjuries, ['무릎', '허리'])
  assert.equal(form.durationMinutes, 45)

  const body = buildProfileSectionBody('fitness', {
    ...form,
    durationMinutes: 30,
    equipment: toggleExclusiveItem(form.equipment, 'barbell'),
    fitnessInjuries: toggleItem(form.fitnessInjuries, '어깨'),
  })
  assert.equal(body.workoutMinutes, 30)
  assert.deepEqual(body.equipment, ['dumbbell'])
  assert.deepEqual(body.injuries, ['무릎', '허리', '어깨'])
})

test('장비 없음(none)은 바벨·덤벨과 배타적으로 토글된다', () => {
  assert.deepEqual(toggleExclusiveItem(['barbell', 'dumbbell'], 'none'), ['none'])
  assert.deepEqual(toggleExclusiveItem(['none'], 'barbell'), ['barbell'])
})

test('마이페이지 통합 폼은 dietType과 environment를 각각 diet·fitness 요청 본문에 포함한다', () => {
  const details = {
    body: { nickname: '밀핏러', age: 27, height: 172, currentWeight: 68, targetWeight: 65, gender: 'male', activityLevel: 'light' },
    trainer: {
      age: 27, height: 172, currentWeight: 68, workoutGoal: 'loss', workoutLevel: 'beginner',
      environment: 'home', equipment: ['mat'], workoutMinutes: 30,
      injuries: [], allergies: ['우유'], excludedIngredients: ['오이'], dietType: 'low_carb', mealBudget: 9000,
    },
    diet: { goal: 'LOSE', cookTimeMin: 20, mealBudget: 9000, allergies: ['우유'], excludedIngredients: ['오이'], preferredFoods: ['두부'], defaultServings: 1, prioritizeFridge: true, dietType: 'low_carb' },
    fitness: { workoutGoal: 'loss', workoutLevel: 'beginner', workoutMinutes: 30, daysPerWeek: 3, equipment: ['mat'], injuries: [], environment: 'home' },
    tests: {},
  }
  const form = createProfileForm(details)
  assert.equal(form.dietType, 'low_carb')
  assert.equal(form.environment, 'home')

  const dietBody = buildProfileSectionBody('diet', { ...form, dietType: 'high_protein' }, ['우유'])
  assert.equal(dietBody.dietType, 'high_protein')

  const fitnessBody = buildProfileSectionBody('fitness', { ...form, environment: 'gym' })
  assert.equal(fitnessBody.environment, 'gym')
})
