import { useEffect, useRef, useState } from 'react'
import { useMutation, useQuery } from '@tanstack/react-query'
import { getErrorCode, getErrorMessage } from '@/api/client'
import { poseApi } from '@/api/pose'
import { queryKeys } from '@/api/queryKeys'
import { loadPoseLandmarker } from '@/lib/poseLandmarker'
import { decodeVideoFrames, makePreviewVideo } from '@/lib/poseVideoDecoder'
import {
  POSE_FPS, buildPoseRequest, poseResultView, progressPercent, sampleTimes, scaledSize, summarizeSpeed, toPoseFrame,
  validatePoseDuration, validatePoseVideo,
} from '@/models/poseFrames'
import { thumbSize, toImagePoints } from '@/models/poseOverlay'

// [자세판별] 영상 선택 → 브라우저에서 관절 좌표 추출 → 판별 요청 흐름을 관리한다.
// 영상은 메모리(object URL)에서만 쓰고 새 영상 선택·화면 종료 시 해제한다. 서버로는 좌표만 보낸다 (D16, NFR-SEC-05).
// 브라우저가 직접 재생하지 못하는 영상(HEVC 등)은 ffmpeg.wasm으로 기기 안에서 풀어 같은 방식으로 관절을 찾는다.

export const POSE_PHASE = Object.freeze({
  IDLE: 'idle',
  PREPARING: 'preparing',
  CONVERTING: 'converting',
  EXTRACTING: 'extracting',
  ANALYZING: 'analyzing',
  DONE: 'done',
})

const UNAVAILABLE_CODE = 'WORKOUT_POSE_003'
const SEEK_TIMEOUT_MS = 10_000
const VIDEO_ERROR = '영상을 읽지 못했습니다. 다른 영상을 선택해 주세요.'
const MODEL_ERROR = '자세 인식 모델을 불러오지 못했습니다. 네트워크 상태를 확인한 뒤 다시 시도해 주세요.'
const DECODE_ERROR = '이 영상 형식은 읽을 수 없습니다. 휴대폰 카메라로 촬영한 원본 영상을 선택해 주세요.'

