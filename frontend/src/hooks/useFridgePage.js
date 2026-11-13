import { useState } from 'react'
import { useInventory } from '@/hooks/useInventory'
import { ALL_STORAGE, buildFridgeView, lotSavedMessage, stockInMessage } from '@/models/fridge'

/**
 * 냉장고 화면 상태와 흐름 (Controller).
 * 재고 조회, 검색·보관 위치 필터, 수정·폐기·입고 대화상자와 이력 패널 열기/닫기를 다룬다.
 */
export function useFridgePage() {
  const inventory = useInventory()
  const [showStockIn, setShowStockIn] = useState(false)
  const [lotAction, setLotAction] = useState(null)
  const [showHistory, setShowHistory] = useState(false)
  const [historyLotId, setHistoryLotId] = useState(null)
  const [successMessage, setSuccessMessage] = useState('')
  const [searchQuery, setSearchQuery] = useState('')
  const [storageFilter, setStorageFilter] = useState(ALL_STORAGE)
  const groups = inventory.data?.groups ?? []
  const view = buildFridgeView({ groups, searchQuery, storageFilter })

  function openStockIn() {
    setSuccessMessage('')
    setShowStockIn(true)
  }

  function openEdit(lot) {
    setSuccessMessage('')
    setLotAction({ lot, mode: 'adjust' })
  }

  function openDispose(lot) {
    setSuccessMessage('')
    setLotAction({ lot, mode: 'dispose' })
  }

  function openHistory(lotId = null) {
    setHistoryLotId(lotId)
    setShowHistory(true)
  }

  function resetFilters() {
    setSearchQuery('')
    setStorageFilter(ALL_STORAGE)
  }

  function handleLotSaved(lot, disposed) {
    setLotAction(null)
    setSuccessMessage(lotSavedMessage(lot, disposed))
  }

  function handleStockedIn(lot) {
    setShowStockIn(false)
    resetFilters()
    setSuccessMessage(stockInMessage(lot))
  }

  return {
    inventory, groups, view, successMessage,
    searchQuery, setSearchQuery, storageFilter, setStorageFilter, resetFilters,
    showStockIn, openStockIn, closeStockIn: () => setShowStockIn(false), handleStockedIn,
    lotAction, openEdit, openDispose, closeLotAction: () => setLotAction(null), handleLotSaved,
    showHistory, historyLotId, setHistoryLotId, openHistory, closeHistory: () => setShowHistory(false),
  }
}
