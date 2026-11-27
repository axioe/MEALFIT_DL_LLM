import { useEffect, useRef } from 'react'
import { ArrowRight, ChevronDown, Search, TriangleAlert, X } from 'lucide-react'
import { Link } from 'react-router-dom'
import { getErrorMessage } from '@/api/client'
import { useMoreSearchResults, useSearchInput, useWebSearch } from '@/hooks/useWebSearch'
import { MAX_SEARCH_LENGTH, SEARCH_GROUPS } from '@/models/webSearch'

function SearchGroup({ term, group, page }) {
  const { results, total, hasMore, loading, error, loadMore } = useMoreSearchResults(term, group, page)
  return <section className="mf-search-group" aria-label={group.label}>
    <h3>{group.label} <span>{total.toLocaleString()}건</span></h3>
    <ul>
      {results.map(result => <li key={result.id}>
        <Link to={result.to} className="mf-search-hit">
          <div className="min-w-0">
            <div className="flex flex-wrap items-center gap-x-2 gap-y-1">
              <strong className="break-words">{result.title}</strong>
              {result.warning && <span className="mf-search-warning">
                <TriangleAlert size={12} aria-hidden="true" />알레르기 주의
                {result.restrictedIngredients?.length > 0 && <span className="sr-only"> · {result.restrictedIngredients.join(', ')}</span>}
              </span>}
            </div>
            <p>{result.details.filter(Boolean).join(' · ')}</p>
          </div>
          <ArrowRight size={15} aria-hidden="true" />
        </Link>
      </li>)}
    </ul>
    {error && <p role="alert" className="text-sm text-rose-700">{getErrorMessage(error, '추가 결과를 불러오지 못했어요.')}</p>}
    {hasMore && <button className="mf-search-more" type="button" onClick={loadMore} disabled={loading}>
      {group.label} {loading ? '불러오는 중…' : error ? '다시 불러오기' : '더보기'}<ChevronDown size={14} aria-hidden="true" />
    </button>}
  </section>
}

function SearchResults({ term }) {
  const query = useWebSearch(term)
  if (query.isPending) return <p className="mf-search-message" role="status">검색 중…</p>
  if (query.isError) return <div className="mf-search-message" role="alert">
    <p>{getErrorMessage(query.error, '검색 결과를 불러오지 못했어요.')}</p>
    <button type="button" className="mf-search-more" onClick={() => query.refetch()}>다시 시도</button>
  </div>
  const groups = SEARCH_GROUPS.filter(group => query.data[group.field]?.total > 0)
  const total = groups.reduce((sum, group) => sum + query.data[group.field].total, 0)
  return <>
    <div className="mf-search-summary" role="status">
      <h2>검색 결과 <span>{total.toLocaleString()}건</span></h2>
      {query.data.terms?.length > 1 && <p>{query.data.terms.join('·')}로 찾았어요.</p>}
    </div>
    {groups.length ? groups.map(group => <SearchGroup key={group.type} term={term} group={group} page={query.data[group.field]} />)
      : <p className="mf-search-message">‘{term}’에 해당하는 결과가 없어요. 다른 검색어를 입력해 보세요.</p>}
  </>
}

export function HeaderSearch() {
  const search = useSearchInput()
  const root = useRef(null)
  const input = useRef(null)
  const { visible, setOpen } = search

  useEffect(() => {
    if (!visible) return
    function outside(event) {
      if (!root.current?.contains(event.target)) setOpen(false)
    }
    document.addEventListener('pointerdown', outside)
    return () => document.removeEventListener('pointerdown', outside)
  }, [visible, setOpen])

  function onKeyDown(event) {
    if (event.nativeEvent.isComposing || event.nativeEvent.keyCode === 229) return
    if (event.key === 'Escape' && visible) {
      event.preventDefault()
      input.current.focus()
      setOpen(false)
    } else if (event.key === 'ArrowDown' && event.target === input.current) {
      const firstHit = root.current.querySelector('.mf-search-hit')
      if (firstHit) {
        event.preventDefault()
        firstHit.focus()
      }
    }
  }

  return <div className="mf-header-search" ref={root} onKeyDown={onKeyDown}
    onBlur={event => { if (event.relatedTarget && !event.currentTarget.contains(event.relatedTarget)) setOpen(false) }}>
    <form role="search" aria-label="밀핏 통합 검색" className="mf-search-form"
      onSubmit={event => { event.preventDefault(); search.submit(); input.current.focus() }}>
      <input type="search" ref={input} aria-label="통합 검색어" placeholder="레시피, 재료, 운동 검색"
        maxLength={MAX_SEARCH_LENGTH} value={search.input} autoComplete="off" enterKeyHint="search"
        onChange={event => search.change(event.target.value)} onFocus={() => setOpen(true)} onClick={() => setOpen(true)}
        onCompositionStart={() => search.setComposing(true)} onCompositionEnd={() => search.setComposing(false)} />
      {search.input && <button className="mf-search-clear" type="button" aria-label="검색어 지우기"
        onClick={() => { search.change(''); input.current.focus() }}><X size={16} aria-hidden="true" /></button>}
      <button className="mf-search-submit" type="submit" aria-label="검색"><Search size={20} strokeWidth={2.4} aria-hidden="true" /></button>
    </form>
    {visible && <div className="mf-search-popover" role="region" aria-label="통합 검색 결과">
      {search.settled ? <SearchResults key={search.term} term={search.term} /> : <p className="mf-search-message" role="status">검색 중…</p>}
    </div>}
  </div>
}
