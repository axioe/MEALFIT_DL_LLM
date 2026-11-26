import { useEffect, useRef, useState } from 'react'
import { useMutation, useQuery } from '@tanstack/react-query'
import { getErrorCode, getErrorMessage } from '@/api/client'
import { poseApi } from '@/api/pose'
import { queryKeys } from '@/api/queryKeys'
import { loadPoseLandmarker } from '@/lib/poseLandmarker'
import {
  POSE_FPS, buildPoseRequest, poseResultView, progressPercent, sampleTimes, scaledSize, summarizeSpeed, toPoseFrame,
  validatePoseDuration, validatePoseVideo,
} from '@/models/poseFrames'

// [자세판별] 영상 선택 → 브라우저에서 관절 좌표 추출 → 판별 요청 흐름을 관리한다.
// 영상은 메모리(object URL)에서만 쓰고 새 영상 선택·화면 종료 시 해제한다. 서버로는 좌표만 보낸다 (D16, NFR-SEC-05).

export const POSE_PHASE = Object.freeze({
  IDLE: 'idle',
  PREPARING: 'preparing',
  EXTRACTING: 'extracting',
  ANALYZING: 'analyzing',
  DONE: 'done',
})

const UNAVAILABLE_CODE = 'WORKOUT_POSE_003'
const SEEK_TIMEOUT_MS = 10_000
const VIDEO_ERROR = '영상을 읽지 못했습니다. 다른 영상을 선택해 주세요.'
const MODEL_ERROR = '자세 인식 모델을 불러오지 못했습니다. 네트워크 상태를 확인한 뒤 다시 시도해 주세요.'

export function usePoseAnalysis() {
  const exercisesQuery = useQuery({
    queryKey: queryKeys.pose.exercises,
    queryFn: ({ signal }) => poseApi.getExercises(signal),
    staleTime: 10 * 60_000,
    retry: false,
  })
  const mutation = useMutation({ mutationFn: poseApi.analyze, retry: false, gcTime: 0 })
  const [exercise, setExercise] = useState('')
  const [video, setVideo] = useState(null)
  const [phase, setPhase] = useState(POSE_PHASE.IDLE)
  const [progress, setProgress] = useState(0)
  const [speed, setSpeed] = useState(null)
  const [result, setResult] = useState(null)
  const [error, setError] = useState('')
  const run = useRef({ mounted: true, generation: 0, controller: null, url: null })

  // 화면을 닫으면 진행 중인 추출·요청을 멈추고 영상 메모리를 해제한다.
  useEffect(() => {
    const state = run.current
    state.mounted = true
    return () => {
      state.mounted = false
      state.generation++
      state.controller?.abort()
      if (state.url) URL.revokeObjectURL(state.url)
      state.url = null
    }
  }, [])

  const busy = phase === POSE_PHASE.PREPARING || phase === POSE_PHASE.EXTRACTING || phase === POSE_PHASE.ANALYZING

  function resetRun() {
    const state = run.current
    state.generation++
    state.controller?.abort()
    state.controller = null
    setPhase(POSE_PHASE.IDLE)
    setProgress(0)
  }

  function selectVideo(file) {
    const state = run.current
    resetRun()
    setError('')
    setResult(null)
    setSpeed(null)
    if (state.url) URL.revokeObjectURL(state.url)
    state.url = null
    setVideo(null)
    if (!file) return
    try {
      validatePoseVideo(file)
    } catch (failure) {
      setError(failure.message)
      return
    }
    state.url = URL.createObjectURL(file)
    setVideo({ name: file.name, url: state.url })
  }

  function selectExercise(name) {
    setExercise(name)
    setResult(null)
  }

  async function analyze() {
    const state = run.current
    if (!video || !exercise || busy) return
    const generation = ++state.generation
    const alive = () => state.mounted && generation === state.generation
    setError('')
    setResult(null)
    setSpeed(null)
    setProgress(0)
    try {
      setPhase(POSE_PHASE.PREPARING)
      const { landmarker, delegate } = await loadPoseLandmarker().catch(() => { throw new Error(MODEL_ERROR) })
      if (!alive()) return
      setPhase(POSE_PHASE.EXTRACTING)
      const extracted = await extractPoseFrames(landmarker, video.url, alive, (value) => { if (alive()) setProgress(value) })
      if (!extracted || !alive()) return
      setSpeed({ ...extracted.speed, delegate })
      const body = buildPoseRequest(exercise, extracted.frames, POSE_FPS)
      setPhase(POSE_PHASE.ANALYZING)
      const controller = new AbortController()
      state.controller = controller
      const response = await mutation.mutateAsync({ body, signal: controller.signal })
      if (!alive()) return
      setResult(poseResultView(response))
      setPhase(POSE_PHASE.DONE)
    } catch (failure) {
      if (!alive()) return
      setError(failure instanceof Error && !failure.isAxiosError ? failure.message : getErrorMessage(failure))
      setPhase(POSE_PHASE.IDLE)
    } finally {
      if (alive()) state.controller = null
    }
  }

  return {
    exercises: exercisesQuery.data?.exercises ?? [],
    exercisesLoading: exercisesQuery.isPending,
    unavailable: getErrorCode(exercisesQuery.error) === UNAVAILABLE_CODE,
    exercisesError: exercisesQuery.error && getErrorCode(exercisesQuery.error) !== UNAVAILABLE_CODE
      ? getErrorMessage(exercisesQuery.error) : '',
    retryExercises: exercisesQuery.refetch,
    exercise,
    selectExercise,
    video,
    selectVideo,
    phase,
    busy,
    progress,
    speed,
    result,
    error,
    analyze,
    cancel: resetRun,
  }
}

