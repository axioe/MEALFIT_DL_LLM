import { useEffect, useRef, useState } from 'react'
import { useMutation } from '@tanstack/react-query'
import { getErrorMessage } from '@/api/client'
import { inventoryApi } from '@/api/inventory'
import { validateRecognitionPhoto } from '@/models/ingredientRecognition'
import { ingredientClassLabel } from '@/lib/ingredientLabels'

// 사진 수명·중복 요청·인식 오류를 관리하고 재고 저장은 수행하지 않음.
export function useIngredientRecognition() {
  const [selection, setSelection] = useState(null)
  const [checking, setChecking] = useState(false)
  const [error, setError] = useState('')
  const [ingredientName, setIngredientName] = useState('')
  const [selectedClass, setSelectedClass] = useState('')
  const current = useRef({ mounted: true, generation: 0, selection: null, controller: null, submitting: false })
  const mutation = useMutation({ mutationFn: inventoryApi.recognizePhoto, retry: false, gcTime: 0 })

  // 화면을 닫으면 요청을 취소하고 사진 메모리 URL을 해제함.
  useEffect(() => {
    const state = current.current
    state.mounted = true
    return () => {
      state.mounted = false
      state.generation++
      state.controller?.abort()
      if (state.selection) URL.revokeObjectURL(state.selection.preview)
    }
  }, [])

  // 빠른 파일 재선택 시 먼저 끝난 이전 검증 결과가 최신 사진을 덮지 않게 함.
  async function selectPhoto(file) {
    const state = current.current
    if (!file || state.submitting) return
    const generation = ++state.generation
    if (state.selection) URL.revokeObjectURL(state.selection.preview)
    state.selection = null
    setSelection(null)
    setError('')
    setIngredientName('')
    setSelectedClass('')
    mutation.reset()
    setChecking(true)
    try {
      await validateRecognitionPhoto(file)
      if (!state.mounted || generation !== state.generation) return
      const next = { file, preview: URL.createObjectURL(file) }
      state.selection = next
      setSelection(next)
    } catch (failure) {
      if (state.mounted && generation === state.generation) setError(failure.message || '사진을 읽지 못했습니다. 다시 선택해 주세요.')
    } finally {
      if (state.mounted && generation === state.generation) setChecking(false)
    }
  }

  // 연속 클릭은 차단하고 명시적 재시도에서만 같은 사진을 다시 전송함.
  async function recognize() {
    const state = current.current
    if (!state.selection || state.submitting || checking) return
    state.submitting = true
    state.controller = new AbortController()
    setError('')
    setIngredientName('')
    setSelectedClass('')
    try {
      await mutation.mutateAsync({ image: state.selection.file, signal: state.controller.signal })
    } catch (failure) {
      if (state.mounted && !state.controller.signal.aborted) {
        setError(getErrorMessage(failure, failure.message || '사진을 인식하지 못했습니다. 다시 시도해 주세요.'))
      }
    } finally {
      state.submitting = false
    }
  }

  // 후보를 선택하면 사용자가 수정할 수 있는 이름 입력값에만 반영함.
  function selectCandidate(candidate) {
    setSelectedClass(candidate.className)
    setIngredientName(ingredientClassLabel(candidate.className))
  }

  // OCR 후보는 출처를 구분하고 확인 가능한 한국어 이름만 전달함.
  function selectOcrCandidate(candidate) {
    setSelectedClass(`ocr:${candidate.ingredientName}`)
    setIngredientName(candidate.ingredientName)
  }

  // 브라우저가 열지 못하는 파일은 전송 대상으로 유지하지 않음.
  function rejectPreview() {
    const state = current.current
    state.controller?.abort()
    state.generation++
    if (state.selection) URL.revokeObjectURL(state.selection.preview)
    state.selection = null
    setSelection(null)
    mutation.reset()
    setError('사진을 열 수 없습니다. 다른 JPEG·PNG 사진을 선택해 주세요.')
  }

  return {
    selection, checking, error, ingredientName, setIngredientName, selectedClass,
    selectPhoto, selectCandidate, selectOcrCandidate, recognize, rejectPreview,
    ocr: mutation.data?.ocr,
    candidates: mutation.data?.candidates ?? [], modelVersion: mutation.data?.modelVersion,
    busy: checking || mutation.isPending,
  }
}
