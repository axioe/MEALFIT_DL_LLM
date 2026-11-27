import { useId, useState } from 'react'
import { ScanEye } from 'lucide-react'
import { frameTimeText, overviewFrames, repFrames, skeletonShapes } from '@/models/poseOverlay'

// [자세판별] 관절 추출 결과 사진: 장면 위에 MediaPipe가 찾은 관절(점)과 뼈대(선)를 그린다.
// 사진은 이 기기 화면에서만 보여 주고 서버로 보내거나 저장하지 않는다 (D16, NFR-SEC-05).
export function PoseFrameGallery({ gallery, reps }) {
  const id = useId()
  const total = gallery?.thumbs?.length ?? 0
  const scenes = reps?.length ? repFrames(reps, total) : overviewFrames(gallery?.points).map((frame) => ({ frame }))
  const [picked, setPicked] = useState(null)
  if (!total) return null
  const current = Math.min(total - 1, picked ?? scenes[0]?.frame ?? 0)

  return (
    <section aria-labelledby={`${id}-title`} className="mt-5 space-y-3">
      <div className="flex flex-wrap items-baseline justify-between gap-2">
        <h4 id={`${id}-title`} className="flex items-center gap-1.5 text-sm font-bold text-gray-900">
          <ScanEye aria-hidden="true" className="h-4 w-4 text-emerald-600" />관절 추출 결과
        </h4>
        <span className="text-xs text-gray-500">{reps?.length ? '반복마다 가운데 장면' : '처음·가운데·끝 장면'}</span>
      </div>

      <ul className="grid grid-cols-2 gap-2 sm:grid-cols-3">
        {scenes.map((scene) => {
          const flagged = scene.issues?.length > 0
          return (
            <li key={scene.frame}>
              <button type="button" onClick={() => setPicked(scene.frame)} aria-pressed={current === scene.frame}
                className={`w-full overflow-hidden rounded-xl border-2 text-left transition ${current === scene.frame ? 'ring-2 ring-emerald-500 ring-offset-1' : ''} ${flagged ? 'border-rose-300' : 'border-gray-200'}`}>
                <SkeletonImage src={gallery.thumbs[scene.frame]} points={gallery.points[scene.frame]} width={gallery.width} height={gallery.height} />
                <span className="block bg-white px-2 py-1.5 text-[11px] leading-4 text-gray-700">
                  <span className="font-semibold">{scene.index ? `${scene.index}회차` : frameTimeText(scene.frame)}</span>
                  {scene.index && <span className="text-gray-500"> · {frameTimeText(scene.frame)}</span>}
                  {flagged && <span className="block text-rose-700">기준과 달라 보임: {scene.issues.join(', ')}</span>}
                </span>
              </button>
            </li>
          )
        })}
      </ul>

      <div className="rounded-xl border border-gray-200 bg-white p-3">
        <SkeletonImage src={gallery.thumbs[current]} points={gallery.points[current]} width={gallery.width} height={gallery.height} large />
        <label htmlFor={`${id}-frame`} className="mt-3 flex items-center justify-between text-xs text-gray-600">
          <span>장면 넘겨 보기</span><span className="tabular-nums">{frameTimeText(current)} · {current + 1}/{total}</span>
        </label>
        <input id={`${id}-frame`} type="range" min={0} max={total - 1} value={current}
          onChange={(event) => setPicked(Number(event.target.value))} className="mt-1 h-11 w-full accent-emerald-600" />
      </div>
      <p className="text-[11px] leading-5 text-gray-500">
        초록 점과 선은 MediaPipe가 찾은 관절 위치예요. 흐린 점선은 가려졌거나 위치가 불확실한 관절이에요.
        사진은 이 기기 화면에서만 보여 주고, 서버로 보내거나 저장하지 않아요.
      </p>
    </section>
  )
}

// 크게 보기는 화면을 넘지 않게 높이를 360px 안으로 맞춘다 (세로 영상도 한눈에 보이게)
const LARGE_MAX_HEIGHT = 360

function SkeletonImage({ src, points, width, height, large = false }) {
  const { lines, dots } = skeletonShapes(points)
  const unit = Math.max(width, height)
  return (
    <div className="flex justify-center bg-gray-900">
      <div className="relative w-full" style={large ? { maxWidth: Math.round(LARGE_MAX_HEIGHT * width / height) } : undefined}>
        {src ? <img src={src} alt="" width={width} height={height} className="block h-auto w-full" />
          : <div className="w-full" style={{ aspectRatio: `${width} / ${height}` }} />}
        {points ? (
          <svg viewBox={`0 0 ${width} ${height}`} aria-hidden="true" className="absolute inset-0 h-full w-full">
            {lines.map((l) => <line key={l.key} x1={l.x1 * width} y1={l.y1 * height} x2={l.x2 * width} y2={l.y2 * height}
              stroke="#34d399" strokeWidth={large ? 3 : 2} strokeOpacity={l.faint ? 0.55 : 1} strokeDasharray={l.faint ? '4 4' : undefined}
              vectorEffect="non-scaling-stroke" strokeLinecap="round" />)}
            {dots.map((d) => <circle key={d.key} cx={d.x * width} cy={d.y * height} r={unit * (large ? 0.007 : 0.011)}
              fill="#ffffff" fillOpacity={d.faint ? 0.5 : 1} stroke="#059669" strokeWidth={1.5} vectorEffect="non-scaling-stroke" />)}
          </svg>
        ) : (
          <span className="absolute inset-x-0 bottom-0 bg-black/60 px-2 py-1 text-center text-[11px] text-white">사람을 찾지 못함</span>
        )}
      </div>
    </div>
  )
}
