import { Link, useLocation } from 'react-router-dom'
import { findNavItem } from './navItems'

export function MenuLink({ item, className, iconSize = 20 }) {
  const { pathname } = useLocation()
  const current = findNavItem(pathname).to === item.to
  const Icon = item.icon
  return (
    <Link to={item.to} className={className} aria-current={current ? (pathname === item.to ? 'page' : 'location') : undefined}>
      <Icon aria-hidden="true" size={iconSize} />
      <span>{item.label}</span>
    </Link>
  )
}
