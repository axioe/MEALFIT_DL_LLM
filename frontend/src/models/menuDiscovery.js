import { splitQuickIngredients } from './quickCookingView.js'

export function menuStock(recipe) {
  const comparisons = recipe.comparisons ?? []
  const { missing, incomparable } = splitQuickIngredients(comparisons)
  const ready = comparisons.length > 0 && comparisons.every(item => item.status === 'sufficient')
  if (ready) return { ready, label: '바로 요리 가능' }
  if (missing.length) {
    const first = missing[0]
    const others = missing.length > 1 ? ' 외 ' + (missing.length - 1) + '종' : ''
    return { ready, label: first.ingredientName + ' ' + first.shortageText + others + ' 필요' }
  }
  return { ready, label: incomparable.length ? '재료 단위 확인 필요' : '재고 확인 필요' }
}

export function matchingMenus(recipes, names, readyOnly) {
  return recipes.filter(recipe => {
    const ingredients = new Set(recipe.ingredients.map(item => item.ingredientName.trim()))
    return names.every(name => ingredients.has(name.trim())) && (!readyOnly || menuStock(recipe).ready)
  }).sort((a, b) => Number(menuStock(b).ready) - Number(menuStock(a).ready))
}

export function nutritionForServings(value, base, servings) {
  if (value == null || !Number.isFinite(Number(value)) || Number(value) < 0 ||
      !Number.isInteger(base) || base < 1 || !Number.isInteger(servings) || servings < 1) return null
  return Math.round(Number(value) * servings / base * 10) / 10
}
