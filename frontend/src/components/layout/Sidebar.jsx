import { useRef } from 'react'
import { Link } from 'react-router-dom'
import { LogOut } from 'lucide-react'
import { useLogout } from '@/hooks/useAuth'
import { BrandLogo } from '@/components/common/BrandLogo'
import { NAV_ITEMS } from './navItems'
import { MenuLink } from './MenuLink'

export function Sidebar() {
  const logout = useLogout()
  const lock = useRef(false)
  function leave() {
    if (lock.current || logout.isPending) return
    lock.current = true
    logout.mutate(undefined, { onSettled: () => { lock.current = false } })
  }
  return <aside className="mf-sidebar">
    <Link to="/dashboard" aria-label="MealFit 홈" className="mf-brand">
      <BrandLogo className="h-10 w-10" />
      <span>MealFit</span>
    </Link>
    <nav aria-label="주 메뉴">{NAV_ITEMS.filter(item => !item.secondary).map(item => <MenuLink key={item.to} item={item} className="mf-nav-link" />)}</nav>
    <nav className="mf-sidebar-more" aria-label="기록 및 설정">{NAV_ITEMS.filter(item => item.secondary).map(item => <MenuLink key={item.to} item={item} className="mf-nav-link" />)}
      <button type="button" className="mf-nav-link" disabled={logout.isPending} onClick={leave}><LogOut size={18} />로그아웃</button>
    </nav>
  </aside>
}
