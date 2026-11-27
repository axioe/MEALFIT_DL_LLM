import { useState } from 'react'
import { Link, useLocation, useSearchParams } from 'react-router-dom'
import { AppLayout } from '@/components/layout/AppLayout'
import { FirstFridgeBanner } from '@/components/dashboard/HomeDinner'
import { QuickExample } from '@/components/recommend/QuickExample'
import { MemberLink } from '@/components/common/MemberLink'
import { LoginPromptDialog } from '@/components/common/LoginPromptDialog'
import { GuestLoginContext, useGuestLogin } from '@/hooks/useGuestLogin'

const exampleMeals = [
  { meal: '아침', name: '달걀 토스트' },
  { meal: '점심', name: '버섯 비빔밥' },
  { meal: '저녁', name: '두부 달걀 덮밥' },
]
const exampleExercises = {
  상체: ['덤벨 컬', '레터럴 레이즈'], 하체: ['스쿼트', '런지'], 코어: ['플랭크', '바이시클 크런치'],
}

function GuestHome() {
  return <div className="mf-stack">
    <header className="mf-heading mb-0"><div><h1>오늘의 밀핏</h1><p>저녁 메뉴부터 재료 준비까지 한곳에서 확인하세요.</p></div></header>
    <FirstFridgeBanner />
    <div className="grid gap-4 sm:grid-cols-2">
      <section className="card mf-stack"><h2 className="mf-section-title">오늘 식단</h2>
        <p className="mf-copy">아침부터 저녁까지, 하루 식단 예시를 둘러보세요.</p>
        <Link className="mf-text-link" to="/recommend">식단 예시 보기</Link>
        <MemberLink to="/mypage?tab=allergies" feature="식단 조건 설정" className="mf-text-link">식단 조건 설정</MemberLink>
      </section>
      <section className="card mf-stack"><h2 className="mf-section-title">오늘 운동</h2>
        <p className="mf-copy">운동하고 싶은 부위를 선택해 동작을 살펴보세요.</p>
        <Link className="mf-text-link" to="/workout">운동 둘러보기</Link>
      </section>
    </div>
  </div>
}

function GuestMeals() {
  const [params] = useSearchParams()
  const requestLogin = useGuestLogin()
  const quick = params.get('mode') === 'quick'
  return <div className="mf-stack">
    <header className="mf-heading mb-0"><div><h1>{quick ? '15분 요리 예시' : '오늘 식단 예시'}</h1></div>
      <Link className="btn-secondary" to={quick ? '/recommend' : '/recommend?mode=quick&example=1'}>
        {quick ? '하루 식단 보기' : '15분 요리 보기'}
      </Link>
    </header>
    {quick ? <QuickExample /> : <div className="grid gap-4 sm:grid-cols-3">{exampleMeals.map(({ meal, name }) =>
      <section key={meal} className="card mf-stack"><span className="mf-label">{meal}</span><h2 className="mf-section-title">{name}</h2>
        <button type="button" className="btn-primary justify-self-start" aria-haspopup="dialog" onClick={() => requestLogin('식단 확정')}>이 메뉴로 정하기</button>
      </section>)}</div>}
  </div>
}

function GuestWorkout() {
  const [area, setArea] = useState('상체')
  const requestLogin = useGuestLogin()
  return <div className="mf-stack"><header className="mf-heading mb-0"><div><h1>운동 둘러보기</h1></div></header>
    <section className="card mf-stack"><h2 className="mf-section-title">부위별 운동 예시</h2>
      <div className="flex flex-wrap gap-2">{Object.keys(exampleExercises).map(name =>
        <button type="button" key={name} className="mf-chip" aria-pressed={area === name} onClick={() => setArea(name)}>{name}</button>)}</div>
      <ul className="mf-list" aria-label={area + ' 운동'}>{exampleExercises[area].map(name => <li key={name}>{name}</li>)}</ul>
      <button type="button" className="btn-primary justify-self-start" aria-haspopup="dialog" onClick={() => requestLogin('내 운동 루틴')}>내 루틴 보기</button>
    </section>
  </div>
}

export function GuestPage({ screen, onRetrySession }) {
  const location = useLocation()
  const [prompt, setPrompt] = useState(null)
  function requestLogin(feature, returnTo = location.pathname + location.search + location.hash) {
    setPrompt({ feature, returnTo })
  }
  return <GuestLoginContext.Provider value={requestLogin}>
    <AppLayout>
      {onRetrySession && <div className="mf-note mb-4" role="status">로그인 상태를 확인하지 못했어요.
        <button type="button" className="mf-text-link" onClick={onRetrySession}>다시 확인</button>
      </div>}
      {screen === 'home' ? <GuestHome /> : screen === 'meals' ? <GuestMeals /> : <GuestWorkout />}
    </AppLayout>
    {prompt && <LoginPromptDialog {...prompt} onClose={() => setPrompt(null)} />}
  </GuestLoginContext.Provider>
}
