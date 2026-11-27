import { Link, useLocation } from 'react-router-dom'
import { findNavTitle } from './navItems'
import { HeaderSearch } from './HeaderSearch'
import { useGuestLogin } from '@/hooks/useGuestLogin'

export function Header() {
  const { pathname, search, key } = useLocation()
  const requestLogin = useGuestLogin()
  const quick = pathname === '/recommend' && new URLSearchParams(search).get('mode') === 'quick'
  return <header className="mf-bar">
    <div className="mf-crumb"><Link to="/dashboard">밀핏</Link><span aria-hidden="true">/</span>
      <span>{findNavTitle(pathname)}</span>{quick && <><span aria-hidden="true">/</span><span>15분 요리</span></>}
    </div>
    <HeaderSearch key={key} />
    {requestLogin && (
      <nav aria-label="회원 메뉴" className="flex shrink-0 items-center gap-1.5 whitespace-nowrap">
        <Link to="/login" className="mf-text-link">로그인</Link>
        <span aria-hidden="true" className="text-sm text-gray-400">/</span>
        <Link to="/signup" className="mf-text-link">회원가입</Link>
      </nav>
    )}
  </header>
}
