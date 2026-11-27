// [자세판별] 브라우저가 직접 재생하지 못하는 영상(HEVC 등)을 ffmpeg.wasm으로 기기 안에서 다룬다.
// - 미리보기: 재생 가능한 작은 H.264 영상으로 변환 (makePreviewVideo)
// - 분석: 15fps·긴 변 960px RGBA 프레임으로 풀기 (decodeVideoFrames)
// 영상은 ffmpeg.wasm의 메모리 파일로만 쓰고 끝나면 지운다. 서버로 보내지 않는다 (D16, NFR-SEC-05).
// 코어(약 32MB)는 필요할 때만 같은 서버(/ffmpeg/)에서 내려받는다 (외부 CDN 미사용). 경로는 환경 변수로 바꿀 수 있다.
import {
  decodeChunkArgs, decodeChunks, parseDurationSeconds, parseOutputSize, previewTranscodeArgs, splitRgbaFrames,
} from '@/models/poseVideoDecode'

const CORE_BASE_URL = import.meta.env.VITE_POSE_FFMPEG_URL || '/ffmpeg'

let loading = null
let queue = Promise.resolve()

/** ffmpeg.wasm을 한 번만 불러와 재사용한다. 실패하면 다음 호출에서 다시 시도한다 */
export function loadVideoDecoder() {
  if (!loading) {
    loading = (async () => {
      const { FFmpeg } = await import('@ffmpeg/ffmpeg')
      const ffmpeg = new FFmpeg()
      const base = new URL(CORE_BASE_URL, window.location.href).href.replace(/\/$/, '')
      await ffmpeg.load({ coreURL: `${base}/ffmpeg-core.js`, wasmURL: `${base}/ffmpeg-core.wasm` })
      return ffmpeg
    })().catch((error) => {
      loading = null
      throw error
    })
  }
  return loading
}

// ffmpeg.wasm은 한 번에 작업 하나만 돌린다 (미리보기 변환 중에 분석을 누르면 순서대로 처리)
function exclusive(task) {
  const run = queue.then(task, task)
  queue = run.catch(() => {})
  return run
}

async function writeInput(ffmpeg, name, url) {
  await ffmpeg.writeFile(name, new Uint8Array(await (await fetch(url)).arrayBuffer()))
}

/** 미리보기용 H.264 MP4를 만들어 object URL로 돌려준다. 다 쓰면 URL.revokeObjectURL로 해제한다 */
export function makePreviewVideo(url, { onProgress = () => {} } = {}) {
  return exclusive(async () => {
    const ffmpeg = await loadVideoDecoder()
    const input = 'preview-input'
    const output = 'preview.mp4'
    const listener = ({ progress }) => onProgress(Math.max(0, Math.min(100, Math.round(progress * 100))))
    ffmpeg.on('progress', listener)
    try {
      await writeInput(ffmpeg, input, url)
      const code = await ffmpeg.exec(previewTranscodeArgs(input, output))
      if (code !== 0) throw new Error('미리보기 영상을 만들지 못했습니다.')
      const data = await ffmpeg.readFile(output)
      return URL.createObjectURL(new Blob([data], { type: 'video/mp4' }))
    } finally {
      ffmpeg.off('progress', listener)
      await ffmpeg.deleteFile(input).catch(() => {})
      await ffmpeg.deleteFile(output).catch(() => {})
    }
  })
}

/**
 * 영상(object URL)을 15fps·긴 변 960px RGBA 프레임으로 푼다. 묶음마다 onChunk(frames, width, height, chunk)를 부른다.
 * 반환: 영상 길이(초). 읽을 수 없으면 Error.
 */
export function decodeVideoFrames(url, { alive = () => true, onDuration = () => {}, onChunk }) {
  return exclusive(async () => {
    const ffmpeg = await loadVideoDecoder()
    const input = 'pose-input'
    const output = 'pose-frames.rgba'
    let log = ''
    const onLog = ({ message }) => { log += `${message}\n` }
    ffmpeg.on('log', onLog)
    try {
      await writeInput(ffmpeg, input, url)
      // 출력 없이 열기만 하면 ffmpeg는 오류 코드로 끝나지만 로그에 영상 길이가 남는다
      await ffmpeg.exec(['-hide_banner', '-i', input])
      const duration = parseDurationSeconds(log)
      onDuration(duration)
      for (const chunk of decodeChunks(duration)) {
        if (!alive()) return duration
        log = ''
        const code = await ffmpeg.exec(decodeChunkArgs(input, output, chunk))
        const size = parseOutputSize(log)
        if (code !== 0 || !size) throw new Error('영상 프레임을 풀지 못했습니다.')
        const data = await ffmpeg.readFile(output)
        await ffmpeg.deleteFile(output).catch(() => {})
        await onChunk(splitRgbaFrames(data, size.width, size.height), size.width, size.height, chunk)
      }
      return duration
    } finally {
      ffmpeg.off('log', onLog)
      await ffmpeg.deleteFile(input).catch(() => {})
      await ffmpeg.deleteFile(output).catch(() => {})
    }
  })
}
