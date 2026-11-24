import { useEffect, useId, useRef } from 'react'
import { Camera, X } from 'lucide-react'
import { Spinner } from '@/components/common/Spinner'
import { useIngredientRecognition } from '@/hooks/useIngredientRecognition'
import { ingredientClassLabel } from '@/lib/ingredientLabels'
import { confirmedRecognitionName, recognitionConfidence, ocrStatusMessage } from '@/models/ingredientRecognition'

// 사진 후보를 확인하고 기존 등록 폼으로 이동하는 화면을 표시함.
export function PhotoRecognitionDialog({ onClose, onConfirm }) {
  const ref = useRef(null)
  const id = useId()
  const photo = useIngredientRecognition()
  const confirmedName = confirmedRecognitionName(photo.ingredientName)

  // 기본 대화상자로 키보드 포커스를 관리함.
  useEffect(() => {
    const dialog = ref.current
    dialog.showModal()
    return () => dialog.close()
  }, [])

  return (
    <dialog ref={ref} aria-labelledby={`${id}-title`} aria-describedby={`${id}-description`}
      onCancel={event => { event.preventDefault(); onClose() }}
      className="fixed inset-0 m-auto max-h-[90dvh] w-[calc(100%-2rem)] max-w-lg overflow-y-auto overscroll-contain rounded-2xl border border-gray-200 bg-white p-5 text-gray-900 shadow-xl backdrop:bg-black/40 md:p-6">
      <div className="mb-4 flex items-center justify-between gap-2 border-b border-gray-100 pb-3">
        <h3 id={`${id}-title`} className="flex items-center gap-2 text-base font-bold"><Camera aria-hidden="true" className="h-5 w-5 text-emerald-600" />사진으로 등록</h3>
        <button type="button" onClick={onClose} aria-label="사진 인식 닫기" className="flex h-11 w-11 shrink-0 cursor-pointer items-center justify-center rounded-xl text-gray-500 hover:bg-gray-100"><X aria-hidden="true" className="h-5 w-5" /></button>
      </div>
      <p id={`${id}-description`} className="mb-4 text-sm leading-6 text-gray-600">식재료나 상품 라벨이 잘 보이는 사진을 선택해 주세요. 사진 예측은 한 종류를 분류하며, 라벨에 적힌 여러 재료는 별도 후보로 표시합니다. 인식 결과만으로 재고가 등록되지 않습니다.</p>
      <label htmlFor={`${id}-photo`} className="label">식재료 사진</label>
      <input id={`${id}-photo`} type="file" accept="image/jpeg,image/png" disabled={photo.busy}
        onChange={event => { const file = event.target.files?.[0]; event.target.value = ''; void photo.selectPhoto(file) }}
        className="input min-h-11 w-full min-w-0 max-w-full text-sm file:mr-3 file:rounded-lg file:border-0 file:bg-emerald-50 file:px-3 file:py-2 file:text-emerald-800"
        aria-describedby={`${id}-limits`} />
      <p id={`${id}-limits`} className="mt-2 text-xs leading-5 text-gray-500">JPEG·PNG 한 장, 10MiB 이하. 사진은 인식에만 사용하며 재고에 저장하지 않습니다.</p>
      {photo.selection && <img src={photo.selection.preview} alt="선택한 식재료 사진 미리보기" onError={photo.rejectPreview}
        className="mt-4 max-h-56 w-full rounded-xl bg-gray-50 object-contain" />}
      <div className="mt-4" aria-live="polite" aria-busy={photo.busy}>
        <button type="button" disabled={!photo.selection || photo.busy} onClick={photo.recognize} className="btn-primary min-h-11 w-full">
          {photo.busy && <Spinner />}{photo.busy ? '사진 확인·인식 중...' : photo.candidates.length ? '다시 인식하기' : photo.error ? '다시 시도' : '식재료 인식하기'}
        </button>
      </div>
      {photo.error && <p role="alert" className="mt-4 whitespace-pre-wrap break-words rounded-xl bg-rose-50 p-3 text-sm text-rose-700">{photo.error}</p>}
      {photo.candidates.length > 0 && !photo.busy && <div className="mt-5 space-y-4">
        {photo.ocr && <fieldset className="min-w-0 space-y-2 rounded-xl bg-emerald-50 p-3">
          <legend className="text-sm font-bold text-emerald-900">라벨에서 찾은 식재료</legend>
          <p role="status" className="text-xs leading-5 text-gray-600">{ocrStatusMessage(photo.ocr.status)}</p>
          {photo.ocr.candidates.map(candidate => <label key={candidate.ingredientName}
            className={`flex min-h-14 cursor-pointer items-center gap-3 rounded-xl border bg-white p-3 ${photo.selectedClass === `ocr:${candidate.ingredientName}` ? 'border-emerald-500 ring-1 ring-emerald-500' : 'border-emerald-100'}`}>
            <input type="radio" name={`${id}-candidate`} checked={photo.selectedClass === `ocr:${candidate.ingredientName}`}
              onChange={() => photo.selectOcrCandidate(candidate)} className="shrink-0 accent-emerald-600" />
            <span className="min-w-0 flex-1 break-words text-sm">
              <span className="font-semibold">{candidate.ingredientName}</span>
              <span className="mt-1 block text-xs leading-5 text-gray-500">출처: 상품 라벨 OCR · 문자 신뢰도 {recognitionConfidence(candidate.textConfidence)}</span>
            </span>
          </label>)}
          {photo.ocr.status === 'SUCCESS' && <p className="text-xs leading-5 text-gray-600">문자 신뢰도는 식재료 정답 확률이 아닙니다. 아래 사진 예측 확률과 합산하지 않습니다.</p>}
        </fieldset>}
        <fieldset className="min-w-0 space-y-2">
          <legend className="mb-2 text-sm font-bold">사진에서 예측한 식재료 Top-3</legend>
          {photo.candidates.map((candidate, index) => <label key={candidate.className}
            className={`flex min-h-14 cursor-pointer items-center gap-3 rounded-xl border p-3 ${photo.selectedClass === candidate.className ? 'border-emerald-500 bg-emerald-50' : 'border-gray-200'}`}>
            <input type="radio" name={`${id}-candidate`} checked={photo.selectedClass === candidate.className} onChange={() => photo.selectCandidate(candidate)} className="shrink-0 accent-emerald-600" />
            <span className="min-w-0 flex-1 break-words text-sm"><span className="mr-2 text-gray-500">{index + 1}.</span>{ingredientClassLabel(candidate.className)}</span>
            <span className="shrink-0 text-sm font-semibold text-emerald-800">{recognitionConfidence(candidate.confidence)}</span>
          </label>)}
        </fieldset>
        <p className="rounded-xl bg-amber-50 p-3 text-xs leading-5 text-amber-900">사진 예측의 한국어는 화면 표시명이며 DB 식재료 ID와 연결된 상태는 아닙니다(UNMAPPED). 라벨 후보도 DB 식재료 ID를 부여하지 않습니다. 인식 실패가 아니며, 실제 등록할 재료명을 확인·수정해 주세요. 표시 확률은 정확성을 보장하지 않습니다.</p>
        <div>
          <label htmlFor={`${id}-name`} className="label">등록할 식재료명</label>
          <input id={`${id}-name`} value={photo.ingredientName} maxLength={100} onChange={event => photo.setIngredientName(event.target.value)}
            placeholder="후보를 선택하거나 직접 입력해 주세요" className="input min-h-11 w-full" autoComplete="off" />
          <p className="mt-2 text-xs leading-5 text-gray-500">다음 화면에서 수량·단위·보관 위치·기한을 확인하고 ‘등록하기’를 눌러야 저장됩니다.</p>
        </div>
        <button type="button" disabled={!confirmedName} onClick={() => { if (confirmedName) onConfirm(confirmedName) }} className="btn-primary min-h-11 w-full">이 이름으로 등록 폼 열기</button>
        <p className="break-all text-xs text-gray-400">모델: {photo.modelVersion}</p>
      </div>}
      <button type="button" onClick={onClose} className="btn-secondary mt-4 min-h-11 w-full">취소</button>
    </dialog>
  )
}
