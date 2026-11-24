package com.mealfit.domain.workout.repository;

import com.mealfit.domain.workout.entity.ExerciseCatalog;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface ExerciseCatalogRepository extends JpaRepository<ExerciseCatalog, Long> {

    /** 활성 운동과 부담 부위를 한 번에 읽는다 (약 60행). */
    @Query("select distinct e from ExerciseCatalog e left join fetch e.loadAreas where e.active = true")
    List<ExerciseCatalog> findAllActiveWithLoadAreas();
}
