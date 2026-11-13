import { Sparkles, TriangleAlert } from 'lucide-react'
import { Link, useLocation } from 'react-router-dom'
import { useImminentLotCount as useImminentCount } from '@/hooks/useInventory'
import { formatFullKoreanDate, today } from '@/lib/date'
import { findNavTitle } from './navItems'

export function Header() {
  const { pathname } = useLocation()
  const imminentCount = useImminentCount()

  return (
    <header className="sticky top-0 z-30 flex items-center justify-between gap-3 border-b border-gray-200 bg-white px-4 py-3 md:px-8">
      <div className="min-w-0">
        <h2 className="truncate text-lg font-bold tracking-tight text-gray-900 md:text-xl">{findNavTitle(pathname)}</h2>
        <p className="text-xs text-gray-500">{formatFullKoreanDate(today())}</p>
      </div>

      <div className="flex shrink-0 items-center gap-2 md:gap-3">
        {imminentCount > 0 && (
          <Link
            to="/fridge"
            aria-label={`기한 임박 재료 ${imminentCount}개, 냉장고로 이동`}
            className="flex items-center gap-1 rounded-full border border-amber-200 bg-amber-50 px-2.5 py-1 text-xs font-semibold text-amber-800 hover:bg-amber-100"
          >
            <TriangleAlert aria-hidden="true" className="h-3.5 w-3.5" />
            임박 {imminentCount}개
          </Link>
        )}
        <Link
          to="/recommend"
          className="flex items-center gap-1.5 rounded-xl bg-gradient-to-r from-emerald-600 to-teal-600 px-3.5 py-1.5 text-xs font-bold text-white transition-all hover:from-emerald-700 hover:to-teal-700"
        >
          <Sparkles className="h-3.5 w-3.5" />
          <span className="hidden sm:inline">AI 식단 추천</span>
          <span className="sm:hidden">AI 추천</span>
        </Link>
      </div>
    </header>);
}
