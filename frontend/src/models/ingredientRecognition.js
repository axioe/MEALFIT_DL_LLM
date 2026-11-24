export const MAX_PHOTO_BYTES = 10 * 1024 * 1024

// 파일 크기·MIME·실제 시그니처를 검사하고 서버의 최종 이미지 검증은 유지함.
export async function validateRecognitionPhoto(file) {
  if (!file || file.size <= 0) throw new Error('JPEG·PNG 사진 한 장을 선택해 주세요.')
  if (file.size > MAX_PHOTO_BYTES) throw new Error('10MiB 이하의 사진을 선택해 주세요.')
  if (file.type && !['image/jpeg', 'image/png'].includes(file.type)) throw new Error('JPEG·PNG 사진만 사용할 수 있습니다.')
  const bytes = new Uint8Array(await file.slice(0, 8).arrayBuffer())
  const png = [137, 80, 78, 71, 13, 10, 26, 10].every((value, index) => bytes[index] === value)
  const jpeg = bytes[0] === 255 && bytes[1] === 216 && bytes[2] === 255
  if ((!png && !jpeg) || (file.type === 'image/png' && !png) || (file.type === 'image/jpeg' && !jpeg)) {
    throw new Error('정상적인 JPEG·PNG 사진을 선택해 주세요.')
  }
}

// 서버가 검증한 Top-3 계약을 확인하고 임의 식재료 ID나 번역을 추가하지 않음.
export function readRecognitionResponse(data) {
  const invalid = () => { throw new Error('사진 인식 결과 형식을 확인하지 못했습니다. 다시 시도해 주세요.') }
  if (typeof data?.modelVersion !== 'string' || !data.modelVersion.trim() || !Array.isArray(data.candidates) || data.candidates.length !== 3) invalid()
  const names = new Set()
  let previous = 1
  let sum = 0
  const candidates = data.candidates.map(candidate => {
    if (!candidate || typeof candidate.className !== 'string' || !/^[a-z][a-z0-9_]{0,99}$/.test(candidate.className)
      || names.has(candidate.className) || candidate.mappingStatus !== 'UNMAPPED'
      || typeof candidate.confidence !== 'number' || !Number.isFinite(candidate.confidence)
      || candidate.confidence < 0 || candidate.confidence > previous) invalid()
    names.add(candidate.className)
    previous = candidate.confidence
    sum += previous
    return { className: candidate.className, confidence: candidate.confidence, mappingStatus: candidate.mappingStatus }
  })
  if (sum > 1.000001) invalid()
  const result = { modelVersion: data.modelVersion, candidates }
  if (data.ocr != null) result.ocr = readOcrResponse(data.ocr)
  return result
}

// 모델 확률은 재계산하지 않고 백분율로만 표시함.
export function recognitionConfidence(value) {
  return new Intl.NumberFormat('ko-KR', { style: 'percent', maximumFractionDigits: 1 }).format(value)
}

// 확인한 이름만 기존 등록 폼으로 전달하며 수량과 단위는 추정하지 않음.
export function confirmedRecognitionName(name) {
  if (typeof name !== 'string' || !name.trim() || name.trim().length > 100) return null
  return name.trim()
}


// 선택 OCR 출력만 검증하며 손상된 OCR이 기존 Top-3를 무효화하지 않음.
export function readOcrResponse(data) {
  const invalid = { status: 'ERROR', candidates: [], elapsedMs: 0 }
  const statuses = ['SUCCESS', 'NO_TEXT', 'NO_MATCH', 'TIMEOUT', 'UNAVAILABLE', 'ERROR']
  if (!data || !statuses.includes(data.status) || !Array.isArray(data.candidates) || data.candidates.length > 20
    || !Number.isInteger(data.elapsedMs) || data.elapsedMs < 0 || data.elapsedMs > 60000) return invalid
  const names = new Set()
  const candidates = []
  for (const candidate of data.candidates) {
    if (typeof candidate?.ingredientName !== 'string' || candidate.ingredientName.length > 100
      || !/^[가-힣]+(?: [가-힣]+)*$/.test(candidate.ingredientName) || names.has(candidate.ingredientName)
      || typeof candidate.textConfidence !== 'number' || !Number.isFinite(candidate.textConfidence)
      || candidate.textConfidence < 0 || candidate.textConfidence > 1) return invalid
    names.add(candidate.ingredientName)
    candidates.push({ ingredientName: candidate.ingredientName, textConfidence: candidate.textConfidence })
  }
  if ((data.status === 'SUCCESS') !== (candidates.length > 0)) return invalid
  return { status: data.status, candidates, elapsedMs: data.elapsedMs }
}

// 문자 인식의 실패 사유를 사진 분류 실패와 구분해 안내함.
export function ocrStatusMessage(status) {
  switch (status) {
    case 'SUCCESS': return '상품 라벨에서 찾은 이름입니다. 실제 식재료인지 확인해 주세요.'
    case 'NO_TEXT': return '읽을 수 있는 라벨 글자를 찾지 못했습니다. 사진 예측 후보를 확인해 주세요.'
    case 'NO_MATCH': return '라벨 글자는 읽었지만 식재료명을 찾지 못했습니다. 직접 입력할 수 있습니다.'
    case 'TIMEOUT': return '라벨 확인 시간이 초과되었습니다. 사진 예측 후보는 사용할 수 있습니다.'
    case 'UNAVAILABLE': return '라벨 인식을 사용할 수 없어 사진 예측 후보만 표시합니다.'
    default: return '라벨을 읽지 못했습니다. 사진 예측 후보를 확인하거나 직접 입력해 주세요.'
  }
}
