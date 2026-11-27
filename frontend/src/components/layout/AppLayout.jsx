import { Outlet } from 'react-router-dom'
import { Sidebar } from './Sidebar'
import { Header } from './Header'
import { BottomNav } from './BottomNav'
import { SocialLinkPromptModal } from '@/components/common/SocialLinkPromptModal'

export function AppLayout() {
  return <div className="mf-shell">
    <a className="mf-skip" href="#mealfit-main">본문으로 이동</a>
    <Sidebar />
    <div className="min-w-0 flex-1">
      <Header />
      <main id="mealfit-main" className="mf-main" tabIndex={-1}><Outlet /></main>
    </div>
    <BottomNav />
    <SocialLinkPromptModal />
  </div>
}
