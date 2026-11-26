import { PoseAnalysisPanel } from '@/components/workout/pose/PoseAnalysisPanel'

// [자세판별] 개발 서버 전용 확인 화면 (/dev/pose). 운동 화면 연결(MEALFIT-120) 전까지 패널을 따로 확인한다.
// 운영 빌드에는 경로가 없다 (router.jsx 의 import.meta.env.DEV).
export function PoseDevPage() {
  return (
    <div className="mx-auto max-w-2xl">
      <PoseAnalysisPanel />
    </div>
  )
}
