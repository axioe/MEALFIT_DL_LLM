import test from 'node:test'
import assert from 'node:assert/strict'
import { registerHooks } from 'node:module'
import { validateRecognitionPhoto, readRecognitionResponse, recognitionConfidence, confirmedRecognitionName, MAX_PHOTO_BYTES } from '../src/models/ingredientRecognition.js'
import { STOCK_IN_INITIAL_FORM, validateStockInForm, buildStockInBody } from '../src/models/inventoryForm.js'

const png = [137, 80, 78, 71, 13, 10, 26, 10]
const jpeg = [255, 216, 255, 224]
const result = () => ({ modelVersion: 'efficientnet-b0-stage3-epoch19', candidates: [
  { className: 'tomato', confidence: 0.8, mappingStatus: 'UNMAPPED' },
  { className: 'paprika', confidence: 0.1, mappingStatus: 'UNMAPPED' },
  { className: 'egg', confidence: 0.05, mappingStatus: 'UNMAPPED' },
] })

// 외부 이미지 없이 브라우저 파일 판별 기준을 검사함.
for (const [type, bytes] of [['image/png', png], ['image/jpeg', jpeg], ['', png]]) {
  test(`정상 사진 헤더 ${type || 'MIME 없음'}를 허용한다`, async () => {
    await validateRecognitionPhoto(new File([new Uint8Array(bytes)], 'photo', { type }))
  })
}

test('누락·빈 파일·다른 형식·MIME 위장·손상 헤더를 거부한다', async () => {
  for (const file of [null, new File([], 'empty.png', { type: 'image/png' }),
    new File(['GIF89a'], 'photo.gif', { type: 'image/gif' }),
    new File([new Uint8Array(png)], 'fake.jpg', { type: 'image/jpeg' }),
    new File(['not-an-image'], 'fake.png', { type: 'image/png' })]) {
    await assert.rejects(validateRecognitionPhoto(file))
  }
})

test('10MiB 경계값은 허용하고 1바이트 초과는 거부한다', async () => {
  const header = new Uint8Array(png)
  await validateRecognitionPhoto(new File([header, new Uint8Array(MAX_PHOTO_BYTES - header.length)], 'limit.png', { type: 'image/png' }))
  await assert.rejects(validateRecognitionPhoto(new File([new Uint8Array(MAX_PHOTO_BYTES + 1)], 'large.png', { type: 'image/png' })), /10MiB/)
})

test('Top-3의 UNMAPPED는 정상 후보이며 확률·영문명·모델 버전을 보존한다', () => {
  assert.deepEqual(readRecognitionResponse(result()), result())
  assert.equal(recognitionConfidence(0.8), '80%')
  assert.equal(recognitionConfidence(0.052), '5.2%')
  assert.equal(Object.hasOwn(readRecognitionResponse(result()).candidates[0], 'ingredientId'), false)
})

test('빈 응답·잘못된 후보 개수·중복·정렬·범위·미지원 매핑 상태를 거부한다', () => {
  const invalid = [null, {}, { ...result(), modelVersion: '' }, { ...result(), candidates: [] }]
  for (const change of [candidate => { candidate.className = 'egg' }, candidate => { candidate.confidence = NaN },
    candidate => { candidate.confidence = 1.1 }, candidate => { candidate.confidence = -1 },
    candidate => { candidate.confidence = 0.01 }, candidate => { candidate.confidence = '0.8' },
    candidate => { candidate.mappingStatus = 'MAPPED' }]) {
    const data = result()
    change(data.candidates[0])
    invalid.push(data)
  }
  for (const data of invalid) assert.throws(() => readRecognitionResponse(data))
})

test('선택한 후보명은 직접 수정할 수 있으며 빈 이름·100자 초과는 전달하지 않는다', () => {
  assert.equal(confirmedRecognitionName(result().candidates[0].className), 'tomato')
  assert.equal(confirmedRecognitionName('  방울토마토  '), '방울토마토')
  for (const value of ['', '   ', '가'.repeat(101), null]) assert.equal(confirmedRecognitionName(value), null)
})

test('이름을 전달해도 수량 없이는 등록할 수 없고 기존 수동 등록 기본값은 변하지 않는다', () => {
  const original = structuredClone(STOCK_IN_INITIAL_FORM)
  const form = { ...STOCK_IN_INITIAL_FORM, ingredientName: confirmedRecognitionName(' 토마토 ') }
  assert.equal(form.quantity, '')
  assert.ok(validateStockInForm(form).quantity)
  const final = { ...form, quantity: '3', unit: '개' }
  assert.deepEqual(validateStockInForm(final), {})
  assert.deepEqual(buildStockInBody(final), { ingredientName: '토마토', quantity: 3, unit: '개', storageLocation: 'FRIDGE' })
  assert.deepEqual(STOCK_IN_INITIAL_FORM, original)
})

test('기존 inventory API는 사진만 Spring으로 전송하며 저장·자동 재시도를 호출하지 않는다', async () => {
  const calls = []
  let failure = null
  const mock = { post: async (...args) => { calls.push(args); if (failure) throw failure; return { data: result() } } }
  const key = Symbol.for('mealfit.vision.test.client')
  globalThis[key] = mock
  const hooks = registerHooks({
    resolve(specifier, context, nextResolve) {
      if (specifier === '@/api/client') return { url: 'mealfit-test:client', shortCircuit: true }
      return nextResolve(specifier, context)
    },
    load(url, context, nextLoad) {
      if (url === 'mealfit-test:client') return { format: 'module', source: "export const api = globalThis[Symbol.for('mealfit.vision.test.client')]", shortCircuit: true }
      return nextLoad(url, context)
    },
  })
  let api
  try { api = (await import('../src/api/inventory.js')).inventoryApi }
  finally { hooks.deregister(); delete globalThis[key] }
  const image = new File([new Uint8Array(png)], 'ingredient.png', { type: 'image/png' })
  const controller = new AbortController()
  assert.deepEqual(await api.recognizePhoto({ image, signal: controller.signal }), result())
  assert.equal(calls[0][0], '/inventory/recognitions/photo')
  assert.deepEqual([...calls[0][1].keys()], ['image'])
  assert.equal(calls[0][1].get('image'), image)
  assert.equal(calls[0][2].headers['Content-Type'], undefined)
  assert.equal(calls[0][2].signal, controller.signal)
  failure = { response: { status: 503, data: { message: '인식 서버 연결 실패' } } }
  await assert.rejects(api.recognizePhoto({ image }), error => error === failure)
  assert.equal(calls.length, 2)
  assert.equal(calls.some(([url]) => url === '/inventory/lots'), false)
})

