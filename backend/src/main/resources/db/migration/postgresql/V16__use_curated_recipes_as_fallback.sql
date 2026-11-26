-- PostgreSQL 버전 (H2 MODE=PostgreSQL 호환)
-- 검수 레시피(V15, recipe_code 있음)를 LLM이 없거나 검증에서 탈락했을 때 쓰는 대체 레시피로 쓴다 (MEALFIT-140·143).
-- 끼니는 meal_type 대신 meal_slot(BREAKFAST / LUNCH_DINNER)으로 고른다. 기존 대체 레시피 9개(recipe_code 없음)는 그대로다.
UPDATE recipes SET source = 'LOCAL_FALLBACK' WHERE recipe_code IS NOT NULL AND user_id IS NULL;
