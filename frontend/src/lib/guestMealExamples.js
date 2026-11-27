export const GUEST_MEALS = [
  { meal: '아침', name: '달걀 토스트' },
  { meal: '점심', name: '버섯 비빔밥' },
  { meal: '저녁', name: '두부 달걀 덮밥' },
]

export const EXAMPLE_INVENTORY = [
  { key: 'tofu', ingredientName: '두부', quantity: 1, unit: '모', hint: '내일까지' },
  { key: 'egg', ingredientName: '달걀', quantity: 2, unit: '개' },
  { key: 'rice', ingredientName: '밥', quantity: 2, unit: '공기' },
].map(item => ({ ...item, lots: [] }))

const tofu = { ingredientName: '두부', quantity: '½', unit: '모', status: 'sufficient' }
const egg = { ingredientName: '달걀', quantity: 1, unit: '개', status: 'sufficient' }
const onion = { ingredientName: '양파', quantity: '½', unit: '개', status: 'none', shortageText: '½개' }
export const EXAMPLE_RECIPES = [
  { key: 'pan', name: '두부 달걀 부침', cookTimeMin: 10, ingredients: [tofu, egg], steps: [
    ['두부 물기 빼고 썰기', '두부 ½모의 물기를 빼고, 1cm 두께로 썰어요.'],
    ['달걀옷 입히기', '달걀 1개를 풀고 두부 앞뒤에 고르게 묻혀요.'],
    ['아랫면이 노릇해지면 뒤집기', '팬에 식용유를 두르고 앞면을 부쳐요. 뒤집어 양면을 고르게 익혀요.'],
  ] },
  { key: 'steam', name: '달걀찜', cookTimeMin: 12, ingredients: [egg], steps: [['달걀 풀기', '달걀을 물과 섞어요.'], ['천천히 익히기', '작은 냄비에 붓고 약한 불에서 속까지 익혀요.']] },
  { key: 'bowl', name: '두부 달걀 덮밥', cookTimeMin: 15, ingredients: [tofu, egg, { ingredientName: '밥', quantity: 1, unit: '공기', status: 'sufficient' }, onion], steps: [['재료 손질하기', '양파와 두부를 한입 크기로 썰어요.'], ['익혀 밥에 올리기', '팬에 재료를 볶다가 달걀을 넣어 익히고 밥 위에 올려요.']] },
].map(recipe => ({ ...recipe, servings: 1, comparisons: recipe.ingredients }))
