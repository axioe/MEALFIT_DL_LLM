import { Archive, Package, Refrigerator, Search, Snowflake, X } from 'lucide-react'
import { STORAGE_LOCATION } from '@/lib/enums'
import { STORAGE_LABEL } from '@/lib/labels'
import { ALL_STORAGE } from '@/models/fridge'

const STORAGE_FILTERS = [
  { value: ALL_STORAGE, label: '전체', icon: Package },
  { value: STORAGE_LOCATION.FRIDGE, label: STORAGE_LABEL[STORAGE_LOCATION.FRIDGE], icon: Refrigerator },
  { value: STORAGE_LOCATION.FREEZER, label: STORAGE_LABEL[STORAGE_LOCATION.FREEZER], icon: Snowflake },
  { value: STORAGE_LOCATION.PANTRY, label: STORAGE_LABEL[STORAGE_LOCATION.PANTRY], icon: Archive },
]

/** 재료명 검색과 보관 위치 필터 */
export function FridgeFilters({ searchQuery, onSearchChange, storageFilter, onStorageChange }) {
  return (
    <section aria-label="재고 검색 및 보관 위치 필터" className="space-y-3">
      <div className="relative">
        <label htmlFor="fridge-search" className="sr-only">식재료명 검색</label>
        <Search aria-hidden="true" className="pointer-events-none absolute top-1/2 left-3.5 h-4 w-4 -translate-y-1/2 text-gray-400" />
        <input id="fridge-search" type="search" value={searchQuery} onChange={(event) => onSearchChange(event.target.value)} placeholder="식재료명 검색 (예: 두부, 양파)" className="input min-h-11 pl-10 pr-11 [&::-webkit-search-cancel-button]:appearance-none" />
        {searchQuery && (
          <button type="button" aria-label="검색어 지우기" onClick={() => onSearchChange('')} className="absolute top-0 right-0 flex h-11 w-11 cursor-pointer items-center justify-center rounded-xl text-gray-500 hover:text-gray-900 focus-visible:outline-2 focus-visible:outline-emerald-600">
            <X aria-hidden="true" className="h-4 w-4" />
          </button>
        )}
      </div>
      <div role="group" aria-label="보관 위치" className="grid grid-cols-4 gap-2 sm:flex">
        {STORAGE_FILTERS.map(({ value, label, icon: Icon }) => (
          <button key={value} type="button" aria-pressed={storageFilter === value} onClick={() => onStorageChange(value)} className={`flex min-h-11 cursor-pointer items-center justify-center gap-1.5 rounded-xl border px-2 py-2.5 text-xs font-semibold transition focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-emerald-600 sm:px-5 ${storageFilter === value ? 'border-emerald-600 bg-emerald-600 text-white' : 'border-gray-200 bg-white text-gray-600 hover:border-emerald-300 hover:bg-emerald-50'}`}>
            <Icon aria-hidden="true" className="h-4 w-4 shrink-0" />{label}
          </button>
        ))}
      </div>
    </section>
  )
}
