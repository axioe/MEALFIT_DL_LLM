package com.mealfit.domain.recipe.repository;

import com.mealfit.domain.recipe.entity.IngredientStandard;
import java.util.List;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

public interface IngredientStandardRepository extends JpaRepository<IngredientStandard, Long> {

    /** 기준표 전체를 별칭과 함께 조회한다 (59종이라 한 번에 읽어 메모리에서 비교한다). */
    @EntityGraph(attributePaths = "aliases")
    List<IngredientStandard> findAllByOrderByIdAsc();
}
