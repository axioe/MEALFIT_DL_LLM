// [비로그인 운동 예시] 국민체력100 예시 운동을 화면에 보여 줄 형태로 바꾸는 순수 함수 (React·API import 금지)

/** 처음에 보여 줄 운동 수 (세트·횟수가 있는 운동부터) */
export const GUEST_WORKOUT_PREVIEW_COUNT = 6
export const CORE_EXAMPLES = ['플랭크', '바이시클 크런치']

/** 부위 탭: 데이터 키와 화면 이름 */
export const GUEST_WORKOUT_AREAS = Object.freeze([
  { key: 'upper', label: '상체' },
  { key: 'lower', label: '하체' },
  { key: 'full', label: '전신' },
])

/** 세트·횟수·시간 문구. 예) "3~5세트 · 10~15회", "30초". 없으면 빈 문자열 */
export function doseText(item) {
  if (!item) return ''
  return [item.sets && `${item.sets}세트`, item.reps && `${item.reps}회`, item.time].filter(Boolean).join(' · ')
}

/** 부위·도구·장소 문구. 예) "가슴, 앞쪽 위팔 · 밴드 · 실내" */
export function detailText(item) {
  if (!item) return ''
  return [item.part, item.tool, item.place].filter(Boolean).join(' · ')
}

/** 부위별 목록: 처음엔 6개만, 모두 보기면 전체. 데이터는 이미 세트·횟수 있는 운동이 앞에 오도록 정렬돼 있다 */
export function guestWorkoutList(examples, areaKey, showAll = false, count = GUEST_WORKOUT_PREVIEW_COUNT) {
  const items = examples?.[areaKey] ?? []
  return { items: showAll ? items : items.slice(0, count), total: items.length, hidden: showAll ? 0 : Math.max(0, items.length - count) }
}
