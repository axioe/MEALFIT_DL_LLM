import { useState } from 'react'
import { useInventory } from '@/hooks/useInventory'
import { ALL_STORAGE, buildFridgeView, lotSavedMessage, stockInMessage } from '@/models/fridge'

/**
 * 냉장고 화면 상태와 흐름 (Controller).
 * 재고 조회, 검색·보관 위치 필터, 수정·폐기·입고 대화상자와 이력 패널 열기/닫기를 다룬다.
 */
export function useFridgePage() {
  const inventory = useInventory()
  const [showReceiptRecognition, setShowReceiptRecognition] = useState(false)
  const [showStockIn, setShowStockIn] = useState(false)
  const [showPhotoRecognition, setShowPhotoRecognition] = useState(false)
  const [initialIngredientName, setInitialIngredientName] = useState('')
  const [lotAction, setLotAction] = useState(null)
  const [showHistory, setShowHistory] = useState(false)
  const [historyLotId, setHistoryLotId] = useState(null)
  const [successMessage, setSuccessMessage] = useState('')
  const [searchQuery, setSearchQuery] = useState('')
  const [storageFilter, setStorageFilter] = useState(ALL_STORAGE)
  const groups = inventory.data?.groups ?? []
  const view = buildFridgeView({ groups, searchQuery, storageFilter })

  function openStockIn() {
    setInitialIngredientName('')
    setSuccessMessage('')
    setShowStockIn(true)
  }

  // 사진에서 등록 폼으로 이름만 전달하고 자동 입고하지 않음.
  function openStockInFromPhoto(name) {
    setInitialIngredientName(name)
    setShowPhotoRecognition(false)
    setShowStockIn(true)
  }

  // 새 사진 인식을 열 때 이전 성공 안내를 지움.
  function openPhotoRecognition() {
    setSuccessMessage('')
    setShowPhotoRecognition(true)
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
    showReceiptRecognition, openReceiptRecognition: () => setShowReceiptRecognition(true),
    closeReceiptRecognition: () => setShowReceiptRecognition(false),
    searchQuery, setSearchQuery, storageFilter, setStorageFilter, resetFilters,
    initialIngredientName, showPhotoRecognition, openPhotoRecognition, openStockInFromPhoto,
    closePhotoRecognition: () => setShowPhotoRecognition(false),
    showStockIn, openStockIn, closeStockIn: () => setShowStockIn(false), handleStockedIn,
    lotAction, openEdit, openDispose, closeLotAction: () => setLotAction(null), handleLotSaved,
    showHistory, historyLotId, setHistoryLotId, openHistory, closeHistory: () => setShowHistory(false),
  }
}
