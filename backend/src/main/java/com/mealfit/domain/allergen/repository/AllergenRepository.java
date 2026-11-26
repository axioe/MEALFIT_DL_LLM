package com.mealfit.domain.allergen.repository;

import com.mealfit.domain.allergen.entity.Allergen;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AllergenRepository extends JpaRepository<Allergen, Long> {

    /** 화면 표시 순서(카테고리 → 항목)대로 별칭과 함께 조회한다. */
    @EntityGraph(attributePaths = "aliases")
    List<Allergen> findAllByOrderByDisplayOrderAsc();

    Optional<Allergen> findByCode(String code);
}
