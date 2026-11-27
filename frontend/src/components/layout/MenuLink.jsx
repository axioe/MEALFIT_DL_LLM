import { Link, useLocation } from 'react-router-dom'
import { findNavItem } from './navItems'
import { LockKeyhole } from 'lucide-react'
import { MemberLink } from '@/components/common/MemberLink'
import { useGuestLogin } from '@/hooks/useGuestLogin'
import { guestScreenForPath } from '@/models/guestAccess'

export function MenuLink({ item, className, iconSize = 20 }) {
  const { pathname } = useLocation()
  const guest = useGuestLogin()
  if (guest && !guestScreenForPath(item.to)) {
    return <MemberLink to={item.to} feature={item.label} className={className}>
      <LockKeyhole aria-hidden="true" size={iconSize} /><span>{item.label}</span>
    </MemberLink>
  }
  const current = findNavItem(pathname).to === item.to
  const Icon = item.icon
  return (
    <Link to={item.to} className={className} aria-current={current ? (pathname === item.to ? 'page' : 'location') : undefined}>
      <Icon aria-hidden="true" size={iconSize} />
      <span>{item.label}</span>
    </Link>
  )
}
