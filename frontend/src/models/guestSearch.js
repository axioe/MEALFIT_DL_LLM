import { GUEST_WORKOUT_EXAMPLES } from '../lib/guestWorkoutExamples.js'
import { CORE_EXAMPLES, GUEST_WORKOUT_AREAS, detailText, doseText } from './guestWorkout.js'

// 비로그인에게는 회원 전용 기능의 이름과 목적지만 제공한다.
const features = [
  { title: '운동 둘러보기', to: '/workout', keywords: '운동 종목 예시' },
  { title: '내 냉장고', to: '/fridge', memberOnly: true, keywords: '보유 식재료 재고 소비기한' },
  { title: '식재료 등록', to: '/fridge?add=1', memberOnly: true, keywords: '냉장고 사진 영수증 재고 입고' },
  { title: '내 식단 추천·확정', to: '/recommend', memberOnly: true, keywords: '개인 맞춤 식단 추천 조리 섭취 기록' },
  { title: '장보기 목록', to: '/shopping', memberOnly: true, keywords: '부족 재료 구매' },
  { title: '내 운동 루틴', to: '/workout', memberOnly: true, keywords: '운동 기록 루틴 추천 자세 피드백' },
  { title: '식단 캘린더', to: '/calendar', memberOnly: true, keywords: '달력 섭취 기록' },
  { title: '체중 관리', to: '/weight', memberOnly: true, keywords: '몸무게 체중 기록' },
  { title: '마이페이지', to: '/mypage', memberOnly: true, keywords: '내 설정 프로필 계정 보안 신체 체력' },
  { title: '식단 조건 설정', to: '/mypage?tab=diet', memberOnly: true, keywords: '알레르기 제외 재료 식단 기호' },
]

export function exercisePreview(title, details, area) {
  const description = details.filter(Boolean)
  return { title, details: description, to: '/workout', state: { area, exercisePreview: { title, details: description } } }
}

const examples = [
  ...GUEST_WORKOUT_AREAS.flatMap(({ key, label }) => GUEST_WORKOUT_EXAMPLES[key].map(item => ({
    id: key + '-' + item.name, ...exercisePreview(item.name, [label + ' 운동 예시', detailText(item), doseText(item)], key),
  }))),
  ...CORE_EXAMPLES.map(name => ({ id: 'core-' + name, ...exercisePreview(name, ['코어 운동 예시'], 'core') })),
]

function compact(value) {
  return value.toLowerCase().replace(/\s+/g, '')
}

const catalogTerms = new Set(['식단', '레시피', '요리', '음식', '메뉴', '조리법', '전체레시피', '전체레시피보기', '식단추천', '식단예시'])

// 빈 문자열은 전체 목록, null은 기능·운동도 포함하는 일반 검색이다.
export function guestRecipeQuery(term) {
  if (catalogTerms.has(compact(term))) return ''
  if (/^(내|개인맞춤|맞춤)식단/.test(compact(term))) return null
  const match = term.match(/^(.+?)\s*(?:레시피|요리|식단|메뉴|조리법)$/)
  return match ? match[1].trim() : null
}

const entries = [
  ...features.map(item => ({ ...item, id: item.to + item.title, details: ['서비스 기능'] })),
  ...examples,
].map(item => ({ ...item, searchText: [item.title, ...item.details, item.keywords ?? ''].map(compact) }))

export function searchGuestEntries(terms) {
  const keys = terms.map(compact).filter(Boolean)
  return entries.filter(item => keys.some(key => item.searchText.some(text => text.includes(key))))
}
