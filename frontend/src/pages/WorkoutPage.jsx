import { useRef, useState } from 'react'
import { Link } from 'react-router-dom'
import { getErrorMessage } from '@/api/client'
import { useWorkoutWeek } from '@/hooks/useWorkoutWeek'
import { today, formatKoreanDate } from '@/lib/date'

const statusLabels = { COMPLETED: '완료', PARTIAL: '일부 수행', SKIPPED: '건너뜀' }

function RoutineDay({ day, routineId, saved, canRecord, busy, run }) {
  const [prompt, setPrompt] = useState('')
  const [started, setStarted] = useState(false)
  const [minutes, setMinutes] = useState(String(saved?.actualMinutes || day.durationMinutes || ''))
  const [status, setStatus] = useState(saved?.status ?? 'COMPLETED')
  const blocked = Boolean(day.startBlocked)
  function adjust(value) { return run({ action: 'adjust', routineId, date: day.date, prompt: value }) }
  async function record(event) {
    event.preventDefault()
    const ok = await run({ action: 'log', body: { sessionId: day.sessionId, status, actualMinutes: status === 'SKIPPED' ? 0 : Number(minutes) } })
    if (ok) setStarted(false)
  }
  if (!day.sessionId || day.isRestDay) return <section className="card mf-stack"><h2 className="mf-section-title">{day.isRestDay ? '오늘은 쉬는 날이에요' : '이날은 예정된 운동이 없어요'}</h2><p>다른 요일을 선택하면 그날의 루틴을 볼 수 있어요.</p></section>
  return <div className="mf-two">
    <section className="card mf-stack"><span className="mf-status">{formatKoreanDate(day.date)} · {day.focusArea}</span><h2 className="mf-title">{day.title}</h2>
      <div className="flex flex-wrap gap-2" aria-label="운동 시간 변경">{[...new Set([15,30,day.durationMinutes].filter(Boolean))].sort((a,b)=>a-b).map(n => <button key={n} className="mf-chip" aria-pressed={day.durationMinutes === n} disabled={busy || blocked || started} onClick={() => { if (day.durationMinutes !== n) adjust(n + '분으로 변경') }}>{n}분</button>)}</div>
      <div className="mf-stack">{[['준비 운동', day.warmUp], ['본운동', day.exercises], ['마무리', day.coolDown]].map(([label,rows]) => <section key={label}><h3 className="mf-label">{label}</h3>
        {rows?.length ? <ul className="mf-list">{rows.map((row,i) => <li key={row.code + '-' + i}><b>{row.name}</b><span className="text-sm">{[row.sets > 0 && row.sets + '세트', row.reps > 0 && row.reps + '회', row.seconds > 0 && row.seconds + '초'].filter(Boolean).join(' · ')}</span></li>)}</ul> : <p className="text-sm">등록된 동작이 없어요.</p>}</section>)}</div>
      {day.adjustNote && <p className="mf-note">{day.adjustNote}</p>}
      {blocked && <p role="status" className="mf-status warn">이 세션의 운동 시작이 제한됐어요.</p>}
      {saved?.status && <p className="mf-status">기록 · {statusLabels[saved.status]}{saved.actualMinutes > 0 && ' · ' + saved.actualMinutes + '분'}</p>}
      {!started ? <button className="btn-primary justify-self-start" disabled={busy || !canRecord || (blocked && saved?.status === 'SKIPPED')} onClick={() => { if (blocked) setStatus('SKIPPED'); setStarted(true) }}>{!canRecord ? '해당 날짜에 기록 가능' : saved?.status ? '운동 기록 수정' : blocked ? '건너뜀 기록' : '운동 시작'}</button> :
      <form className="mf-stack mf-note" onSubmit={record}><label className="label">수행 상태<select className="input mt-1" value={blocked ? 'SKIPPED' : status} onChange={e => setStatus(e.target.value)} disabled={busy || blocked}>{Object.entries(statusLabels).map(([val,label]) => <option value={val} key={val}>{label}</option>)}</select></label>
        {status !== 'SKIPPED' && <label className="label">실제로 운동한 시간 (분)<input className="input mt-1" type="number" min="1" max="300" required value={minutes} onChange={e => setMinutes(e.target.value)} disabled={busy} /></label>}
        <button className="btn-primary" disabled={busy}>운동 기록 저장</button><button className="btn-secondary" type="button" disabled={busy} onClick={() => setStarted(false)}>닫기</button>
      </form>}
    </section><aside className="card mf-stack"><h2 className="mf-section-title">운동 부위 조정</h2>
      {day.focusArea?.includes('상체') && <img className="mf-body-art" src="/wireframe/exercise-upper.svg" alt="" />}
      <p className="mf-copy">현재 부위 · {day.focusArea}</p><div className="flex flex-wrap gap-2">{['상체','하체','회복'].map(label => <button className="mf-chip" key={label} aria-pressed={day.focusArea?.includes(label) || false} disabled={busy || blocked || started} onClick={() => adjust(label + ' 운동으로 변경')}>{label}</button>)}</div>
      <details className="mf-options"><summary>문장으로 조정</summary><form onSubmit={e => { e.preventDefault(); if (prompt.trim()) adjust(prompt.trim()) }} className="mf-stack mt-3"><label className="label">바꾸고 싶은 점<input required maxLength={500} className="input mt-1" placeholder="오늘은 15분만 할래요" value={prompt} onChange={e => setPrompt(e.target.value)} /></label><button className="btn-secondary" disabled={!prompt.trim() || busy || blocked || started}>루틴에 반영</button></form></details>
      <Link className="mf-text-link" to="/mypage?tab=fitness">운동 조건 보기</Link>
    </aside>
  </div>
}

