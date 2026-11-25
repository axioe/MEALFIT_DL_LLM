/** 모든 브랜드 표시가 동일한 고해상도 로고 파일을 사용합니다. */
export function BrandLogo({ className = '' }) {
  return (
    <img
      src="/mealfit-logo.png"
      alt="MealFit 로고"
      width={1254}
      height={1254}
      decoding="async"
      className={`shrink-0 object-contain ${className}`}
    />
  )
}
