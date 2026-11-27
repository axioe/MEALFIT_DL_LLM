/** 서버의 공유 값을 각 탭의 입력값으로 변환합니다. */
export function createProfileForm({ body, trainer, diet, fitness, tests }) {
  return {
    trainerAge: trainer.age ?? "",
    trainerHeight: trainer.height ?? "",
    trainerWeight: trainer.currentWeight ?? "",
    trainerGoal: trainer.workoutGoal ?? "",
    trainerLevel: trainer.workoutLevel ?? "",
    trainerEnvironment: trainer.environment ?? "",
    trainerEquipment: trainer.equipment,
    trainerAvailableTime: trainer.workoutMinutes ?? "",
    trainerInjuries: trainer.injuries,
    trainerDislikedFoodsText: trainer.excludedIngredients.join(", "),
    trainerDietType: trainer.dietType ?? "",
    trainerBudget: trainer.mealBudget ?? "",
    nickname: body.nickname,
    age: body.age ?? "",
    height: body.height ?? "",
    currentWeight: body.currentWeight ?? "",
    targetWeight: body.targetWeight ?? "",
    gender: body.gender ?? "",
    activityLevel: body.activityLevel ?? "",
    dietGoal: ({ LOSE: "loss", MAINTAIN: "maintain", GAIN: "gain" })[diet.goal] ?? "",
    dislikedFoodsText: diet.excludedIngredients.join(", "),
    preferredFoodsText: diet.preferredFoods.join(", "),
    cookTime: diet.cookTimeMin ?? "",
    defaultServings: diet.defaultServings ?? "",
    budgetPerMeal: diet.mealBudget ?? "",
    dietType: diet.dietType ?? trainer.dietType ?? "",
    prioritizeFridge: diet.prioritizeFridge ?? false,
    fitnessGoal: fitness.workoutGoal ?? "",
    experience: fitness.workoutLevel ?? "",
    environment: fitness.environment ?? trainer.environment ?? "",
    equipment: fitness.equipment,
    daysPerWeek: fitness.daysPerWeek ?? "",
    durationMinutes: fitness.workoutMinutes ?? "",
    // [운동조건설정] D3 합의 기준: Fitness 탭도 7개 부상 부위 배열 토글로 통일
    fitnessInjuries: fitness.injuries,
    restingHeartRate: tests.restingHeartRate ?? "",
    pushups: tests.pushups ?? "",
    squat30s: tests.squat30s ?? "",
    plankSeconds: tests.plankSeconds ?? "",
  }
}

/** 빈칸은 미설정(null), 0은 실제 측정값으로 유지합니다. */
function numberOrNull(value) { return value === '' ? null : Number(value) }
function optional(value) { return value || null }
export function parseProfileItems(text) {
  return [...new Set(text.split(',').map((item) => item.trim()).filter(Boolean))]
}

/** 선택한 탭의 값만 전송해 다른 탭의 설정을 지우지 않습니다. */
export function buildProfileSectionBody(section, form, savedAllergies) {
  const n = numberOrNull
  const items = parseProfileItems
  if (section === 'common') return {
    nickname: form.nickname.trim(), age: n(form.age), height: n(form.height),
    currentWeight: n(form.currentWeight), targetWeight: n(form.targetWeight),
    gender: optional(form.gender), activityLevel: optional(form.activityLevel),
  }
  if (section === 'trainer') {
    if (!form.trainerGoal || !form.trainerLevel) throw new Error('운동 목적과 운동 수준을 선택해 주세요.')
    return {
      age: n(form.trainerAge), height: n(form.trainerHeight), currentWeight: n(form.trainerWeight),
      workoutGoal: form.trainerGoal, workoutLevel: form.trainerLevel,
      environment: optional(form.trainerEnvironment), equipment: form.trainerEquipment,
      workoutMinutes: n(form.trainerAvailableTime), injuries: form.trainerInjuries,
      dietType: optional(form.trainerDietType), mealBudget: n(form.trainerBudget),
      allergies: savedAllergies, excludedIngredients: items(form.trainerDislikedFoodsText),
    }
  }
  if (section === 'diet') return {
    goal: ({ loss: 'LOSE', maintain: 'MAINTAIN', gain: 'GAIN' })[form.dietGoal] ?? null,
    cookTimeMin: n(form.cookTime), mealBudget: n(form.budgetPerMeal),
    allergies: savedAllergies, excludedIngredients: items(form.dislikedFoodsText),
    preferredFoods: items(form.preferredFoodsText), defaultServings: n(form.defaultServings),
    prioritizeFridge: form.prioritizeFridge,
    // [마이페이지통합] 식단 유형을 식단 설정 카드에서 함께 저장
    dietType: optional(form.dietType),
  }
  if (section === 'fitness') return {
    workoutGoal: optional(form.fitnessGoal), workoutLevel: optional(form.experience),
    equipment: form.equipment, daysPerWeek: n(form.daysPerWeek),
    workoutMinutes: n(form.durationMinutes), injuries: form.fitnessInjuries,
    // [마이페이지통합] 운동 환경을 신체·운동 설정 카드에서 함께 저장
    environment: optional(form.environment),
  }
  if (section === 'tests') return {
    restingHeartRate: n(form.restingHeartRate), pushups: n(form.pushups),
    squat30s: n(form.squat30s), plankSeconds: n(form.plankSeconds),
  }
  throw new Error('저장할 탭을 확인해 주세요.')
}

/** 목록에 있으면 빼고 없으면 뒤에 붙인다 (예: 불편한 부위) */
export function toggleItem(list, item) {
  return list.includes(item) ? list.filter((value) => value !== item) : [...list, item]
}

/**
 * 장비처럼 '없음'(exclusive)이 다른 항목과 함께 고를 수 없는 목록을 토글한다.
 * '없음'을 고르면 나머지를 비우고, 다른 항목을 고르면 '없음'을 뺀다.
 */
export function toggleExclusiveItem(list, item, exclusive = 'none') {
  if (item === exclusive) return list.includes(item) ? [] : [item]
  return list.includes(item) ? list.filter((value) => value !== item) : [...list.filter((value) => value !== exclusive), item]
}

/** 저장 실패 응답을 화면에 보여줄 한 줄로 만든다 (필드 오류가 있으면 모두 이어 붙인다) */
export function profileSaveErrorMessage(failure) {
  const issues = failure?.response?.data?.errors
  if (issues?.length) return issues.map((item) => item.message).join(' / ')
  return failure?.response?.data?.message ?? failure?.message ?? '저장에 실패했습니다. 다시 시도해 주세요.'
}
