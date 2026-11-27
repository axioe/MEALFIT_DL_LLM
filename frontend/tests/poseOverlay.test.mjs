import test from 'node:test'
import assert from 'node:assert/strict'
import {
  POSE_CONNECTIONS, POSE_THUMB_MAX_SIDE, toImagePoints, thumbSize, skeletonShapes, repFrames, overviewFrames, frameTimeText,
} from '../src/models/poseOverlay.js'
import { poseResultView } from '../src/models/poseFrames.js'

const image = (fn) => Array.from({ length: 33 }, (_, i) => fn(i))

test('뼈대 연결선은 MediaPipe 33점 안의 번호만 쓰고 얼굴 세부 선은 뺀다', () => {
  assert.equal(POSE_CONNECTIONS.length, 26)
  assert.ok(POSE_CONNECTIONS.every(([a, b]) => a >= 11 && b >= 11))
  for (const [a, b] of POSE_CONNECTIONS) assert.ok(a >= 0 && a < 33 && b >= 0 && b < 33 && a !== b)
})

test('이미지 좌표는 소수 3자리 [x, y, visibility]로 바꾸고 잘못된 값은 null', () => {
  const points = toImagePoints(image((i) => ({ x: 0.12345, y: i / 33, visibility: 1.2 })))
  assert.equal(points.length, 33)
  assert.deepEqual(points[0], [0.123, 0, 1])
  assert.equal(toImagePoints(null), null)
  assert.equal(toImagePoints(image(() => ({ x: 0.5 }))), null)
  assert.equal(toImagePoints([]), null)
})

test('썸네일은 긴 변 480px로 줄이고 작은 영상은 그대로', () => {
  assert.equal(POSE_THUMB_MAX_SIDE, 480)
  assert.deepEqual(thumbSize(540, 960), { width: 270, height: 480 })
  assert.deepEqual(thumbSize(960, 540), { width: 480, height: 270 })
  assert.deepEqual(thumbSize(200, 100), { width: 200, height: 100 })
})

test('뼈대는 모든 관절을 잇고, 잘 안 보이는 관절과 그 선은 흐리게 표시한다 (팔다리가 끊겨 보이지 않게)', () => {
  const points = image((i) => [i / 33, 0.5, i === 13 ? 0.2 : 0.9])
  const { lines, dots } = skeletonShapes(points)
  assert.equal(lines.length, POSE_CONNECTIONS.length)
  assert.deepEqual(lines.filter((l) => l.faint).map((l) => l.key).sort(), ['11-13', '13-15'])
  assert.equal(dots.length, 23)
  assert.ok(dots.find((d) => d.key === 13).faint)
  assert.ok(dots.some((d) => d.key === 0) && !dots.some((d) => d.key === 5))
  assert.deepEqual(skeletonShapes(null), { lines: [], dots: [] })
})

test('반복별 대표 장면은 구간 가운데이고 프레임 범위를 넘지 않는다', () => {
  const scenes = repFrames([
    { index: 1, startFrame: 0, endFrame: 30, issues: ['척추의 중립'] },
    { index: 2, startFrame: 31, endFrame: 80 },
  ], 60)
  assert.deepEqual(scenes.map((s) => s.frame), [15, 56])
  assert.equal(scenes[1].endFrame, 59)
  assert.deepEqual(scenes[0].issues, ['척추의 중립'])
  assert.deepEqual(repFrames([{ index: 1, startFrame: 0, endFrame: 3 }], 0), [])
})

test('판정이 없으면 처음·가운데·끝 장면, 사람이 잡힌 가까운 프레임을 고른다', () => {
  const pts = [null, [], [], null, [], [], [], null]
  assert.deepEqual(overviewFrames(pts), [1, 4, 6])
  assert.deepEqual(overviewFrames([[]]), [0])
  assert.deepEqual(overviewFrames([]), [])
  assert.equal(frameTimeText(30), '2.0초')
})

test('판정 결과에 반복 구간과 기준과 달라 보인 조건을 담는다', () => {
  const view = poseResultView({
    exercise: '덤벨 컬', status: 'OK', repCount: 2, conditions: [], notice: 'n', modelVersion: 'v',
    reps: [
      { index: 1, startFrame: 0, endFrame: 20, conditions: [{ name: '손목의 중립', correct: false }, { name: '척추의 중립', correct: true }] },
      { index: 2, startFrame: 21, endFrame: 40, conditions: [{ name: '손목의 중립', correct: true }] },
    ],
  })
  assert.deepEqual(view.reps, [
    { index: 1, startFrame: 0, endFrame: 20, issues: ['손목의 중립'] },
    { index: 2, startFrame: 21, endFrame: 40, issues: [] },
  ])
})
