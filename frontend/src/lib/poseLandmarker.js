// [자세판별] 브라우저 MediaPipe Pose Landmarker(heavy) 준비. 학습 데이터 추출과 같은 설정이다:
// IMAGE 모드, 사람 1명, Python mediapipe 1.2.2 기본값과 같은 신뢰도 기준. 영상은 서버로 보내지 않는다.
// 연산 장치: 기본 GPU(빠름), VITE_POSE_DELEGATE=CPU 로 학습과 같은 CPU 계산을 쓸 수 있다. GPU를 못 쓰는 기기는 CPU로 바꾼다.
// 파일 위치는 환경 변수로 바꿀 수 있다. 기본값은 같은 서버 경로 (외부 CDN 미사용).
const WASM_BASE_URL = import.meta.env.VITE_POSE_WASM_URL || '/mediapipe/wasm'
const MODEL_URL = import.meta.env.VITE_POSE_MODEL_URL || '/models/pose/pose_landmarker_heavy.task'
export const POSE_DELEGATE = String(import.meta.env.VITE_POSE_DELEGATE || 'GPU').toUpperCase() === 'CPU' ? 'CPU' : 'GPU'

const loading = new Map()

/** 연산 장치별로 한 번만 불러와 재사용한다 → { landmarker, delegate }. 실패하면 다음 호출에서 다시 시도한다 */
export function loadPoseLandmarker(delegate = POSE_DELEGATE) {
  if (!loading.has(delegate)) {
    loading.set(delegate, createLandmarker(delegate).catch((error) => {
      loading.delete(delegate)
      throw error
    }))
  }
  return loading.get(delegate)
}

async function createLandmarker(delegate) {
  // 운동 화면을 열 때만 내려받도록 나눠서 불러온다
  const { FilesetResolver, PoseLandmarker } = await import('@mediapipe/tasks-vision')
  const fileset = await FilesetResolver.forVisionTasks(WASM_BASE_URL)
  const create = (device) => PoseLandmarker.createFromOptions(fileset, {
    baseOptions: { modelAssetPath: MODEL_URL, delegate: device },
    runningMode: 'IMAGE',
    numPoses: 1,
  })
  if (delegate === 'CPU') return { landmarker: await create('CPU'), delegate: 'CPU' }
  try {
    return { landmarker: await create('GPU'), delegate: 'GPU' }
  } catch {
    return { landmarker: await create('CPU'), delegate: 'CPU' }
  }
}
