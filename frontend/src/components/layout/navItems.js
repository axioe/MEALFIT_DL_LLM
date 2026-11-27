import { Activity, Archive, BookOpen, Calendar, House, Scale, Settings, ShoppingCart } from 'lucide-react'

export const NAV_ITEMS = [
  { to: '/dashboard', label: '홈', icon: House },
  { to: '/recommend', label: '식단', icon: BookOpen },
  { to: '/fridge', label: '냉장고', icon: Archive },
  { to: '/shopping', label: '장보기', icon: ShoppingCart },
  { to: '/workout', label: '운동', icon: Activity },
  { to: '/calendar', label: '캘린더', icon: Calendar, secondary: true, mobile: false },
  { to: '/weight', label: '체중 관리', icon: Scale, secondary: true, mobile: false },
  { to: '/mypage', label: '내 설정', icon: Settings, secondary: true },
]
export const navItems = NAV_ITEMS
export function findNavItem(pathname) {
  if (pathname === '/recipes' || pathname.startsWith('/recipes/')) return { label: '레시피', to: '/recommend' }
  return NAV_ITEMS.find(item => pathname.startsWith(item.to)) ?? { label: '밀핏' }
}
export function findNavTitle(pathname) { return findNavItem(pathname).label }
