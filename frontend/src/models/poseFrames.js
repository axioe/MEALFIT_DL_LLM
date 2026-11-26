import { POSE_ANALYSIS_STATUS } from '../lib/enums.js'
import { cameraGuide } from '../lib/poseCameraGuide.js'

// 운동 자세 판별(FR-WORK-05)용 순수 함수. 학습 데이터 추출과 같은 조건으로 관절 좌표를 만든다.
// 학습: MediaPipe heavy, IMAGE 모드, 긴 변 960px 축소. 요청: 15fps·60초·900프레임·3MB 이하, 좌표 소수 4자리 (SDD 5.9, AI-05).

export const POSE_FPS = 15
export const POSE_MIN_SECONDS = 1
export const POSE_MAX_SECONDS = 60
export const POSE_MAX_FRAMES = 900
export const POSE_JOINTS = 33
export const POSE_MAX_SIDE = 960
export const POSE_MAX_BYTES = 3 * 1024 * 1024
export const POSE_MAX_COORD = 10

/** 영상 파일 확인: 영상 형식만 받는다. 파일은 브라우저 안에서만 쓰고 서버로 보내지 않는다 */
export function validatePoseVideo(file) {
  if (!file || !file.size) throw new Error('운동 영상을 선택해 주세요.')
  if (file.type && !file.type.startsWith('video/')) throw new Error('영상 파일(MP4·MOV 등)을 선택해 주세요.')
}

/** 영상 길이 확인 (초) */
export function validatePoseDuration(seconds) {
  if (!Number.isFinite(seconds) || seconds <= 0) throw new Error('영상 길이를 읽지 못했습니다. 다른 영상을 선택해 주세요.')
  if (seconds < POSE_MIN_SECONDS) throw new Error(`${POSE_MIN_SECONDS}초 이상 촬영한 영상을 선택해 주세요.`)
  if (seconds > POSE_MAX_SECONDS) throw new Error(`${POSE_MAX_SECONDS}초 이하로 촬영한 영상을 선택해 주세요.`)
}

/** 좌표를 뽑을 시각(초) 목록: 0초부터 1/fps 간격, 영상 길이 안쪽, 최대 900개 */
export function sampleTimes(duration, fps = POSE_FPS) {
  const count = Math.min(Math.floor(duration * fps + 1e-9), POSE_MAX_FRAMES)
  return Array.from({ length: count }, (_, i) => i / fps)
}

/** 학습 추출과 같은 크기: 긴 변이 960px보다 크면 비율대로 줄이고(정수 버림), 작으면 그대로 */
export function scaledSize(width, height, maxSide = POSE_MAX_SIDE) {
  const scale = maxSide / Math.max(width, height)
  if (!(scale < 1)) return { width, height }
  return { width: Math.trunc(width * scale), height: Math.trunc(height * scale) }
}

/** 소수 4자리 반올림 (-0 은 0) */
export function roundCoord(value) {
  return Math.round(value * 10_000) / 10_000 || 0
}

/**
 * MediaPipe 결과 한 프레임 → [x, y, z, visibility] × 33.
 * 학습과 같이 x·y·z 는 world 좌표, visibility 는 이미지 좌표의 값을 쓴다. 사람이 없거나 값이 이상하면 null.
 */
export function toPoseFrame(worldLandmarks, imageLandmarks) {
  if (!Array.isArray(worldLandmarks) || worldLandmarks.length !== POSE_JOINTS) return null
  const frame = []
  for (let i = 0; i < POSE_JOINTS; i++) {
    const { x, y, z } = worldLandmarks[i] ?? {}
    const visibility = imageLandmarks?.[i]?.visibility ?? 0
    const point = [x, y, z].map(roundCoord)
    if (![x, y, z].every(Number.isFinite) || point.some(v => Math.abs(v) > POSE_MAX_COORD)) return null
    frame.push([...point, roundCoord(Math.min(1, Math.max(0, Number(visibility) || 0)))])
  }
  return frame
}

/** 요청 본문 크기(바이트) */
export function requestBytes(body) {
  return new TextEncoder().encode(JSON.stringify(body)).length
}

