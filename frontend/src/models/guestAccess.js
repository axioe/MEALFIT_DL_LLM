import { validRecipeId } from './recipeInventory.js'

const guestScreens = new Map([
  ['/', 'home'], ['/dashboard', 'home'], ['/recommend', 'meals'], ['/workout', 'workout'], ['/recipes', 'catalog'],
])

export function guestScreenForPath(pathname) {
  const path = pathname.toLowerCase().replace(/\/+$/, '') || '/'
  const match = /^\/recipes\/([^/]+)$/.exec(path)
  return match && validRecipeId(match[1]) ? 'recipe' : guestScreens.get(path)
}
