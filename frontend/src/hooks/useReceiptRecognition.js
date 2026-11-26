import { useEffect, useRef, useState } from 'react'
import { useQueryClient } from '@tanstack/react-query'
import { getErrorMessage } from '@/api/client'
import { queryKeys } from '@/api/queryKeys'
import { recognizeReceipt, stockInReceipt } from '@/api/receipts'
import { useSessionMutation } from '@/hooks/useSessionMutation'
import { useAuthStore } from '@/stores/authStore'
import { validateRecognitionPhoto } from '@/models/ingredientRecognition'
import { receiptRow, buildReceiptBatch } from '@/models/receipt'

// 확인한 재고 필드만 재시도용으로 읽고 이미지·원문은 저장하지 않음
function readPending(key) {
  try {
    const value = JSON.parse(sessionStorage.getItem(key))
    if (!value || !/^[0-9a-f-]{36}$/i.test(value.clientRequestId) || !Array.isArray(value.items)) return null
    buildReceiptBatch(value.items.map(item => receiptRow(item)), value.clientRequestId)
    return value
  } catch { return null }
}

// 영수증 분석과 사용자 확정 입고를 분리하고 불확실한 저장은 동일 키로만 재시도함
export function useReceiptRecognition() {
  const userId = useAuthStore(state => state.user?.id)
  const key = `mealfit-receipt-pending-${userId}`
  const [pending, setPending] = useState(() => readPending(key))
  const [rows, setRows] = useState(() => pending?.items.map(item => receiptRow(item)) ?? [])
  const [selection, setSelection] = useState(null)
  const [info, setInfo] = useState(null)
  const [error, setError] = useState('')
  const [message, setMessage] = useState('')
  const [savedLots, setSavedLots] = useState([])
  const [checking, setChecking] = useState(false)
  const [confirmed, setConfirmed] = useState(false)
  const state = useRef({ lock: false, generation: 0, controller: null, preview: null, mounted: true })
  const client = useQueryClient()
  const analyze = useSessionMutation({ mutationFn: recognizeReceipt, retry: false, gcTime: 0 })
  const save = useSessionMutation({ mutationFn: stockInReceipt, retry: false, gcTime: 0 })

  // 모달을 닫으면 사진 메모리와 진행 중 분석만 정리하고 미확정 저장 키는 보존함
  useEffect(() => {
    const current = state.current
    current.mounted = true
    return () => {
      current.mounted = false
      current.generation++
      current.controller?.abort()
      if (current.preview) URL.revokeObjectURL(current.preview)
    }
  }, [])

  // 파일 재선택으로 이전 요청이 최신 화면을 덮어쓰지 않게 함
  async function select(file) {
    const current = state.current
    if (!file || current.lock || pending) return
    current.lock = true
    const generation = ++current.generation
    setChecking(true); setError(''); setMessage(''); setSavedLots([]); setRows([]); setInfo(null); setConfirmed(false)
    if (current.preview) URL.revokeObjectURL(current.preview)
    setSelection(null)
    try {
      await validateRecognitionPhoto(file)
      if (!current.mounted || current.generation !== generation) return
      current.preview = URL.createObjectURL(file)
      setSelection({ file, preview: current.preview })
    } catch (failure) { if (current.mounted) setError(failure.message) }
    finally { current.lock = false; if (current.mounted) setChecking(false) }
  }

  // 새 분석 성공 때만 품목을 교체하고 실패 시 기존 입력을 유지함
  async function recognize() {
    const current = state.current
    if (!selection || current.lock || pending) return
    current.lock = true
    current.controller = new AbortController()
    setError(''); setMessage('')
    try {
      const result = await analyze.mutateAsync({ image: selection.file, signal: current.controller.signal })
      if (!current.mounted) return
      setRows(result.items.map(item => receiptRow(item)))
      setInfo(result); setConfirmed(false)
    } catch (failure) { if (current.mounted) setError(getErrorMessage(failure, '영수증을 읽지 못했습니다. 다시 시도해 주세요.')) }
    finally { current.lock = false }
  }

  // 저장을 시작한 품목은 응답이 확인될 때까지 잠가 키 변경에 의한 이중 등록을 막음
  async function submit() {
    const current = state.current
    if (current.lock || (!confirmed && !pending)) return
    current.lock = true; setError(''); setMessage('')
    try {
      const body = pending ?? buildReceiptBatch(rows, crypto.randomUUID())
      // 새로고침 후에도 확정한 재고 필드만 같은 요청 키로 재전송함
      sessionStorage.setItem(key, JSON.stringify(body))
      setPending(body)
      const result = await save.mutateAsync(body)
      sessionStorage.removeItem(key)
      await Promise.allSettled([
        client.invalidateQueries({ queryKey: queryKeys.inventory.all }),
        client.invalidateQueries({ queryKey: queryKeys.dashboard.all }),
      ])
      if (!current.mounted) return
      setPending(null); setRows([]); setInfo(null); setConfirmed(false)
      if (current.preview) URL.revokeObjectURL(current.preview)
      current.preview = null; setSelection(null)
      setSavedLots(result.lots)
      setMessage(`${result.lots.length}개 품목의 입고가 확인되었습니다.`)
    } catch (failure) {
      if (failure.response?.status === 400) {
        sessionStorage.removeItem(key); setPending(null)
      }
      if (current.mounted) setError(getErrorMessage(failure, failure.message || '저장 결과를 확인하지 못했습니다. 같은 요청으로 다시 확인해 주세요.'))
    } finally { current.lock = false }
  }

  // 수정한 품목만 갱신하고 자동 저장하지 않음
  function update(id, field, value) {
    if (!pending && !state.current.lock) {
      setConfirmed(false)
      setRows(current => current.map(row => row.id === id ? { ...row, [field]: value } : row))
    }
  }

  // 누락된 품목은 기존 입고 초기값을 재사용해 수동 추가함
  function add() {
    if (!pending && !state.current.lock && rows.length < 50) {
      setConfirmed(false)
      setRows(current => [...current, receiptRow()])
    }
  }

  return { rows, selection, info, error, message, savedLots, pending, confirmed, setConfirmed, select, recognize, submit, update, add,
    busy: checking || analyze.isPending || save.isPending, saving: save.isPending }
}
