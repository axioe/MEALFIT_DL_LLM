import { useEffect, useRef, useState } from 'react'
import { ArrowRight, ChevronDown, LockKeyhole, Search, TriangleAlert, X } from 'lucide-react'
import { Link } from 'react-router-dom'
import { getErrorMessage } from '@/api/client'
import { MemberLink } from '@/components/common/MemberLink'
import { useGuestLogin } from '@/hooks/useGuestLogin'
import { usePublicRecipeCatalog } from '@/hooks/useRecipes'
import { useMoreSearchResults, useSearchInput, useWebSearch } from '@/hooks/useWebSearch'
import { SEARCH_TYPE } from '@/lib/enums'
import { exercisePreview, guestRecipeQuery, searchGuestEntries } from '@/models/guestSearch'
import { MAX_SEARCH_LENGTH, SEARCH_GROUPS, SEARCH_LIMIT } from '@/models/webSearch'

function SearchHit({ result }) {
  const contents = <>
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
    {result.memberOnly ? <><LockKeyhole size={15} aria-hidden="true" /><span className="sr-only">로그인 필요</span></>
      : <ArrowRight size={15} aria-hidden="true" />}
  </>
  return result.memberOnly
    ? <MemberLink to={result.to} feature={result.title} className="mf-search-hit w-full cursor-pointer text-left">{contents}</MemberLink>
    : <Link to={result.to} state={result.state} className="mf-search-hit">{contents}</Link>
}

function SearchGroup({ term, group, page, guest, localEntries = [] }) {
  const { results, total, hasMore, loading, error, loadMore } = useMoreSearchResults(term, group, page, guest)
  const [extraLocal, setExtraLocal] = useState(0)
  const localLimit = Math.max(0, SEARCH_LIMIT - results.length) + extraLocal
  const guestExercises = guest && group.type === SEARCH_TYPE.EXERCISE
  const label = guestExercises ? '운동' : group.label
  return <section className="mf-search-group" aria-label={label}>
    <h3>{label} <span>{(total + localEntries.length).toLocaleString()}건</span></h3>
    <ul>
      {results.map(result => {
        const hit = guestExercises ? exercisePreview(result.title, result.details) : result
        return <li key={result.id}><SearchHit result={hit} /></li>
      })}
      {localEntries.slice(0, localLimit).map(result => <li key={result.id}><SearchHit result={result} /></li>)}
    </ul>
    {error && <p role="alert" className="text-sm text-rose-700">{getErrorMessage(error, '추가 결과를 불러오지 못했어요.')}</p>}
    {(hasMore || localEntries.length > localLimit) && <button className="mf-search-more" type="button" disabled={loading}
      onClick={hasMore ? loadMore : () => setExtraLocal(count => count + SEARCH_LIMIT)}>
      {label} {loading ? '불러오는 중…' : error ? '다시 불러오기' : '더보기'}<ChevronDown size={14} aria-hidden="true" />
    </button>}
  </section>
}

function GuestFeatures({ entries }) {
  const [limit, setLimit] = useState(SEARCH_LIMIT)
  return <section className="mf-search-group" aria-label="서비스 기능">
    <h3>서비스 기능 <span>{entries.length.toLocaleString()}건</span></h3>
    <ul>{entries.slice(0, limit).map(result => <li key={result.id}><SearchHit result={result} /></li>)}</ul>
    {entries.length > limit && <button type="button" className="mf-search-more" onClick={() => setLimit(limit + SEARCH_LIMIT)}>
      서비스 기능 더보기<ChevronDown size={14} aria-hidden="true" />
    </button>}
  </section>
}

function SearchFeedback({ query }) {
  if (query.isPending) return <p className="mf-search-message" role="status">검색 중…</p>
  if (query.isError) return <div className="mf-search-message" role="alert">
    <p>{getErrorMessage(query.error, '검색 결과를 불러오지 못했어요.')}</p>
    <button type="button" className="mf-search-more" onClick={() => query.refetch()}>다시 시도</button>
  </div>
  return null
}

function CatalogResults() {
  const query = usePublicRecipeCatalog(1)
  if (!query.data) return <SearchFeedback query={query} />
  const { items, total } = query.data
  const group = SEARCH_GROUPS.find(item => item.type === SEARCH_TYPE.RECIPE)
  return <section className="mf-search-group" aria-label="레시피">
    <h3>레시피 <span role="status">{total.toLocaleString()}건</span></h3>
    <ul>{items.slice(0, SEARCH_LIMIT).map(item => <li key={item.id}><SearchHit result={group.result(item)} /></li>)}</ul>
    {total > SEARCH_LIMIT && <Link className="mf-search-more" to="/recipes">전체 레시피 보기 <ArrowRight size={14} aria-hidden="true" /></Link>}
    {!total && <p className="mf-search-message">등록된 공용 레시피가 없어요.</p>}
  </section>
}

function MatchedSearchResults({ term, guest, recipeTerm }) {
  const keyword = recipeTerm ?? term
  const query = useWebSearch(keyword, guest)
  const recipesOnly = guest && (recipeTerm !== null || query.data?.recipes?.total > 0)
  const { exercises, features } = guest && !query.isPending && !recipesOnly
    ? searchGuestEntries(query.data?.terms ?? [term]) : { exercises: [], features: [] }
  const groups = SEARCH_GROUPS.filter(group => (group.type === SEARCH_TYPE.EXERCISE && exercises.length > 0)
    || ((!recipesOnly || group.type === SEARCH_TYPE.RECIPE) && query.data?.[group.field]?.total > 0))
  const total = groups.reduce((sum, group) => sum + (query.data?.[group.field]?.total ?? 0), exercises.length + features.length)
  return <>
    {(query.isSuccess || total > 0) && <div className="mf-search-summary" role="status">
      <h2>검색 결과 <span>{total.toLocaleString()}건</span></h2>
      {query.data?.terms?.length > 1 && <p>{query.data.terms.join('·')}로 찾았어요.</p>}
    </div>}
    {features.length > 0 && <GuestFeatures entries={features} />}
    {groups.map(group => <SearchGroup key={group.type} term={keyword} group={group} guest={guest}
      page={query.data?.[group.field] ?? { total: 0, items: [] }} localEntries={group.type === SEARCH_TYPE.EXERCISE ? exercises : undefined} />)}
    <SearchFeedback query={query} />
    {query.isSuccess && total === 0 && <p className="mf-search-message">‘{term}’에 해당하는 결과가 없어요. 다른 검색어를 입력해 보세요.</p>}
  </>
}

function SearchResults({ term }) {
  const guest = Boolean(useGuestLogin())
  const recipeTerm = guest ? guestRecipeQuery(term) : null
  return recipeTerm === '' ? <CatalogResults /> : <MatchedSearchResults term={term} guest={guest} recipeTerm={recipeTerm} />
}

export function HeaderSearch() {
  const search = useSearchInput()
  const root = useRef(null)
  const input = useRef(null)
  const { visible, setOpen } = search

  useEffect(() => {
    if (!visible) return
    function outside(event) {
      if (!root.current?.contains(event.target) && !event.target.closest('dialog[open]')) setOpen(false)
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
    onBlur={event => { if (event.relatedTarget && !event.currentTarget.contains(event.relatedTarget) && !event.relatedTarget.closest?.('dialog[open]')) setOpen(false) }}>
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
