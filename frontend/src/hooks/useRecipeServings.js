import { useEffect, useRef, useState } from 'react'
import { useRecipe } from '@/hooks/useRecipes'
import { validRecipeServings } from '@/models/recipeInventory'

/**
 * 레시피 상세의 인분 조회 흐름 (Controller).
 * 입력한 인분으로 다시 조회하고, 조회 중·조리 중에는 중복 요청을 막으며, 실패해도 직전 결과를 유지한다.
 */
export function useRecipeServings({ recipeId, initialServings, onServingsChange, cookingBusy }) {
  const [requestedServings, setRequestedServings] = useState(initialServings)
  const [servingInput, setServingInput] = useState(initialServings == null ? '' : String(initialServings))
  const [formError, setFormError] = useState('')
  const [lastRecipe, setLastRecipe] = useState(null)
  const requestLock = useRef(false)
  const recipe = useRecipe(recipeId, requestedServings)
  const data = recipe.data ?? lastRecipe

  if (recipe.data && recipe.data !== lastRecipe) {
    setLastRecipe(recipe.data)
    setServingInput(String(recipe.data.servings))
  }
  useEffect(() => {
    if (!recipe.isFetching) requestLock.current = false
  }, [recipe.isFetching])

  function applyServings(event) {
    event.preventDefault()
    if (requestLock.current || recipe.isFetching || cookingBusy) return
    if (!validRecipeServings(servingInput)) {
      setFormError('인분은 1 이상 2,147,483,647 이하의 정수로 입력해 주세요.')
      return
    }
    requestLock.current = true
    setFormError('')
    const next = Number(servingInput)
    if (next === requestedServings) recipe.refetch({ cancelRefetch: false })
    else setRequestedServings(next)
    onServingsChange(next)
  }

  /** 인분 입력을 바꾸면 이전 입력 오류는 지운다 */
  function changeServingInput(value) {
    setServingInput(value)
    setFormError('')
  }

  function retryRecipe() {
    if (requestLock.current || recipe.isFetching || cookingBusy) return
    requestLock.current = true
    recipe.refetch({ cancelRefetch: false })
  }

  return { recipe, data, requestedServings, servingInput, changeServingInput, formError, applyServings, retryRecipe }
}