// 영상을 15fps 간격으로 넘기며 프레임마다 IMAGE 모드로 관절을 찾는다 (학습 추출과 같은 방식).
// 화면 밖 비교 시험에서도 같은 코드를 쓰도록 내보낸다.
export async function extractPoseFrames(landmarker, url, alive = () => true, onProgress = () => {}) {
  const video = document.createElement('video')
  video.muted = true
  video.playsInline = true
  video.preload = 'auto'
  video.src = url
  try {
    await waitFor(video, 'loadeddata')
    validatePoseDuration(video.duration)
    if (!video.videoWidth || !video.videoHeight) throw new Error(VIDEO_ERROR)
    const size = scaledSize(video.videoWidth, video.videoHeight)
    const canvas = document.createElement('canvas')
    canvas.width = size.width
    canvas.height = size.height
    const context = canvas.getContext('2d')
    context.imageSmoothingQuality = 'high'
    const times = sampleTimes(video.duration)
    const frames = []
    const frameMs = []
    const started = performance.now()
    for (let i = 0; i < times.length; i++) {
      if (!alive()) return null
      await seek(video, times[i])
      context.drawImage(video, 0, 0, size.width, size.height)
      const before = performance.now()
      const found = landmarker.detect(canvas)
      frameMs.push(performance.now() - before)
      frames.push(toPoseFrame(found.worldLandmarks?.[0], found.landmarks?.[0]))
      onProgress(progressPercent(i + 1, times.length))
    }
    return { frames, speed: summarizeSpeed(frameMs, performance.now() - started) }
  } finally {
    video.removeAttribute('src')
    video.load()
  }
}

function waitFor(video, eventName) {
  return new Promise((resolve, reject) => {
    const timer = setTimeout(() => finish(reject, new Error(VIDEO_ERROR)), SEEK_TIMEOUT_MS)
    const onDone = () => finish(resolve)
    const onError = () => finish(reject, new Error(VIDEO_ERROR))
    function finish(callback, value) {
      clearTimeout(timer)
      video.removeEventListener(eventName, onDone)
      video.removeEventListener('error', onError)
      callback(value)
    }
    video.addEventListener(eventName, onDone)
    video.addEventListener('error', onError)
  })
}

function seek(video, time) {
  const done = waitFor(video, 'seeked')
  video.currentTime = time
  return done
}
