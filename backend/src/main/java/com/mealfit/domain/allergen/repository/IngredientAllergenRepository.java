package com.mealfit.domain.allergen.repository;

import com.mealfit.domain.allergen.entity.IngredientAllergen;
import java.util.Collection;
import java.util.List;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

public interface IngredientAllergenRepository extends JpaRepository<IngredientAllergen, IngredientAllergen.Key> {

    /** 레시피 재료 이름들에 연결된 알레르기를 한 번에 조회한다. */
    @EntityGraph(attributePaths = "allergen")
    List<IngredientAllergen> findByIdIngredientNameIn(Collection<String> ingredientNames);

    /** 알레르기들에 연결된 재료를 한 번에 조회한다. */
    List<IngredientAllergen> findByIdAllergenIdIn(Collection<Long> allergenIds);
}