test('실제 등록 컴포넌트는 초기 이름만 채우고 수동 등록은 빈 이름으로 시작한다', async () => {
  const { createServer } = await import('vite')
  const { createElement } = await import('react')
  const { renderToString } = await import('react-dom/server')
  const { QueryClient, QueryClientProvider } = await import('@tanstack/react-query')
  const server = await createServer({ root: new URL('../', import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, '$1'), server: { middlewareMode: true, hmr: false } })
  const client = new QueryClient()
  try {
    const { StockInDialog } = await server.ssrLoadModule('/src/components/common/StockInDialog.jsx')
    const render = props => renderToString(createElement(QueryClientProvider, { client }, createElement(StockInDialog, { onClose() {}, onSuccess() {}, ...props })))
    const photo = render({ initialIngredientName: '방울토마토' })
    assert.match(photo, /name="ingredientName"[^>]*value="방울토마토"/)
    assert.match(photo, /name="quantity"[^>]*value=""/)
    const manual = render({})
    assert.match(manual, /name="ingredientName"[^>]*value=""/)
    assert.match(manual, /등록하기/)
  } finally { client.clear(); await server.close() }
})

test('OCR 후보와 DL 확률은 독립적으로 보존하며 중복 식재료도 출처를 유지한다', () => {
  const data = { ...result(), ocr: { status: 'SUCCESS', candidates: [
    { ingredientName: '토마토', textConfidence: .91 }, { ingredientName: '깻잎', textConfidence: .8 },
  ], elapsedMs: 120 } }
  assert.deepEqual(readRecognitionResponse(data), data)
  assert.equal(readRecognitionResponse(data).candidates[0].confidence, .8)
  assert.equal(confirmedRecognitionName(data.ocr.candidates[1].ingredientName), '깻잎')
})

test('OCR 실패·미지원·글자 없음에서도 DL Top-3를 그대로 사용할 수 있다', () => {
  for (const status of ['NO_TEXT', 'NO_MATCH', 'TIMEOUT', 'UNAVAILABLE', 'ERROR']) {
    const data = { ...result(), ocr: { status, candidates: [], elapsedMs: 20 } }
    assert.deepEqual(readRecognitionResponse(data).candidates, result().candidates)
    assert.equal(readRecognitionResponse(data).ocr.status, status)
  }
})

test('손상된 OCR 선택 필드만 오류 처리하고 기존 인식 결과는 유지한다', () => {
  for (const ocr of [[], {}, 'private text',
    { status: 'SUCCESS', candidates: [], elapsedMs: 1 },
    { status: 'ERROR', candidates: [], elapsedMs: -1 },
    { status: 'SUCCESS', candidates: [{ ingredientName: '<script>', textConfidence: .9 }], elapsedMs: 1 },
    { status: 'SUCCESS', candidates: [{ ingredientName: '당근', textConfidence: 2 }], elapsedMs: 1 }]) {
    const data = readRecognitionResponse({ ...result(), ocr })
    assert.deepEqual(data.candidates, result().candidates)
    assert.deepEqual(data.ocr, { status: 'ERROR', candidates: [], elapsedMs: 0 })
  }
})

test('OCR로 선택·수정한 이름만 기존 등록 요청에 전달하고 자동 수량·ID를 추가하지 않는다', () => {
  const name = confirmedRecognitionName('  국내산 당근  ')
  const form = { ...STOCK_IN_INITIAL_FORM, ingredientName: name, quantity: '2', unit: '개' }
  assert.deepEqual(buildStockInBody(form), { ingredientName: '국내산 당근', quantity: 2, unit: '개', storageLocation: 'FRIDGE' })
})


test('승인된 OCR 세부명은 기존 사진 응답과 재고 등록 계약을 그대로 사용할 수 있다', () => {
  const names = ['토마토', '방울토마토', '흰우유', '딸기우유', '초코우유', '바나나우유',
    '닭가슴살', '닭다리살', '닭날개', '닭안심', '삼겹살', '목살', '앞다리살', '돼지등심',
    '돼지갈비', '소등심', '소안심', '채끝살', '양지', '우둔살']
  for (const name of names) {
    const data = readRecognitionResponse({ ...result(), ocr: {
      status: 'SUCCESS', candidates: [{ ingredientName: name, textConfidence: .9 }], elapsedMs: 100,
    } })
    assert.equal(data.ocr.candidates[0].ingredientName, name)
    assert.deepEqual(data.candidates, result().candidates)
    const body = buildStockInBody({ ...STOCK_IN_INITIAL_FORM,
      ingredientName: confirmedRecognitionName(data.ocr.candidates[0].ingredientName), quantity: '1', unit: '개' })
    assert.equal(body.ingredientName, name)
    assert.equal(body.quantity, 1)
    assert.equal(Object.hasOwn(body, 'ingredientId'), false)
    assert.equal(Object.hasOwn(body, 'className'), false)
  }
})

