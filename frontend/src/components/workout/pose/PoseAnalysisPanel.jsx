import { useId } from 'react'
import { Activity, Camera, Info, X } from 'lucide-react'
import { Spinner } from '@/components/common/Spinner'
import { POSE_PHASE, usePoseAnalysis } from '@/hooks/usePoseAnalysis'
import { POSE_MAX_SECONDS, POSE_MIN_SECONDS } from '@/models/poseFrames'
import { POSE_CAMERA_TIPS, cameraGuide } from '@/lib/poseCameraGuide'
import { PoseResult } from '@/components/workout/pose/PoseResult'

const PHASE_LABEL = {
  [POSE_PHASE.PREPARING]: '자세 인식 모델 준비 중...',
  [POSE_PHASE.EXTRACTING]: '영상에서 관절 위치 찾는 중',
  [POSE_PHASE.ANALYZING]: '자세 판정 중...',
}

// [자세판별] 운동 자세 분석 패널 (FR-WORK-05, MEALFIT-121). 운동 화면에 넣어 쓴다.
// 영상은 이 기기 안에서만 관절 좌표를 뽑는 데 쓰고 서버로 보내거나 저장하지 않는다.
export function PoseAnalysisPanel() {
  const id = useId()
  const pose = usePoseAnalysis()
  const guide = cameraGuide(pose.exercise)

  return (
    <section aria-labelledby={`${id}-title`} className="rounded-2xl border border-gray-200 bg-white p-5 shadow-xs md:p-6">
      <div className="mb-4 flex flex-wrap items-center gap-2 border-b border-gray-100 pb-3">
        <h3 id={`${id}-title`} className="flex items-center gap-2 text-base font-bold text-gray-900">
          <Activity aria-hidden="true" className="h-5 w-5 text-emerald-600" />운동 자세 분석
        </h3>
        <span className="rounded-md bg-gray-100 px-2 py-0.5 text-[11px] font-semibold text-gray-600">참고용</span>
      </div>

      {pose.unavailable ? (
        <p role="status" className="rounded-xl bg-gray-50 p-4 text-sm text-gray-600">자세 분석은 아직 준비 중입니다.</p>
      ) : (
        <>
          <p className="mb-4 text-sm leading-6 text-gray-600">
            운동하는 모습을 {POSE_MIN_SECONDS}~{POSE_MAX_SECONDS}초 촬영한 영상을 선택하면 반복마다 자세를 확인해 드려요.
            몸 전체가 화면에 들어오게 찍어 주세요.
          </p>

          <label htmlFor={`${id}-exercise`} className="label">운동</label>
          {pose.exercisesError ? (
            <div role="alert" className="mb-3 flex items-center justify-between gap-2 rounded-xl bg-rose-50 p-3 text-sm text-rose-700">
              <span className="break-words">{pose.exercisesError}</span>
              <button type="button" onClick={() => pose.retryExercises()} className="btn-secondary min-h-11 shrink-0">다시 시도</button>
            </div>
          ) : (
            <select id={`${id}-exercise`} value={pose.exercise} disabled={pose.busy || pose.exercisesLoading}
              onChange={(event) => pose.selectExercise(event.target.value)} className="input mb-3 min-h-11 w-full">
              <option value="">{pose.exercisesLoading ? '운동 목록 불러오는 중...' : '운동을 선택해 주세요'}</option>
              {pose.exercises.map((item) => <option key={item.name} value={item.name}>{item.name}</option>)}
            </select>
          )}

          <section aria-label="촬영 가이드" className="mb-3 rounded-xl border border-emerald-100 bg-emerald-50/60 p-3 text-xs leading-5 text-gray-700">
            <p className="mb-1 flex items-center gap-1.5 font-bold text-emerald-900"><Camera aria-hidden="true" className="h-4 w-4" />촬영 가이드</p>
            {guide && <p className="mb-1 font-semibold text-emerald-900">{pose.exercise}: {guide.text}</p>}
            <ul className="list-disc space-y-0.5 pl-4">
              {POSE_CAMERA_TIPS.map((tip) => <li key={tip}>{tip}</li>)}
            </ul>
          </section>

          <label htmlFor={`${id}-video`} className="label">운동 영상</label>
          <input id={`${id}-video`} type="file" accept="video/*" disabled={pose.busy}
            onChange={(event) => { const file = event.target.files?.[0]; event.target.value = ''; pose.selectVideo(file) }}
            aria-describedby={`${id}-privacy`}
            className="input min-h-11 w-full min-w-0 max-w-full text-sm file:mr-3 file:rounded-lg file:border-0 file:bg-emerald-50 file:px-3 file:py-2 file:text-emerald-800" />
          <p id={`${id}-privacy`} className="mt-2 text-xs leading-5 text-gray-500">
            영상은 이 기기 안에서만 관절 위치를 찾는 데 쓰고, 서버로 보내거나 저장하지 않아요. 서버에는 관절 좌표만 보내요.
          </p>

          {pose.video && (
            <video src={pose.video.url} controls muted playsInline aria-label="선택한 운동 영상 미리보기"
              className="mt-3 max-h-64 w-full rounded-xl bg-gray-900 object-contain" />
          )}

          <div className="mt-4" aria-live="polite" aria-busy={pose.busy}>
            {pose.busy ? (
              <div className="space-y-2">
                <div className="flex items-center justify-between gap-2 text-sm text-gray-700">
                  <span className="flex items-center gap-2"><Spinner />{PHASE_LABEL[pose.phase]}
                    {pose.phase === POSE_PHASE.EXTRACTING && ` ${pose.progress}%`}</span>
                  <button type="button" onClick={pose.cancel} className="btn-secondary flex min-h-11 items-center gap-1">
                    <X aria-hidden="true" className="h-4 w-4" />취소
                  </button>
                </div>
                {pose.phase === POSE_PHASE.EXTRACTING && (
                  <div role="progressbar" aria-label="관절 위치 찾기 진행률" aria-valuenow={pose.progress} aria-valuemin={0} aria-valuemax={100}
                    className="h-2 overflow-hidden rounded-full bg-gray-100">
                    <div className="h-full bg-emerald-500 transition-[width]" style={{ width: `${pose.progress}%` }} />
                  </div>
                )}
              </div>
            ) : (
              <button type="button" onClick={pose.analyze} disabled={!pose.video || !pose.exercise} className="btn-primary min-h-11 w-full">
                {pose.result ? '다시 분석하기' : '자세 분석하기'}
              </button>
            )}
          </div>

          {pose.error && <p role="alert" className="mt-4 whitespace-pre-wrap break-words rounded-xl bg-rose-50 p-3 text-sm text-rose-700">{pose.error}</p>}

          {pose.result && <PoseResult result={pose.result} />}

          {pose.result && (
            <div className="mt-4 space-y-1 rounded-xl bg-gray-50 p-3 text-[11px] leading-5 text-gray-500">
              <p className="flex items-start gap-1.5"><Info aria-hidden="true" className="mt-0.5 h-3.5 w-3.5 shrink-0" />
                <span>{pose.result.notice} 사람이 직접 보는 것이 더 정확해요.</span></p>
              <p>학습 데이터: AI Hub 「피트니스 자세 이미지」 (aihub.or.kr, 한국지능정보사회진흥원)</p>
              <p className="break-all">모델: {pose.result.modelVersion}</p>
            </div>
          )}

          {pose.speed && (
            <p className="mt-2 text-[11px] text-gray-400">
              처리({pose.speed.delegate}): 프레임 {pose.speed.frames}개 · 프레임당 평균 {pose.speed.avgMs}ms (p95 {pose.speed.p95Ms}ms) · 전체 {pose.speed.totalSeconds}초
            </p>
          )}
        </>
      )}
    </section>
  )
}
