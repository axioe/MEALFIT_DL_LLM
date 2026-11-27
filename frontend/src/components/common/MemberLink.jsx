import { Link } from 'react-router-dom'
import { useGuestLogin } from '@/hooks/useGuestLogin'

export function MemberLink({ to, feature, children, ...props }) {
  const requestLogin = useGuestLogin()
  if (requestLogin) {
    return <button {...props} type="button" aria-haspopup="dialog" onClick={() => requestLogin(feature, to)}>{children}</button>
  }
  return <Link {...props} to={to}>{children}</Link>
}
