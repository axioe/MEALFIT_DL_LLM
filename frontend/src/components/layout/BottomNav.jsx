import { MenuLink } from './MenuLink'
import { NAV_ITEMS } from './navItems'

export function BottomNav() {
  return <nav className="mf-bottom" aria-label="모바일 주 메뉴">
    {NAV_ITEMS.filter(item => item.mobile !== false).map(item =>
      <MenuLink key={item.to} item={item} iconSize={19} />)}
  </nav>
}
