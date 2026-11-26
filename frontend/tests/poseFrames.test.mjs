import test from 'node:test'
import assert from 'node:assert/strict'
import {
  POSE_MAX_FRAMES, validatePoseVideo, validatePoseDuration, sampleTimes, scaledSize, roundCoord, toPoseFrame,
  buildPoseRequest, requestBytes, summarizeSpeed, progressPercent, accuracyText, poseResultView,
} from '../src/models/poseFrames.js'

const landmarks = (fn) => Array.from({ length: 33 }, (_, i) => fn(i))
const world = landmarks(i => ({ x: 0.123456 + i / 100, y: -0.000004, z: -0.5, visibility: 0.1 }))
const image = landmarks(() => ({ x: 0.5, y: 0.5, z: 0, visibility: 0.987654 }))

test('영상 형식만 받고 빈 파일은 거부한다', () => {
  validatePoseVideo(new File(['x'], 'a.mp4', { type: 'video/mp4' }))
  validatePoseVideo(new File(['x'], 'a.mov', { type: '' }))
  assert.throws(() => validatePoseVideo(null))
  assert.throws(() => validatePoseVideo(new File([], 'a.mp4', { type: 'video/mp4' })))
  assert.throws(() => validatePoseVideo(new File(['x'], 'a.png', { type: 'image/png' })))
})

test('영상 길이는 1~60초만 허용한다', () => {
  validatePoseDuration(1)
  validatePoseDuration(60)
  for (const bad of [0, 0.5, 60.1, NaN, Infinity]) assert.throws(() => validatePoseDuration(bad))
})

test('15fps 간격으로 영상 길이 안쪽 시각만 뽑고 900개를 넘지 않는다', () => {
  const times = sampleTimes(2)
  assert.equal(times.length, 30)
  assert.equal(times[1], 1 / 15)
  assert.ok(times.at(-1) < 2)
  assert.equal(sampleTimes(1.99).length, 29)
  assert.equal(sampleTimes(60).length, POSE_MAX_FRAMES)
  assert.equal(sampleTimes(61).length, POSE_MAX_FRAMES)
})

test('학습과 같이 긴 변 960px로 줄이고(정수 버림) 작은 영상은 그대로 둔다', () => {
  assert.deepEqual(scaledSize(1920, 1080), { width: 960, height: 540 })
  assert.deepEqual(scaledSize(1080, 1920), { width: 540, height: 960 })
  assert.deepEqual(scaledSize(1000, 333), { width: 960, height: 319 })
  assert.deepEqual(scaledSize(640, 480), { width: 640, height: 480 })
  assert.deepEqual(scaledSize(960, 540), { width: 960, height: 540 })
})

test('좌표는 소수 4자리로 반올림하고 -0을 남기지 않는다', () => {
  assert.equal(roundCoord(0.123456), 0.1235)
  assert.equal(roundCoord(-0.00004), 0)
  assert.ok(Object.is(roundCoord(-0.00004), 0))
})

test('world 좌표 x·y·z에 이미지 좌표의 visibility를 붙인다', () => {
  const frame = toPoseFrame(world, image)
  assert.equal(frame.length, 33)
  assert.deepEqual(frame[0], [0.1235, 0, -0.5, 0.9877])
  assert.deepEqual(frame[32], [0.4435, 0, -0.5, 0.9877])
})

test('사람이 없거나 값이 이상한 프레임은 null', () => {
  assert.equal(toPoseFrame(undefined, undefined), null)
  assert.equal(toPoseFrame(world.slice(1), image), null)
  assert.equal(toPoseFrame(landmarks(() => ({ x: NaN, y: 0, z: 0 })), image), null)
  assert.equal(toPoseFrame(landmarks(() => ({ x: 11, y: 0, z: 0 })), image), null)
  assert.deepEqual(toPoseFrame(world, undefined)[0].at(-1), 0)
})

test('60초 15fps 요청도 3MB 안에 들어간다', () => {
  const frame = landmarks(() => [-0.1234, -0.5678, -0.9012, 0.9876])
  const body = buildPoseRequest('푸시업', Array(900).fill(frame))
  assert.ok(requestBytes(body) < 3 * 1024 * 1024)
  assert.deepEqual(Object.keys(body), ['exercise', 'fps', 'frames'])
  assert.equal(body.fps, 15)
})

test('운동 미선택·사람 미검출·한도 초과는 요청하지 않는다', () => {
  const frame = toPoseFrame(world, image)
  assert.throws(() => buildPoseRequest('', [frame]))
  assert.throws(() => buildPoseRequest('푸시업', []))
  assert.throws(() => buildPoseRequest('푸시업', [null, null]))
  assert.throws(() => buildPoseRequest('푸시업', Array(901).fill(frame)))
  assert.throws(() => buildPoseRequest('푸시업', Array(450).fill(frame), 5))
})

test('처리 시간 요약과 진행률', () => {
  assert.equal(summarizeSpeed([], 0), null)
  assert.deepEqual(summarizeSpeed([10, 20, 30, 40, 100], 2345), { frames: 5, avgMs: 40, p95Ms: 100, totalSeconds: 2.3 })
  assert.equal(progressPercent(0, 0), 0)
  assert.equal(progressPercent(45, 90), 50)
  assert.equal(progressPercent(100, 90), 100)
})

test('정확도 문구는 평가 기준을 함께 표시한다', () => {
  assert.equal(accuracyText(0.8123, 'EXTERNAL'), '정확도 81% (외부 평가)')
  assert.equal(accuracyText(0.7, 'CV'), '정확도 70% (교차검증)')
  assert.equal(accuracyText(null, null), '정확도 정보 없음')
})

test('판정 응답을 화면 표시용으로 바꾼다', () => {
  const view = poseResultView({
    exercise: '푸시업', status: 'OK', retakeCode: null, modelVersion: 'pose-20261123-41', repCount: 5, reps: [],
    conditions: [
      { name: '팔꿈치 90도', correctReps: 5, totalReps: 5, accuracy: 0.81, accuracyBasis: 'EXTERNAL', feedback: '좋아요' },
      { name: '허리 일직선', correctReps: 3, totalReps: 5, accuracy: 0.7, accuracyBasis: 'CV', feedback: '확인' },
      { name: '머리 정렬', correctReps: 1, totalReps: 5, accuracy: null, accuracyBasis: null, feedback: '주의' },
    ],
    notice: '참고용',
  })
  assert.equal(view.retake, false)
  assert.equal(view.repCount, 5)
  assert.deepEqual(view.conditions.map(c => c.tone), ['good', 'mixed', 'check'])
  assert.equal(view.conditions[2].accuracy, '정확도 정보 없음')
  assert.equal(view.notice, '참고용')
})

test('재촬영 응답은 안내 문구로 바꾼다', () => {
  const view = poseResultView({ exercise: '푸시업', status: 'RETAKE', retakeCode: 'POSE_NO_PERSON', modelVersion: 'v', repCount: 0, reps: [], conditions: [], notice: 'n' })
  assert.equal(view.retake, true)
  assert.match(view.message, /사람을 찾지 못했습니다/)
  assert.match(poseResultView({ status: 'RETAKE', retakeCode: 'X' }).message, /다시 촬영/)
  assert.equal(poseResultView(null), null)
})
