import { useState } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { stockInMessage } from '@/models/fridge'
import { pickExpiringLots } from '@/models/dashboard'
import { ReceiptRecognitionDialog } from '@/components/fridge/ReceiptRecognitionDialog'
import { Camera, History, Plus, Refrigerator, RefreshCw, TriangleAlert } from 'lucide-react'
import { getErrorMessage } from '@/api/client'
import { InventoryHistoryPanel } from '@/components/common/InventoryHistoryPanel'
import { InventoryLotDialog } from '@/components/common/InventoryLotDialog'
import { Spinner } from '@/components/common/Spinner'
import { StockInDialog } from '@/components/common/StockInDialog'
import { PhotoRecognitionDialog } from '@/components/fridge/PhotoRecognitionDialog'
import { ArchivedLots } from '@/components/fridge/ArchivedLots'
import { FridgeFilters } from '@/components/fridge/FridgeFilters'
import { InventoryGroup } from '@/components/fridge/InventoryGroup'
import { useFridgePage } from '@/hooks/useFridgePage'

/** 스마트 냉장고 화면 (View). 상태·흐름은 hooks/useFridgePage, 계산은 models/fridge */
export function FridgePage() {
  const page = useFridgePage()
  const [addedLot, setAddedLot] = useState(null)
  const addedName = addedLot && page.successMessage === stockInMessage(addedLot) ? addedLot.ingredientName : ''
  const { data, isPending, isError, error, isFetching, refetch } = page.inventory
  const { view } = page
  const [params, setParams] = useSearchParams()
  const addRequested = params.get('add') === '1'
  const soon = data && pickExpiringLots(data).find(lot => lot.expirationStatus !== 'EXPIRED')
  function finishAdd(lot) {
    if (lot) { page.handleStockedIn(lot); setAddedLot(lot) }
    else page.closeStockIn()
    if (addRequested) {
      const next = new URLSearchParams(params)
      next.delete('add')
      setParams(next, { replace: true })
    }
  }

  return (
    <div className="space-y-6">
      <div className="mf-heading"><div><h1>내 냉장고</h1><p>보관 중인 양과 먼저 써야 할 재료를 확인하세요.</p></div>
        <div className="flex flex-wrap gap-2">
<details className="mf-more"><summary className="btn-secondary">다른 등록·관리 방법</summary><div>        <button type="button" onClick={() => page.openHistory()} className="btn-secondary min-h-11 text-xs"><History aria-hidden="true" className="h-4 w-4" />재고 변경 이력</button>
        <button type="button" onClick={() => refetch()} disabled={isFetching} className="btn-secondary min-h-11 text-xs">
          <RefreshCw aria-hidden="true" className={`h-4 w-4 ${isFetching ? 'animate-spin' : ''}`} />
          {isFetching ? '불러오는 중...' : '새로고침'}
        </button>
        <button type="button" onClick={page.openPhotoRecognition} className="btn-secondary min-h-11 text-xs">
          <Camera aria-hidden="true" className="h-4 w-4" />사진으로 등록
        </button>
        <button type="button" onClick={() => page.openReceiptRecognition()} className="btn-secondary min-h-11 text-xs">영수증으로 등록</button>
</div></details>
        <button type="button" onClick={page.openStockIn} className="btn-primary min-h-11 text-xs">
          <Plus aria-hidden="true" className="h-4 w-4" />재료 등록
        </button>
        </div>
      </div>
      {page.successMessage && <p role="status" className="rounded-xl border border-emerald-200 bg-emerald-50 p-4 text-sm text-emerald-800">{page.successMessage}{addedName && <Link className="mf-text-link ml-3" to={'/recommend?mode=quick&ingredient=' + encodeURIComponent(addedName)}>{addedName}로 요리 찾기</Link>}</p>}
      {page.lotAction && <InventoryLotDialog key={`${page.lotAction.mode}-${page.lotAction.lot.id}`} lot={page.lotAction.lot} mode={page.lotAction.mode}
        onClose={page.closeLotAction}
        onSuccess={page.handleLotSaved} />}
      {page.showHistory && <InventoryHistoryPanel lotId={page.historyLotId} lots={view.allLots} onSelectLot={page.setHistoryLotId} onClose={page.closeHistory} />}
      {page.showReceiptRecognition && <ReceiptRecognitionDialog onClose={page.closeReceiptRecognition} />}
      {page.showPhotoRecognition && <PhotoRecognitionDialog onClose={page.closePhotoRecognition} onConfirm={page.openStockInFromPhoto} />}
      {(page.showStockIn || addRequested) && <StockInDialog initialIngredientName={page.initialIngredientName} onClose={() => finishAdd()} onSuccess={finishAdd} />}

      <div className="mf-two"><section className="card mf-stack"><h2 className="mf-section-title">보관 중인 재료</h2>
      <FridgeFilters searchQuery={page.searchQuery} onSearchChange={page.setSearchQuery}
        storageFilter={page.storageFilter} onStorageChange={page.setStorageFilter} />

      {isPending ? (
        <div className="card flex min-h-60 flex-col items-center justify-center gap-4">
          <Spinner /><p className="text-sm text-gray-500">냉장고 재고를 불러오고 있습니다.</p>
        </div>
      ) : (
        <>
          {isError && (
            <div role="alert" className="flex flex-wrap items-center justify-between gap-3 rounded-2xl border border-rose-200 bg-rose-50 p-4">
              <div className="min-w-0">
                <p className="flex items-start gap-2 whitespace-pre-wrap break-all text-sm text-rose-700"><TriangleAlert aria-hidden="true" className="mt-0.5 h-4 w-4 shrink-0" />{getErrorMessage(error)}</p>
                {data && <p className="mt-2 text-xs text-rose-700">이전에 불러온 재고를 표시하고 있습니다.</p>}
              </div>
              <button type="button" onClick={() => refetch()} disabled={isFetching} className="btn-secondary min-h-11 text-xs">{isFetching ? '불러오는 중...' : '다시 시도'}</button>
            </div>
          )}
          {data && (
            <>

              <div className="flex flex-wrap items-center justify-between gap-2 text-xs text-gray-500" aria-live="polite">
                <p>검색 결과 <span className="font-semibold text-gray-700">{view.visibleGroups.length}</span>개 재료·단위 그룹</p>
                <p>소비기한 기준일 {data.asOfDate}</p>
              </div>
              {!view.hasAnyActiveLots && page.groups.length > 0 && (
                <p className="rounded-xl border border-gray-200 bg-gray-100 p-4 text-sm text-gray-600">현재 보관 중인 재고가 없습니다. ‘소진·폐기 기록 보기’에서 이전 묶음을 확인할 수 있습니다.</p>
              )}
              {view.visibleGroups.length === 0 ? (
                <div className="card flex min-h-60 flex-col items-center justify-center px-5 text-center">
                  <Refrigerator aria-hidden="true" className="mb-4 h-10 w-10 text-gray-300" />
                  <h3 className="text-base font-bold text-gray-900">{!view.hasAnyActiveLots ? '보관 중인 재고가 없습니다' : '조건에 맞는 재료가 없습니다'}</h3>
                  <p className="mt-2 text-sm leading-6 text-gray-500">{!view.hasAnyActiveLots ? '새 식재료를 등록하고 소비기한별로 관리해 보세요.' : '검색어나 보관 위치를 바꿔서 다시 확인해 주세요.'}</p>
                  {!view.hasAnyActiveLots && <button type="button" onClick={page.openStockIn} className="btn-primary mt-4 min-h-11 text-xs">식재료 추가</button>}
                  {view.hasFilters && <button type="button" onClick={page.resetFilters} className="btn-secondary mt-4 min-h-11 text-xs">검색·필터 초기화</button>}
                </div>
              ) : (
                <div className="space-y-4">
                  {view.visibleGroups.map((group) => <InventoryGroup key={JSON.stringify([group.ingredientName, group.unit])} group={group} onEdit={page.openEdit} onDispose={page.openDispose} onHistory={page.openHistory} />)}
                </div>
              )}
              <ArchivedLots groups={view.archivedGroups} count={view.archivedLotCount} onHistory={page.openHistory} />
              <p className="text-xs leading-5 text-gray-500">총수량은 활성 묶음 기준이며, 사용 가능 수량은 기한 경과 재고를 제외합니다. 기한 미등록 재고는 포함하며, 단위가 다른 재료는 따로 표시합니다.</p>
            </>
          )}
        </>
      )}
    </section><aside className="card mf-stack mf-expiry"><h2 className="mf-section-title">먼저 쓸 재료</h2>
      {isPending ? <p>소비기한 확인 중…</p> : isError ? <p>최신 소비기한을 확인해 주세요.</p> : soon ? <><span className="mf-status warn">소비기한 {soon.expiryDate}</span>
      <strong className="text-xl">{soon.ingredientName} {soon.quantity}{soon.unit}</strong><Link className="btn-primary justify-self-start" to={'/recommend?mode=quick&ingredient=' + encodeURIComponent(soon.ingredientName)}>{soon.ingredientName}로 15분 요리 찾기</Link></> : <><p>소비기한이 임박한 재료가 없어요.</p><Link to="/recommend?mode=quick" className="mf-text-link">내 재료로 15분 요리 찾기</Link></>}
    </aside></div></div>
  )
}
