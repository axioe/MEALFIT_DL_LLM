// [자세판별] 운동별 촬영 가이드 (FR-WORK-05). 학습 데이터에 있는 촬영 방향 구역.
// ai-service/ml/pose/camera_ranges.py 가 만든 파일이다. 직접 고치지 말고 스크립트를 다시 실행한다.
// 구역: FRONT 정면 · FRONT_DIAGONAL 앞쪽 대각선 · SIDE 옆 · BACK_DIAGONAL 뒤쪽 대각선 · BACK 뒤
export const POSE_CAMERA_SECTORS = Object.freeze({
  "Y - Exercise": ["FRONT_DIAGONAL", "SIDE", "BACK_DIAGONAL"],
  "굿모닝": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL"],
  "니푸쉬업": ["FRONT_DIAGONAL", "SIDE", "BACK_DIAGONAL"],
  "덤벨 벤트오버 로우": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL", "BACK"],
  "덤벨 인클라인 체스트 플라이": ["FRONT_DIAGONAL", "SIDE", "BACK"],
  "덤벨 체스트 플라이": ["FRONT_DIAGONAL", "SIDE", "BACK_DIAGONAL"],
  "덤벨 컬": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL", "BACK"],
  "덤벨 풀 오버": ["FRONT_DIAGONAL", "SIDE", "BACK_DIAGONAL"],
  "딥스": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL"],
  "라잉 레그 레이즈": ["FRONT_DIAGONAL", "SIDE", "BACK_DIAGONAL"],
  "라잉 트라이셉스 익스텐션": ["FRONT_DIAGONAL", "SIDE", "BACK_DIAGONAL"],
  "랫풀 다운": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL", "BACK"],
  "로잉머신": ["FRONT", "FRONT_DIAGONAL", "SIDE", "BACK_DIAGONAL"],
  "바벨 데드리프트": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL", "BACK"],
  "바벨 런지": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL", "BACK"],
  "바벨 로우": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL"],
  "바벨 스쿼트": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL", "BACK"],
  "바벨 스티프 데드리프트": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL"],
  "바벨 컬": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL", "BACK"],
  "바이시클 크런치": ["FRONT_DIAGONAL", "SIDE", "BACK_DIAGONAL"],
  "버피 테스트": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL"],
  "사이드 런지": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL", "BACK"],
  "사이드 레터럴 레이즈": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL", "BACK"],
  "스탠딩 니업": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL", "BACK"],
  "스탠딩 사이드 크런치": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL"],
  "스텝 백워드 다이나믹 런지": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL", "BACK"],
  "스텝 포워드 다이나믹 런지": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL"],
  "시저크로스": ["FRONT_DIAGONAL", "SIDE", "BACK_DIAGONAL"],
  "업라이트로우": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL", "BACK"],
  "오버 헤드 프레스": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL"],
  "케이블 크런치": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL", "BACK"],
  "케이블 푸시 다운": ["FRONT", "SIDE", "BACK_DIAGONAL", "BACK"],
  "크런치": ["FRONT_DIAGONAL", "SIDE", "BACK_DIAGONAL"],
  "크로스 런지": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL"],
  "페이스 풀": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL", "BACK"],
  "푸시업": ["FRONT_DIAGONAL", "SIDE", "BACK_DIAGONAL"],
  "풀업": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL"],
  "프런트 레이즈": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL"],
  "플랭크": ["FRONT_DIAGONAL", "SIDE", "BACK_DIAGONAL"],
  "행잉 레그 레이즈": ["FRONT", "FRONT_DIAGONAL", "BACK_DIAGONAL"],
  "힙쓰러스트": ["FRONT_DIAGONAL", "SIDE", "BACK_DIAGONAL"],
})

// 아래는 위 구역으로 안내 문구를 만든다 (스크립트가 바꾸지 않는 부분)
const RECOMMEND_FLOOR = '옆이나 비스듬한 대각선'
const AVOID_FLOOR = '머리 쪽이나 발 쪽 정면'

/** 모든 운동에 공통인 촬영 요령 */
export const POSE_CAMERA_TIPS = Object.freeze([
  '머리부터 발끝까지 몸 전체가 화면에 들어오게 찍어 주세요.',
  '휴대폰은 허리 높이에 기울이지 말고 세워 두세요.',
  '밝은 곳에서 한 사람만 나오게, 동작을 2회 이상 해 주세요.',
])

/**
 * 운동별 촬영 방향 안내. 학습 데이터에 있는 방향을 권하고 없는 방향은 피하게 한다.
 * 바닥·벤치 운동(정면 데이터 없음, 옆 데이터 있음)은 머리·발 쪽 정면을 피하게 한다. 정보가 없으면 null.
 */
export function cameraGuide(exercise) {
  const sectors = POSE_CAMERA_SECTORS[exercise]
  if (!sectors?.length) return null
  const has = (name) => sectors.includes(name)
  let recommend
  const avoid = []
  if (!has('FRONT') && has('SIDE')) {
    recommend = RECOMMEND_FLOOR
    avoid.push(AVOID_FLOOR)
  } else {
    if (has('FRONT_DIAGONAL')) recommend = has('FRONT') ? '정면이나 앞쪽 대각선(약 45°)' : '앞쪽 대각선(약 45°)'
    else recommend = has('FRONT') ? '정면' : '옆'
    if (!has('SIDE')) avoid.push('바로 옆')
    if (!has('BACK')) avoid.push('바로 뒤')
  }
  const text = `${recommend}에서 찍어 주세요.${avoid.length ? ` ${avoid.join('이나 ')}에서 찍으면 정확하게 판정할 수 없어요.` : ''}`
  return { recommend, avoid, text }
}
