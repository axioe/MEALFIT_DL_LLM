import { Link, useLocation } from 'react-router-dom'
import { formatFullKoreanDate, today } from '@/lib/date'
import { findNavTitle } from './navItems'
import { HeaderSearch } from './HeaderSearch'

export function Header() {
  const { pathname, search, key } = useLocation()
  const quick = pathname === '/recommend' && new URLSearchParams(search).get('mode') === 'quick'
  return <header className="mf-bar">
    <div className="mf-crumb"><Link to="/dashboard">밀핏</Link><span aria-hidden="true">/</span>
      <span>{findNavTitle(pathname)}</span>{quick && <><span aria-hidden="true">/</span><span>15분 요리</span></>}
    </div>
    <HeaderSearch key={key} />
    <time dateTime={today()}>{formatFullKoreanDate(today())}</time>
  </header>
}
