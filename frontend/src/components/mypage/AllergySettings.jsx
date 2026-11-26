import { getErrorMessage } from '@/api/client'
import { useAllergenSearch, useAllergyEditor, useAllergySettings } from '@/hooks/useAllergies'
import { ALLERGEN_MATCH_LABEL, ALLERGEN_REASON_LABEL } from '@/lib/labels'
import { ALLERGEN_LEGAL_STATUS } from '@/lib/enums'
import { bulkCodes } from '@/models/allergies'

function QueryError({ query }) {
  return <div role="alert" className="space-y-2 text-sm text-rose-700">
    <p>{getErrorMessage(query.error)}</p>
    <button type="button" className="btn-secondary" onClick={() => query.refetch()}>다시 시도</button>
  </div>
}

function AllergenSearch({ selection, toggle }) {
  const { input, setInput, term, query } = useAllergenSearch()
  return <div className="space-y-2">
    <label htmlFor="allergen-search" className="label">이름·별칭·재료로 검색</label>
    <input id="allergen-search" type="search" maxLength={50} className="input"
      placeholder="예: 계란, 참기름" value={input} onChange={(event) => setInput(event.target.value)}
      onKeyDown={(event) => { if (event.key === 'Enter') event.preventDefault() }} />
    {term && (query.isError ? <QueryError query={query} />
      : query.isPending ? <p role="status" className="text-sm text-gray-500">검색 중…</p>
      : query.data.length === 0 ? <p role="status" className="text-sm text-gray-600">검색 결과가 없습니다. 목록에 없는 재료는 직접 입력할 수 있습니다.</p>
      : <ul aria-label="알레르기 검색 결과" className="divide-y divide-gray-100 rounded-xl border px-3">
        {query.data.map((item) => <li key={item.code}>
          <label className="flex cursor-pointer items-center gap-2 py-2 text-sm">
            <input type="checkbox" checked={selection.codes.includes(item.code)} onChange={() => toggle([item.code])} />
            <span><strong>{item.name}</strong> · {item.category}<br />
              <span className="text-xs text-gray-600">{ALLERGEN_MATCH_LABEL[item.matchedBy]} · {item.matchedText}
                {item.certainty && <> · {ALLERGEN_REASON_LABEL[item.certainty]}</>}
              </span>
            </span>
          </label>
        </li>)}
      </ul>)}
  </div>
}

function BulkSelect({ codes, selected, toggle, group }) {
  if (!codes.length) return null
  const checked = codes.every((code) => selected.includes(code))
  const label = checked ? '전체 선택 해제' : '전체 선택'
  return <button type="button" className="text-xs font-semibold text-emerald-800 underline"
    aria-label={group + ' ' + label} onClick={() => toggle(codes)}>{label}</button>
}

function AllergyForm({ saved, categories, onDirtyChange, onSavingChange }) {
  const editor = useAllergyEditor(saved, categories, onDirtyChange, onSavingChange)
  const { selection, toggle } = editor
  return <form onSubmit={editor.submit} className="card max-w-2xl space-y-4">
    <h2 className="font-bold text-gray-900">내 알레르기</h2>
    <fieldset disabled={editor.isSaving} className="min-w-0 space-y-5">
      <AllergenSearch selection={selection} toggle={toggle} />
      <div className="flex items-center justify-between">
        <h3 className="text-sm font-bold">카테고리별 선택</h3>
        <BulkSelect codes={bulkCodes(editor.items)} selected={selection.codes} toggle={toggle} group="모든 카테고리" />
      </div>
      <div className="grid gap-3 sm:grid-cols-2">
        {categories.map(({ name, items }) => <fieldset key={name} className="rounded-xl border border-gray-200 px-3 pb-3">
          <legend className="px-1 text-sm font-bold">{name}</legend>
          <div className="flex flex-wrap items-center gap-x-3 gap-y-1">
            {items.map((item) => <label key={item.code} className="flex cursor-pointer items-baseline gap-1.5 py-1 text-sm">
              <input type="checkbox" checked={selection.codes.includes(item.code)} onChange={() => toggle([item.code])} />
              <span>{item.name}
                {item.legalStatus === ALLERGEN_LEGAL_STATUS.PROPOSED && <small className="block text-gray-600">개정 예고</small>}
                {item.legalCondition && <small className="block text-gray-600">{item.legalCondition}</small>}
              </span>
            </label>)}
          </div>
          {items.length > 1 && <BulkSelect codes={bulkCodes(items)} selected={selection.codes} toggle={toggle} group={name} />}
        </fieldset>)}
      </div>
      <div className="space-y-2">
        <label htmlFor="allergen-custom" className="label">목록에 없는 재료 직접 입력</label>
        <div className="flex gap-2">
          <input id="allergen-custom" className="input min-w-0" maxLength={100} placeholder="예: 키위"
            value={editor.input} onChange={(event) => editor.changeCustom(event.target.value)}
            onKeyDown={(event) => {
              if (event.key === 'Enter' && !event.nativeEvent.isComposing) {
                event.preventDefault()
                editor.addCustom()
              }
            }} />
          <button type="button" className="btn-secondary shrink-0" disabled={!editor.input.trim()} onClick={editor.addCustom}>추가</button>
        </div>
        <ul aria-label="직접 입력한 재료" className="flex flex-wrap gap-2">
          {selection.custom.map((text) => <li key={text}>
            <button type="button" aria-label={text + ' 삭제'} className="rounded-lg bg-emerald-50 px-2 py-1 text-sm text-emerald-800"
              onClick={() => editor.removeCustom(text)}>{text} ×</button>
          </li>)}
        </ul>
      </div>
      <button type="submit" className="btn-primary">{editor.isSaving ? '저장 중…' : '알레르기 저장'}</button>
    </fieldset>
    {editor.error && <p role="alert" className="text-sm text-rose-700">{editor.error}</p>}
    {editor.message && <p role="status" className="text-sm text-emerald-800">{editor.message}</p>}
  </form>
}

export function AllergySettings({ onDirtyChange, onSavingChange }) {
  const { catalog, mine } = useAllergySettings()
  if (!catalog.data && catalog.isError) return <QueryError query={catalog} />
  if (!mine.data && mine.isError) return <QueryError query={mine} />
  if (!catalog.data || !mine.data) return <p role="status">알레르기를 불러오는 중입니다.</p>
  return <AllergyForm saved={mine.data} categories={catalog.data.categories}
    onDirtyChange={onDirtyChange} onSavingChange={onSavingChange} />
}

export function AllergySummary({ allergies, onEdit }) {
  return <div className="space-y-1 text-sm">
    <p><strong>내 알레르기</strong> · {allergies.length ? allergies.join(', ') : '등록한 재료 없음'}</p>
    <button type="button" className="font-semibold text-emerald-800 underline" onClick={onEdit}>알레르기 설정</button>
  </div>
}
