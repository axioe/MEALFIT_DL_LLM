import { Link, useLocation } from 'react-router-dom'
import { formatFullKoreanDate, today } from '@/lib/date'
import { findNavTitle } from './navItems'
import { HeaderSearch } from './HeaderSearch'
import { Search } from 'lucide-react'
import { useGuestLogin } from '@/hooks/useGuestLogin'

export function Header() {
  const { pathname, search, key } = useLocation()
  const requestLogin = useGuestLogin()
  const quick = pathname === '/recommend' && new URLSearchParams(search).get('mode') === 'quick'
  return <header className="mf-bar">
    <div className="mf-crumb"><Link to="/dashboard">밀핏</Link><span aria-hidden="true">/</span>
      <span>{findNavTitle(pathname)}</span>{quick && <><span aria-hidden="true">/</span><span>15분 요리</span></>}
    </div>
    {requestLogin ? <div className="mf-header-search"><button type="button" aria-haspopup="dialog"
      className="mf-search-form w-full cursor-pointer justify-between text-gray-500" aria-label="통합 검색"
      onClick={() => requestLogin('통합 검색')}>레시피, 재료, 운동 검색<span className="mf-search-submit"><Search size={20} aria-hidden="true" /></span></button></div>
      : <HeaderSearch key={key} />}
    <div className="flex items-center gap-3"><time dateTime={today()}>{formatFullKoreanDate(today())}</time>
      {requestLogin && <Link to="/login" className="mf-text-link">로그인</Link>}</div>
  </header>
}
