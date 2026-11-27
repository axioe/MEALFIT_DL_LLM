// [자세판별] 관절 추출 결과 사진(뼈대 표시)용 순수 함수.
// 사진(썸네일)은 이 기기 화면에서만 보여 주고 서버로 보내거나 저장하지 않는다 (D16, NFR-SEC-05).

/** 썸네일 긴 변 (크게 볼 때도 흐리지 않게, 60초·900프레임이어도 기기 메모리 수십 MB 이하) */
export const POSE_THUMB_MAX_SIDE = 480
/** 이 값 미만으로 보이는 관절은 흐린 점선으로 그린다 (가려졌거나 위치가 불확실함) */
export const POSE_MIN_VISIBILITY = 0.5
/** 얼굴 점(눈·입 등 1~10번)은 화면이 복잡해져 그리지 않고 코만 그린다 */
const FACE_DETAIL = new Set([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])

/** MediaPipe Pose 연결선 (몸통·팔·손·다리·발, 얼굴 세부 제외) */
export const POSE_CONNECTIONS = Object.freeze([
  [11, 12], [11, 13], [13, 15], [15, 17], [15, 19], [15, 21], [17, 19],
  [12, 14], [14, 16], [16, 18], [16, 20], [16, 22], [18, 20],
  [11, 23], [12, 24], [23, 24], [23, 25], [24, 26], [25, 27], [26, 28],
  [27, 29], [28, 30], [29, 31], [30, 32], [27, 31], [28, 32],
])

const r3 = (v) => Math.round(v * 1000) / 1000

/** MediaPipe 이미지 좌표(0~1) 33점 → [[x, y, visibility]]. 사람이 없거나 값이 이상하면 null */
export function toImagePoints(imageLandmarks) {
  if (!Array.isArray(imageLandmarks) || imageLandmarks.length !== 33) return null
  const points = imageLandmarks.map((p) => [p?.x, p?.y, p?.visibility ?? 0])
  if (!points.every(([x, y]) => Number.isFinite(x) && Number.isFinite(y))) return null
  return points.map(([x, y, v]) => [r3(x), r3(y), r3(Math.min(1, Math.max(0, Number(v) || 0)))])
}

/** 썸네일 크기: 긴 변이 320px보다 크면 비율대로 줄인다 (정수 반올림, 최소 1) */
export function thumbSize(width, height, maxSide = POSE_THUMB_MAX_SIDE) {
  const scale = Math.min(1, maxSide / Math.max(width, height))
  return { width: Math.max(1, Math.round(width * scale)), height: Math.max(1, Math.round(height * scale)) }
}

/**
 * 뼈대 그리기 데이터 (좌표는 0~1). 모든 관절을 그리되, 잘 보이지 않는 관절과 그 선은 faint(흐린 점선)로 표시한다.
 * 관절을 빼 버리면 다리·팔이 끊겨 보여 추출이 실패한 것처럼 보이기 때문이다.
 */
export function skeletonShapes(points, minVisibility = POSE_MIN_VISIBILITY) {
  if (!points) return { lines: [], dots: [] }
  const faint = (i) => !(points[i]?.[2] >= minVisibility)
  const lines = POSE_CONNECTIONS.filter(([a, b]) => points[a] && points[b]).map(([a, b]) => ({
    key: `${a}-${b}`, x1: points[a][0], y1: points[a][1], x2: points[b][0], y2: points[b][1], faint: faint(a) || faint(b),
  }))
  const dots = points.map((p, i) => ({ key: i, x: p[0], y: p[1], faint: faint(i) })).filter((d) => !FACE_DETAIL.has(d.key))
  return { lines, dots }
}

/** 반복별 대표 장면: 반복 구간의 가운데 프레임 (프레임 범위 안으로 맞춤) */
export function repFrames(reps, total) {
  if (!total) return []
  const clamp = (i) => Math.min(total - 1, Math.max(0, i))
  return (reps ?? []).map((rep) => ({
    index: rep.index,
    frame: clamp(Math.round((rep.startFrame + rep.endFrame) / 2)),
    startFrame: clamp(rep.startFrame),
    endFrame: clamp(rep.endFrame),
    issues: rep.issues ?? [],
  }))
}

/** 판정이 없을 때(재촬영 안내 등) 보여 줄 장면: 처음·가운데·끝 (사람이 잡힌 프레임 우선) */
export function overviewFrames(points) {
  const total = points?.length ?? 0
  if (!total) return []
  const nearestFound = (target) => {
    for (let d = 0; d < total; d++) {
      for (const i of [target + d, target - d]) if (i >= 0 && i < total && points[i]) return i
    }
    return target
  }
  return [...new Set([0, Math.floor((total - 1) / 2), total - 1].map(nearestFound))]
}

/** 프레임 번호 → 영상 시각 문구 (15fps) */
export function frameTimeText(frame, fps = 15) {
  return `${(frame / fps).toFixed(1)}초`
}
