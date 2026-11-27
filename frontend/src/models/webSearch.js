import { SEARCH_TYPE } from '../lib/enums.js'
import { EXERCISE_EQUIPMENT_LABEL, EXERCISE_FOCUS_LABEL, MEAL_TYPE_LABEL, SHOPPING_ITEM_STATUS_LABEL, STORAGE_LABEL } from '../lib/labels.js'
import { formatQuantity } from '../lib/format.js'

export const SEARCH_LIMIT = 5
export const MAX_SEARCH_LENGTH = 50

export function normalizeSearchTerm(input) {
  return input.trim().replace(/\s+/g, ' ')
}

export function nextSearchOffset(page, offset = 0) {
  const next = offset + page.items.length
  if (page.items.length && next < page.total) return next
  return undefined
}

// 응답 그룹별 식별자와 이동 경로를 한곳에 둔다.
export const SEARCH_GROUPS = [
  {
    type: SEARCH_TYPE.RECIPE, field: 'recipes', label: '레시피',
    result: item => ({
      id: item.id, title: item.name, to: '/recipes/' + item.id,
      details: [item.cookTimeMin + '분', ...(item.matchedIngredients ?? [])],
      warning: item.restricted, restrictedIngredients: item.restrictedIngredients,
    }),
  },
  {
    type: SEARCH_TYPE.INVENTORY, field: 'inventory', label: '내 냉장고',
    result: item => ({
      id: item.lotId, title: item.ingredientName, to: '/fridge',
      details: [STORAGE_LABEL[item.storageLocation], formatQuantity(item.quantity, item.unit), item.expiryDate && item.expiryDate + '까지'],
    }),
  },
  {
    type: SEARCH_TYPE.MEAL_PLAN, field: 'mealPlans', label: '내 식단',
    result: item => ({
      id: item.id, title: item.recipeName, to: '/recommend?date=' + encodeURIComponent(item.planDate),
      details: [item.planDate, MEAL_TYPE_LABEL[item.mealType]],
    }),
  },
  {
    type: SEARCH_TYPE.SHOPPING, field: 'shoppingItems', label: '장보기',
    result: item => ({
      id: item.id, title: item.ingredientName, to: '/shopping',
      details: [SHOPPING_ITEM_STATUS_LABEL[item.status], '필요량 ' + formatQuantity(item.requiredQty, item.unit)],
    }),
  },
  {
    type: SEARCH_TYPE.EXERCISE, field: 'exercises', label: '운동 종목',
    result: item => ({
      id: item.code, title: item.name, to: '/workout',
      details: [EXERCISE_FOCUS_LABEL[item.focusArea], EXERCISE_EQUIPMENT_LABEL[item.equipment]],
    }),
  },
  {
    type: SEARCH_TYPE.WORKOUT, field: 'workouts', label: '내 운동',
    result: item => ({
      id: item.sessionId, title: item.title, to: '/workout',
      details: [item.sessionDate, EXERCISE_FOCUS_LABEL[item.focusArea] ?? item.focusArea, item.plannedMinutes + '분'],
    }),
  },
]
