// 체중 그래프 좌표 계산 (SVG viewBox 600×220)
export const CHART = { width: 600, height: 220, paddingX: 40, paddingY: 30 }

/** 기록을 날짜순으로 정렬하고 점 좌표·목표선 위치를 계산한다 */
export function buildWeightChart(records, targetWeight) {
  const { width, height, paddingX, paddingY } = CHART
  const sortedRecords = [...records].sort((a, b) => a.date.localeCompare(b.date))
  const allWeights = [...sortedRecords.map((r) => r.weight), targetWeight]
  const minW = Math.max(30, Math.min(...allWeights) - 2)
  const maxW = Math.max(...allWeights) + 2
  const getX = (idx, total) => (total <= 1 ? width / 2 : paddingX + (idx / (total - 1)) * (width - paddingX * 2))
  const getY = (val) => {
    const range = maxW - minW || 1
    return height - paddingY - ((val - minW) / range) * (height - paddingY * 2)
  }
  return {
    sortedRecords,
    getX,
    getY,
    polylinePoints: sortedRecords.map((r, i) => `${getX(i, sortedRecords.length)},${getY(r.weight)}`).join(' '),
    targetLineY: getY(targetWeight),
  }
}