/** 브라우저가 영상을 열지 못함 (코덱 미지원 등) → ffmpeg.wasm 경로로 다시 시도한다 */
export class VideoReadError extends Error {}

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
  const [converted, setConverted] = useState(false)
  // 브라우저가 못 여는 영상(HEVC 등)은 미리보기용으로 작은 H.264 영상을 만들어 보여 준다
  const [preview, setPreview] = useState({ url: null, status: 'native', progress: 0 })
  // 관절 추출 결과 사진: 프레임별 썸네일(object URL)과 이미지 좌표. 이 기기 화면에서만 쓰고 서버로 보내지 않는다
  const [gallery, setGallery] = useState(null)
  const run = useRef({
    mounted: true, generation: 0, controller: null, url: null, selection: 0, previewUrl: null, galleryUrls: [],
  })

  // 화면을 닫으면 진행 중인 추출·요청을 멈추고 영상 메모리를 해제한다.
  useEffect(() => {
    const state = run.current
    state.mounted = true
    return () => {
      state.mounted = false
      state.generation++
      state.controller?.abort()
      if (state.url) URL.revokeObjectURL(state.url)
      if (state.previewUrl) URL.revokeObjectURL(state.previewUrl)
      releaseGallery(state)
      state.url = null
      state.previewUrl = null
    }
  }, [])

  function clearGallery() {
    releaseGallery(run.current)
    setGallery(null)
  }

  const busy = phase === POSE_PHASE.PREPARING || phase === POSE_PHASE.CONVERTING || phase === POSE_PHASE.EXTRACTING
    || phase === POSE_PHASE.ANALYZING

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
    setConverted(false)
    clearGallery()
    state.selection++
    if (state.previewUrl) URL.revokeObjectURL(state.previewUrl)
    state.previewUrl = null
    setPreview({ url: null, status: 'native', progress: 0 })
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

  // 미리보기 <video>가 화면을 못 그리면(코덱 미지원) 기기 안에서 재생 가능한 영상으로 바꿔 다시 보여 준다.
  // 분석은 이 미리보기가 아니라 원본 영상으로 한다.
  function checkPreview(event) {
    const state = run.current
    const element = event?.currentTarget
    const unplayable = event?.type === 'error' || !element?.videoWidth
    if (!unplayable || !video || preview.status !== 'native') return
    const selection = state.selection
    const current = () => state.mounted && selection === state.selection
    setPreview({ url: null, status: 'converting', progress: 0 })
    makePreviewVideo(video.url, {
      onProgress: (value) => { if (current()) setPreview((old) => ({ ...old, progress: value })) },
    }).then((url) => {
      if (!current()) return URL.revokeObjectURL(url)
      state.previewUrl = url
      setPreview({ url, status: 'converted', progress: 100 })
    }).catch(() => {
      if (current()) setPreview({ url: null, status: 'failed', progress: 0 })
    })
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
    setConverted(false)
    clearGallery()
    setProgress(0)
    try {
      setPhase(POSE_PHASE.PREPARING)
      const { landmarker, delegate } = await loadPoseLandmarker().catch(() => { throw new Error(MODEL_ERROR) })
      if (!alive()) return
      setPhase(POSE_PHASE.EXTRACTING)
      const onProgress = (value) => { if (alive()) setProgress(value) }
      let extracted
      try {
        extracted = await extractPoseFrames(landmarker, video.url, alive, onProgress)
      } catch (failure) {
        if (!(failure instanceof VideoReadError) || !alive()) throw failure
        setConverted(true)
        setProgress(0)
        setPhase(POSE_PHASE.CONVERTING)
        extracted = await extractPoseFramesDecoded(landmarker, video.url, alive, (value) => {
          if (!alive()) return
          setPhase(POSE_PHASE.EXTRACTING)
          setProgress(value)
        })
      }
      if (!extracted || !alive()) {
        releaseUrls(extracted?.gallery?.thumbs)
        return
      }
      state.galleryUrls = extracted.gallery.thumbs.filter(Boolean)
      setGallery(extracted.gallery)
      setSpeed({ ...extracted.speed, delegate, converted: extracted.converted === true })
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
    checkPreview,
    preview,
    gallery,
    converted,
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
    // 소리만 읽히고 화면 크기가 0이면 브라우저가 영상 코덱을 못 푼 것이다
    if (!video.videoWidth || !video.videoHeight) throw new VideoReadError(VIDEO_ERROR)
    validatePoseDuration(video.duration)
    const size = scaledSize(video.videoWidth, video.videoHeight)
    const canvas = document.createElement('canvas')
    canvas.width = size.width
    canvas.height = size.height
    const context = canvas.getContext('2d')
    context.imageSmoothingQuality = 'high'
    const times = sampleTimes(video.duration)
    const frames = []
    const frameMs = []
    const recorder = createFrameRecorder(size.width, size.height)
    const started = performance.now()
    for (let i = 0; i < times.length; i++) {
      if (!alive()) {
        releaseUrls((await recorder.finish(i)).thumbs)
        return null
      }
      await seek(video, times[i])
      context.drawImage(video, 0, 0, size.width, size.height)
      const before = performance.now()
      const found = landmarker.detect(canvas)
      frameMs.push(performance.now() - before)
      frames.push(toPoseFrame(found.worldLandmarks?.[0], found.landmarks?.[0]))
      recorder.add(i, canvas, found.landmarks?.[0])
      onProgress(progressPercent(i + 1, times.length))
    }
    const speed = summarizeSpeed(frameMs, performance.now() - started)
    return { frames, speed, gallery: await recorder.finish(times.length) }
  } finally {
    video.removeAttribute('src')
    video.load()
  }
}

