export function allergySelection({ selected, custom }) {
  return { codes: selected.map((item) => item.code), custom: [...custom] }
}

export function bulkCodes(items) {
  return items.filter((item) => item.selectAll).map((item) => item.code)
}

// 묶음 밖의 수동 선택은 전체 선택과 전체 해제 양쪽에서 보존한다.
export function toggleAllergyCodes(selection, codes) {
  const allSelected = codes.every((code) => selection.codes.includes(code))
  return {
    ...selection,
    codes: allSelected ? selection.codes.filter((code) => !codes.includes(code))
      : [...new Set([...selection.codes, ...codes])],
  }
}

function normalize(text) {
  return text.replace(/\s+/g, '').toLowerCase()
}

export function addCustomAllergy(selection, input, items) {
  const text = input.trim()
  if (!text) return selection
  const key = normalize(text)
  const known = items.find((item) => [item.name, ...item.aliases].some((name) => normalize(name) === key))
  if (known) return { ...selection, codes: [...new Set([...selection.codes, known.code])] }
  return { ...selection, custom: [...new Set([...selection.custom, text])] }
}
