import { POSE_FPS, POSE_MAX_SIDE, sampleTimes } from './poseFrames.js'

// [자세판별] 브라우저가 직접 재생하지 못하는 영상(HEVC 등)을 ffmpeg.wasm으로 기기 안에서 풀 때 쓰는 순수 함수.
// 영상은 기기 메모리 안에서만 다루고 서버로 보내지 않는다 (D16, NFR-SEC-05). 좌표 추출 조건은 기본 경로와 같다:
// 0초부터 1/15초 간격, 긴 변 960px(정수 버림), 최대 900프레임.

/** 한 번에 풀어 메모리에 올리는 프레임 수 (960×540 RGBA 기준 약 60MB) */
export const POSE_DECODE_CHUNK_FRAMES = 30
/** 미리보기용 변환 영상의 긴 변 (빠르게 만들려고 분석보다 작게) */
export const POSE_PREVIEW_MAX_SIDE = 480

/** ffmpeg 로그에서 영상 길이(초). 읽을 수 없으면 null */
export function parseDurationSeconds(log) {
  const match = /Duration:\s*(\d+):(\d{2}):(\d{2}(?:\.\d+)?)/.exec(String(log ?? ''))
  if (!match) return null
  return Number(match[1]) * 3600 + Number(match[2]) * 60 + Number(match[3])
}

/** ffmpeg 로그의 출력(Output) 부분에서 rawvideo 크기 → { width, height }. 읽을 수 없으면 null */
export function parseOutputSize(log) {
  const text = String(log ?? '')
  const output = text.slice(text.lastIndexOf('Output #0'))
  if (!output.startsWith('Output #0')) return null
  // "rgba(pc, ...), 540x960, q=..." 처럼 쉼표 뒤에 오는 크기만 본다 (코덱 태그 0x41424752 와 구분)
  const match = /Video: rawvideo[^\n]*?,\s(\d{1,5})x(\d{1,5})[\s,[]/.exec(output)
  if (!match) return null
  return { width: Number(match[1]), height: Number(match[2]) }
}

/** 뽑을 프레임을 묶음으로 나눈다 → [{ first, count, start }] (start는 초) */
export function decodeChunks(duration, chunkFrames = POSE_DECODE_CHUNK_FRAMES, fps = POSE_FPS) {
  const total = sampleTimes(duration, fps).length
  const chunks = []
  for (let first = 0; first < total; first += chunkFrames) {
    chunks.push({ first, count: Math.min(chunkFrames, total - first), start: first / fps })
  }
  return chunks
}

/** 한 묶음을 풀 ffmpeg 인자. 회전 정보는 ffmpeg가 자동으로 반영하고(브라우저 재생과 같음), 긴 변 960px로 줄인다 */
export function decodeChunkArgs(input, output, chunk, fps = POSE_FPS, maxSide = POSE_MAX_SIDE) {
  const ratio = `min(1\\,${maxSide}/max(iw\\,ih))`
  const scale = `scale=w='trunc(iw*${ratio})':h='trunc(ih*${ratio})':flags=area`
  return [
    '-hide_banner', '-nostdin',
    '-ss', chunk.start.toFixed(6), '-i', input,
    '-an', '-sn', '-vf', `fps=${fps},${scale}`,
    '-frames:v', String(chunk.count),
    '-pix_fmt', 'rgba', '-f', 'rawvideo', '-y', output,
  ]
}

/** 풀어 낸 RGBA 바이트를 프레임별 조각으로 나눈다. 마지막에 모자란 프레임은 버린다 */
export function splitRgbaFrames(bytes, width, height) {
  const size = width * height * 4
  if (!size || !bytes?.length) return []
  const frames = []
  for (let offset = 0; offset + size <= bytes.length; offset += size) {
    frames.push(bytes.subarray(offset, offset + size))
  }
  return frames
}

/**
 * 브라우저가 재생하지 못하는 영상의 미리보기용 H.264 MP4 변환 인자.
 * 빠르게 만들려고 15fps·긴 변 480px·소리 없음으로 줄인다 (분석은 이 영상이 아니라 원본을 쓴다).
 * H.264(yuv420p)는 가로·세로가 짝수여야 해서 짝수로 내린다.
 */
export function previewTranscodeArgs(input, output, fps = POSE_FPS, maxSide = POSE_PREVIEW_MAX_SIDE) {
  const ratio = `min(1\\,${maxSide}/max(iw\\,ih))`
  const scale = `scale=w='trunc(iw*${ratio}/2)*2':h='trunc(ih*${ratio}/2)*2'`
  return [
    '-hide_banner', '-nostdin', '-i', input,
    '-an', '-sn', '-vf', `fps=${fps},${scale}`,
    '-c:v', 'libx264', '-preset', 'ultrafast', '-crf', '28', '-pix_fmt', 'yuv420p',
    '-movflags', '+faststart', '-t', '60', '-y', output,
  ]
}