// 브라우저가 못 여는 영상: ffmpeg.wasm으로 15fps·긴 변 960px RGBA 프레임을 풀어 같은 IMAGE 모드로 관절을 찾는다.
export async function extractPoseFramesDecoded(landmarker, url, alive = () => true, onProgress = () => {}) {
  const frames = []
  const frameMs = []
  let recorder = null
  let scratch = null
  let total = 0
  let started = 0
  let duration
  let durationError = null
  try {
    duration = await decodeVideoFrames(url, {
      alive,
      onDuration: (seconds) => {
        try {
          validatePoseDuration(seconds)
        } catch (failure) {
          durationError = failure
          throw failure
        }
        total = sampleTimes(seconds).length
        started = performance.now()
      },
      onChunk: (chunkFrames, width, height, chunk) => {
        chunkFrames.forEach((rgba, i) => {
          const image = new ImageData(new Uint8ClampedArray(rgba.buffer, rgba.byteOffset, rgba.length), width, height)
          const before = performance.now()
          const found = landmarker.detect(image)
          frameMs.push(performance.now() - before)
          frames[chunk.first + i] = toPoseFrame(found.worldLandmarks?.[0], found.landmarks?.[0])
          if (!recorder) {
            recorder = createFrameRecorder(width, height)
            scratch = document.createElement('canvas')
            scratch.width = width
            scratch.height = height
          }
          scratch.getContext('2d').putImageData(image, 0, 0)
          recorder.add(chunk.first + i, scratch, found.landmarks?.[0])
        })
        onProgress(progressPercent(Math.min(chunk.first + chunk.count, total), total))
      },
    })
  } catch {
    // 길이 제한 안내는 그대로, 디코더 자체 오류는 형식 안내로 바꾼다
    throw durationError ?? new Error(DECODE_ERROR)
  }
  const gallery = recorder ? await recorder.finish(total)
    : { width: 16, height: 9, thumbs: Array(total).fill(null), points: Array(total).fill(null) }
  if (!alive() || !Number.isFinite(duration)) {
    releaseUrls(gallery.thumbs)
    return null
  }
  // 영상 끝에서 모자란 프레임은 사람 미검출과 같이 null로 둔다
  const all = Array.from({ length: total }, (_, i) => frames[i] ?? null)
  return { frames: all, speed: summarizeSpeed(frameMs, performance.now() - started), converted: true, gallery }
}

// 관절 추출 결과 사진용: 프레임마다 작은 JPEG 썸네일과 이미지 좌표(0~1)를 기기 메모리에만 남긴다
function createFrameRecorder(width, height) {
  const size = thumbSize(width, height)
  const canvas = document.createElement('canvas')
  canvas.width = size.width
  canvas.height = size.height
  const context = canvas.getContext('2d')
  context.imageSmoothingQuality = 'high'
  const thumbs = []
  const points = []
  const pending = []
  return {
    add(index, source, imageLandmarks) {
      points[index] = toImagePoints(imageLandmarks)
      context.drawImage(source, 0, 0, size.width, size.height)
      // toBlob은 부른 시점의 그림을 담으므로 다음 프레임을 바로 그려도 된다
      pending.push(new Promise((resolve) => {
        canvas.toBlob((blob) => {
          thumbs[index] = blob ? URL.createObjectURL(blob) : null
          resolve()
        }, 'image/jpeg', 0.8)
      }))
    },
    async finish(total) {
      await Promise.all(pending)
      return {
        width: size.width,
        height: size.height,
        thumbs: Array.from({ length: total }, (_, i) => thumbs[i] ?? null),
        points: Array.from({ length: total }, (_, i) => points[i] ?? null),
      }
    },
  }
}

function releaseUrls(urls) {
  for (const url of urls ?? []) if (url) URL.revokeObjectURL(url)
}

function releaseGallery(state) {
  releaseUrls(state.galleryUrls)
  state.galleryUrls = []
}

function waitFor(video, eventName) {
  return new Promise((resolve, reject) => {
    const timer = setTimeout(() => finish(reject, new VideoReadError(VIDEO_ERROR)), SEEK_TIMEOUT_MS)
    const onDone = () => finish(resolve)
    const onError = () => finish(reject, new VideoReadError(VIDEO_ERROR))
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