/** 판별 요청 본문. 사람을 한 번도 찾지 못했거나 한도를 넘으면 보내지 않는다 */
export function buildPoseRequest(exercise, frames, fps = POSE_FPS) {
  if (!exercise) throw new Error('운동을 선택해 주세요.')
  if (!frames.length || frames.every(frame => frame === null)) {
    throw new Error('영상에서 사람을 찾지 못했습니다. 몸 전체가 보이게 다시 촬영해 주세요.')
  }
  if (frames.length > POSE_MAX_FRAMES || frames.length / fps > POSE_MAX_SECONDS) {
    throw new Error(`${POSE_MAX_SECONDS}초 이하로 촬영한 영상을 선택해 주세요.`)
  }
  const body = { exercise, fps, frames }
  if (requestBytes(body) > POSE_MAX_BYTES) throw new Error('영상이 너무 깁니다. 더 짧게 촬영해 주세요.')
  return body
}

/** 처리 시간 요약 (휴대폰 속도 확인용): 프레임당 평균·p95(ms), 전체(초) */
export function summarizeSpeed(frameMs, totalMs) {
  if (!frameMs.length) return null
  const sorted = [...frameMs].sort((a, b) => a - b)
  const avg = sorted.reduce((sum, v) => sum + v, 0) / sorted.length
  const p95 = sorted[Math.min(sorted.length - 1, Math.ceil(sorted.length * 0.95) - 1)]
  return { frames: sorted.length, avgMs: Math.round(avg), p95Ms: Math.round(p95), totalSeconds: Math.round(totalMs / 100) / 10 }
}

/** 진행률(%) */
export function progressPercent(done, total) {
  return total > 0 ? Math.min(100, Math.floor((done / total) * 100)) : 0
}

export const POSE_RETAKE_MESSAGE = Object.freeze({
  POSE_NO_PERSON: '영상에서 사람을 찾지 못했습니다. 몸 전체가 화면에 들어오게 다시 촬영해 주세요.',
  POSE_TOO_FEW_FRAMES: '반복 동작을 찾지 못했습니다. 동작을 2회 이상 하는 모습을 다시 촬영해 주세요.',
  POSE_CAMERA_ANGLE: '이 촬영 방향에서는 정확하게 판정할 수 없어요.',
})

const BASIS_LABEL = { EXTERNAL: '외부 평가', CV: '교차검증' }

/** 정확도 표시 문구: "정확도 81% (외부 평가)" */
export function accuracyText(accuracy, basis) {
  if (!Number.isFinite(accuracy)) return '정확도 정보 없음'
  const label = BASIS_LABEL[basis]
  return `정확도 ${Math.round(accuracy * 100)}%${label ? ` (${label})` : ''}`
}

/** 판정 응답 → 화면 표시용. 모든 판정은 참고용이다 (D20) */
export function poseResultView(response) {
  if (!response) return null
  if (response.status === POSE_ANALYSIS_STATUS.RETAKE) {
    const base = POSE_RETAKE_MESSAGE[response.retakeCode] ?? '판정할 수 없는 영상입니다. 다시 촬영해 주세요.'
    const guide = response.retakeCode === 'POSE_CAMERA_ANGLE' ? cameraGuide(response.exercise) : null
    return {
      retake: true,
      message: guide ? `${base} ${guide.recommend}에서 다시 찍어 주세요.` : base,
      notice: response.notice,
      modelVersion: response.modelVersion,
    }
  }
  const conditions = (response.conditions ?? []).map(item => {
    const ratio = item.totalReps > 0 ? item.correctReps / item.totalReps : 0
    return {
      name: item.name,
      correctReps: item.correctReps,
      totalReps: item.totalReps,
      tone: ratio >= 0.8 ? 'good' : ratio >= 0.5 ? 'mixed' : 'check',
      accuracy: accuracyText(item.accuracy, item.accuracyBasis),
      feedback: item.feedback,
    }
  })
  return {
    retake: false,
    exercise: response.exercise,
    repCount: response.repCount,
    conditions,
    notice: response.notice,
    modelVersion: response.modelVersion,
  }
}
