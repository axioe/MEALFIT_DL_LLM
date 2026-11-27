import test from 'node:test'
import assert from 'node:assert/strict'
import {
  POSE_DECODE_CHUNK_FRAMES, POSE_PREVIEW_MAX_SIDE, parseDurationSeconds, parseOutputSize, decodeChunks, decodeChunkArgs,
  splitRgbaFrames, previewTranscodeArgs,
} from '../src/models/poseVideoDecode.js'
import { sampleTimes } from '../src/models/poseFrames.js'

// ffmpeg.wasm 로그 예시 (HEVC 휴대폰 영상을 rawvideo RGBA로 풀 때)
const PROBE_LOG = `Input #0, mov,mp4,m4a,3gp,3g2,mj2, from 'pose-input':
  Duration: 00:00:06.21, start: 0.000000, bitrate: 4843 kb/s
  Stream #0:0[0x1](und): Video: hevc (Main) (hvc1 / 0x31637668), yuv420p(tv, bt709), 566x942, 4700 kb/s, 29.92 fps`
const CHUNK_LOG = `${PROBE_LOG}
Stream mapping:
  Stream #0:0 -> #0:0 (hevc (native) -> rawvideo (native))
Output #0, rawvideo, to 'pose-frames.rgba':
  Stream #0:0(und): Video: rawvideo (RGBA / 0x41424752), rgba(pc, gbr/bt709/bt709, progressive), 566x942, q=2-31, 255966 kb/s, 15 fps`

test('ffmpeg 로그에서 영상 길이를 초로 읽는다', () => {
  assert.equal(parseDurationSeconds(PROBE_LOG), 6.21)
  assert.equal(parseDurationSeconds('Duration: 01:02:03.5,'), 3723.5)
  assert.equal(parseDurationSeconds('Duration: N/A'), null)
  assert.equal(parseDurationSeconds(undefined), null)
})

test('출력 크기는 Output 부분의 rawvideo 크기만 읽는다 (코덱 태그 0x41424752와 섞이지 않음)', () => {
  assert.deepEqual(parseOutputSize(CHUNK_LOG), { width: 566, height: 942 })
  assert.deepEqual(parseOutputSize(CHUNK_LOG.replace('566x942, q', '540x960 [SAR 1:1 DAR 9:16], q')), { width: 540, height: 960 })
  assert.equal(parseOutputSize(PROBE_LOG), null)
  assert.equal(parseOutputSize(''), null)
})

test('프레임 묶음은 기본 경로와 같은 시각(0초부터 1/15초)을 빠짐없이 덮는다', () => {
  for (const duration of [1, 2, 6.21, 19.9, 60, 61]) {
    const chunks = decodeChunks(duration)
    const total = sampleTimes(duration).length
    assert.equal(chunks.reduce((sum, c) => sum + c.count, 0), total)
    chunks.forEach((c, i) => {
      assert.equal(c.first, i * POSE_DECODE_CHUNK_FRAMES)
      assert.ok(c.count >= 1 && c.count <= POSE_DECODE_CHUNK_FRAMES)
      assert.equal(c.start, c.first / 15)
    })
  }
  assert.equal(decodeChunks(60).length, 30)
  assert.equal(decodeChunks(0).length, 0)
  assert.equal(decodeChunks(0.5).length, 1)
})

test('ffmpeg 인자: 묶음 시작 시각, 15fps, 긴 변 960px 축소(area), 프레임 수, RGBA rawvideo', () => {
  const args = decodeChunkArgs('in', 'out', { first: 30, count: 12, start: 2 })
  assert.deepEqual(args.slice(args.indexOf('-ss'), args.indexOf('-ss') + 4), ['-ss', '2.000000', '-i', 'in'])
  const filter = args[args.indexOf('-vf') + 1]
  assert.ok(filter.startsWith('fps=15,scale='))
  assert.ok(filter.includes("w='trunc(iw*min(1\\,960/max(iw\\,ih)))'"))
  assert.ok(filter.endsWith(':flags=area'))
  assert.equal(args[args.indexOf('-frames:v') + 1], '12')
  assert.deepEqual(args.slice(-5), ['rgba', '-f', 'rawvideo', '-y', 'out'])
  assert.ok(args.includes('-an'))
})

test('RGBA 바이트를 프레임별로 나누고 모자란 끝은 버린다', () => {
  const bytes = new Uint8Array(2 * 3 * 4 * 2 + 5)
  const frames = splitRgbaFrames(bytes, 2, 3)
  assert.equal(frames.length, 2)
  assert.equal(frames[0].length, 24)
  assert.equal(frames[1].byteOffset, 24)
  assert.deepEqual(splitRgbaFrames(new Uint8Array(0), 2, 3), [])
  assert.deepEqual(splitRgbaFrames(bytes, 0, 3), [])
})

test('미리보기 변환: 재생 가능한 H.264(yuv420p) MP4, 15fps·긴 변 480px 짝수 크기, 소리 없음', () => {
  const args = previewTranscodeArgs('in', 'out.mp4')
  const filter = args[args.indexOf('-vf') + 1]
  assert.equal(POSE_PREVIEW_MAX_SIDE, 480)
  assert.ok(filter.startsWith('fps=15,scale='))
  assert.ok(filter.includes("w='trunc(iw*min(1\\,480/max(iw\\,ih))/2)*2'"))
  assert.equal(args[args.indexOf('-c:v') + 1], 'libx264')
  assert.equal(args[args.indexOf('-pix_fmt') + 1], 'yuv420p')
  assert.equal(args[args.indexOf('-movflags') + 1], '+faststart')
  assert.ok(args.includes('-an'))
  assert.equal(args.at(-1), 'out.mp4')
})
