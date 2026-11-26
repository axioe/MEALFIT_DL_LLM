import test from 'node:test'
import assert from 'node:assert/strict'
import { POSE_CAMERA_SECTORS, POSE_CAMERA_TIPS, cameraGuide } from '../src/lib/poseCameraGuide.js'
import { poseResultView } from '../src/models/poseFrames.js'

const SECTORS = new Set(['FRONT', 'FRONT_DIAGONAL', 'SIDE', 'BACK_DIAGONAL', 'BACK'])

test('41종 운동 모두 촬영 방향 구역이 있다', () => {
  assert.equal(Object.keys(POSE_CAMERA_SECTORS).length, 41)
  for (const [exercise, sectors] of Object.entries(POSE_CAMERA_SECTORS)) {
    assert.ok(sectors.length > 0, exercise)
    assert.ok(sectors.every(s => SECTORS.has(s)), exercise)
    assert.ok(cameraGuide(exercise).text.endsWith('.'), exercise)
  }
  assert.ok(POSE_CAMERA_TIPS.length >= 3)
})

test('서서 하는 운동은 정면·앞쪽 대각선을 권하고 바로 옆은 피하게 한다', () => {
  const guide = cameraGuide('풀업')
  assert.equal(guide.recommend, '정면이나 앞쪽 대각선(약 45°)')
  assert.deepEqual(guide.avoid, ['바로 옆', '바로 뒤'])
  assert.equal(guide.text, '정면이나 앞쪽 대각선(약 45°)에서 찍어 주세요. 바로 옆이나 바로 뒤에서 찍으면 정확하게 판정할 수 없어요.')
  assert.deepEqual(cameraGuide('덤벨 컬').avoid, ['바로 옆'])
})

test('바닥 운동은 옆·대각선을 권하고 머리·발 쪽 정면은 피하게 한다', () => {
  const guide = cameraGuide('푸시업')
  assert.equal(guide.recommend, '옆이나 비스듬한 대각선')
  assert.deepEqual(guide.avoid, ['머리 쪽이나 발 쪽 정면'])
})

test('정보가 없는 운동은 안내하지 않는다', () => {
  assert.equal(cameraGuide(''), null)
  assert.equal(cameraGuide('없는 운동'), null)
})

test('촬영 방향 재촬영 응답은 운동별 촬영 안내를 붙인다', () => {
  const view = poseResultView({ exercise: '풀업', status: 'RETAKE', retakeCode: 'POSE_CAMERA_ANGLE', modelVersion: 'v', repCount: 0, reps: [], conditions: [], notice: 'n' })
  assert.equal(view.retake, true)
  assert.equal(view.message, '이 촬영 방향에서는 정확하게 판정할 수 없어요. 정면이나 앞쪽 대각선(약 45°)에서 다시 찍어 주세요.')
  const unknown = poseResultView({ exercise: '없는 운동', status: 'RETAKE', retakeCode: 'POSE_CAMERA_ANGLE' })
  assert.equal(unknown.message, '이 촬영 방향에서는 정확하게 판정할 수 없어요.')
})