export function WorkoutPage() {
  const now = today()
  const [date, setDate] = useState(now)
  const [feedback, setFeedback] = useState('')
  const [failure, setFailure] = useState('')
  const lock = useRef(false)
  const { routine, summary, change } = useWorkoutWeek(now)
  const day = routine.data?.days?.find(item => item.date === date)
  async function run(input) {
    if (lock.current || change.isPending || routine.isFetching) return false
    lock.current = true; setFeedback(''); setFailure('')
    try {
      const result = await change.mutateAsync(input)
      const notes = result?.notices?.filter(Boolean).join(' ')
      setFeedback(notes || (input.action === 'make' ? '이번 주 루틴을 만들었어요.' : input.action === 'log' ? '운동 기록을 저장했어요.' : result.adjusted ? '운동을 조정했어요.' : result.adjustNote || '기존 루틴을 유지해요.'))
      return true
    } catch (error) { setFailure(getErrorMessage(error)); return false }
    finally { lock.current = false }
  }
  return <div className="mf-stack"><header className="mf-heading"><div><h1>오늘 운동</h1><p>요일별 루틴을 보고 오늘 가능한 시간과 부위를 고르세요.</p></div></header>
    {feedback && <p className="mf-note" role="status">{feedback}</p>}{failure && <p className="card" role="alert">{failure}</p>}
    {routine.isPending ? <p className="card" role="status">이번 주 루틴을 확인하고 있어요.</p> : routine.isError ? <div className="card mf-stack" role="alert"><p>{getErrorMessage(routine.error)}</p><button className="btn-secondary justify-self-start" onClick={() => routine.refetch()}>다시 조회</button></div> :
      !routine.data?.routineId ? <div className="card mf-stack"><h2 className="mf-section-title">이번 주 루틴을 만들어 볼까요?</h2><p>내 설정에 등록한 운동 조건을 반영해요.</p><div className="flex gap-2"><button className="btn-primary" disabled={change.isPending || routine.isFetching} onClick={() => run({ action: 'make' })}>이번 주 루틴 만들기</button><Link className="btn-secondary" to="/mypage">내 설정</Link></div></div> :
      <><div className="flex flex-wrap gap-2" aria-label="요일별 루틴">{routine.data.days.map(item => <button className="mf-chip" key={item.date} aria-pressed={date === item.date} disabled={change.isPending} onClick={() => { setDate(item.date); setFeedback(''); setFailure('') }}>{formatKoreanDate(item.date)}</button>)}</div>
        {routine.data.notices?.map(note => <p key={note} className="mf-note">{note}</p>)}
        {day && <RoutineDay key={String(day.sessionId) + day.date + (day.durationMinutes ?? '')} day={day} routineId={routine.data.routineId} saved={summary.data?.items?.find(row => row.sessionId === day.sessionId)} canRecord={day.date <= now && summary.isSuccess}
          busy={change.isPending || routine.isFetching || summary.isFetching} run={run} />}
        {summary.isError && <div className="mf-note" role="alert">운동 기록을 확인하지 못했어요.<button className="btn-secondary" onClick={() => summary.refetch()}>기록 다시 조회</button></div>}
        {summary.isSuccess && <p className="text-sm text-gray-600">이번 주 · 완료 {summary.data.completedCount}회 / 예정 {summary.data.plannedSessions}회 · 총 {summary.data.totalActualMinutes}분</p>}
        {routine.data.disclaimer && <p className="text-xs text-gray-600">{routine.data.disclaimer}</p>}</>}
  </div>
}
