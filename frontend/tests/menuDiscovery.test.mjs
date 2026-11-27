import test from 'node:test'
import assert from 'node:assert/strict'
import { matchingMenus, menuStock, nutritionForServings } from '../src/models/menuDiscovery.js'

const tofu = { ingredientName: '두부', status: 'sufficient' }
const egg = { ingredientName: '달걀', status: 'sufficient' }
const onion = { ingredientName: '양파', status: 'none', shortageText: '0.5개' }
function recipe(name, ingredients) { return { name, ingredients, comparisons: ingredients } }

test('ready-only and intersection filters preserve selection and the original recommendation order', () => {
  const bowl = recipe('덮밥', [tofu, egg, onion])
  const pan = recipe('부침', [tofu, egg])
  const steam = recipe('찜', [egg])
  const all = [bowl, pan, steam]
  assert.deepEqual(matchingMenus(all, [], false), [pan, steam, bowl])
  assert.deepEqual(matchingMenus(all, ['두부','달걀'], false), [pan, bowl])
  assert.deepEqual(matchingMenus(all, ['두부','달걀'], true), [pan])
  assert.deepEqual(matchingMenus(all, ['양파'], true), [])
  assert.deepEqual(all, [bowl, pan, steam])
  assert.equal(menuStock(bowl).label, '양파 0.5개 필요')
})

test('missing comparisons and incompatible units never suggest immediate cooking', () => {
  for (const comparisons of [[], [{ status: 'unknown' }], [{ status: 'differentUnit' }]]) {
    assert.equal(menuStock({ comparisons }).ready, false)
  }
})

test('nutrition scales from the stored serving size, retains zero and preserves missing values', () => {
  assert.equal(nutritionForServings('25.5', 2, 1), 12.8)
  assert.equal(nutritionForServings(60, 2, 4), 120)
  assert.equal(nutritionForServings(0, 1, 2), 0)
  assert.equal(nutritionForServings(null, 1, 2), null)
  assert.equal(nutritionForServings(12, 0, 2), null)
})
