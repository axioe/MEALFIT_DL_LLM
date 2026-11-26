package com.mealfit.domain.recipe.repository;

import com.mealfit.domain.mealplan.entity.MealType;
import com.mealfit.domain.recipe.entity.Recipe;
import com.mealfit.domain.recipe.entity.RecipeMealSlot;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface RecipeRepository extends JpaRepository<Recipe, Long> {

    /** 공용 레시피(userId null)이거나 본인 레시피일 때만 조회된다. */
    @Query("select r from Recipe r where r.id = :id and (r.userId is null or r.userId = :userId)")
    Optional<Recipe> findAccessibleById(@Param("id") Long id, @Param("userId") Long userId);

    /**
     * 로컬 대체 후보: 공용 LOCAL_FALLBACK 레시피 중 해당 끼니에 쓸 수 있는 것.
     * 기존 레시피는 meal_type(없으면 모든 끼니), 검수 레시피(V15)는 meal_slot(아침 / 점심·저녁)으로 고른다.
     */
    @Query("""
            select r from Recipe r
            where r.userId is null
              and r.source = com.mealfit.domain.recipe.entity.RecipeSource.LOCAL_FALLBACK
              and ((r.mealSlot is null and (r.mealType is null or r.mealType = :mealType))
                   or r.mealSlot = :mealSlot)
            order by r.id
            """)
    List<Recipe> findFallbackCandidates(@Param("mealType") MealType mealType,
                                        @Param("mealSlot") RecipeMealSlot mealSlot);

    /** 식단 끼니에 맞는 검수 레시피 구분(아침 / 점심·저녁)으로 대체 후보를 찾는다. */
    default List<Recipe> findFallbackCandidates(MealType mealType) {
        return findFallbackCandidates(mealType,
                mealType == MealType.BREAKFAST ? RecipeMealSlot.BREAKFAST : RecipeMealSlot.LUNCH_DINNER);
    }
}
