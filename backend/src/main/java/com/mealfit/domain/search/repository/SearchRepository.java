package com.mealfit.domain.search.repository;

import com.mealfit.domain.inventory.entity.InventoryLot;
import com.mealfit.domain.inventory.entity.LotStatus;
import com.mealfit.domain.mealplan.entity.MealPlan;
import com.mealfit.domain.recipe.entity.Recipe;
import com.mealfit.domain.shopping.entity.ShoppingItem;
import com.mealfit.domain.workout.entity.ExerciseCatalog;
import com.mealfit.domain.workout.entity.WorkoutSession;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

/**
 * 통합 검색 조회. 낱말마다 "공백을 뺀 소문자 값에 포함되는지"를 OR로 묶는다 (H2·PostgreSQL 공통 JPQL).
 * 패턴은 서비스가 % · _ · \ 를 이스케이프해서 넘긴다.
 */
@Repository
@RequiredArgsConstructor
public class SearchRepository {

    private final EntityManager em;

    /** 조건: (field1 또는 field2 …)가 낱말 중 하나라도 포함 */
    private static String anyMatch(Collection<String> fields, int termCount) {
        List<String> parts = new ArrayList<>();
        for (String field : fields) {
            for (int i = 0; i < termCount; i++) {
                parts.add("replace(lower(" + field + "), ' ', '') like :p" + i + " escape '\\'");
            }
        }
        return "(" + String.join(" or ", parts) + ")";
    }

    private static void bind(jakarta.persistence.Query query, List<String> patterns) {
        for (int i = 0; i < patterns.size(); i++) {
            query.setParameter("p" + i, patterns.get(i));
        }
    }

    /** 요리명 또는 재료명이 걸리는 공용·본인 레시피 (id → 요리명 일치 여부), 요리명 일치 먼저 */
    public Map<Long, Boolean> recipeIds(Long userId, List<String> patterns) {
        String access = "(r.userId is null or r.userId = :userId)";
        TypedQuery<Long> byName = em.createQuery(
                "select r.id from Recipe r where " + access + " and " + anyMatch(List.of("r.name"), patterns.size())
                        + " order by r.id", Long.class);
        TypedQuery<Long> byIngredient = em.createQuery(
                "select distinct i.recipe.id from RecipeIngredient i join i.recipe r where " + access + " and "
                        + anyMatch(List.of("i.ingredientName"), patterns.size()), Long.class);
        for (TypedQuery<Long> q : List.of(byName, byIngredient)) {
            q.setParameter("userId", userId);
            bind(q, patterns);
        }
        Map<Long, Boolean> ids = new LinkedHashMap<>();
        byName.getResultList().forEach(id -> ids.put(id, true));
        byIngredient.getResultList().stream().sorted().forEach(id -> ids.putIfAbsent(id, false));
        return ids;
    }

    /** 레시피와 재료를 한 번에 읽는다 (순서는 호출자가 맞춘다) */
    public List<Recipe> recipesWithIngredients(Collection<Long> ids) {
        if (ids.isEmpty()) {
            return List.of();
        }
        return em.createQuery("select distinct r from Recipe r left join fetch r.ingredients where r.id in :ids",
                Recipe.class).setParameter("ids", ids).getResultList();
    }

    public long countLots(Long userId, List<String> patterns) {
        var q = em.createQuery("select count(l) from InventoryLot l where l.userId = :userId and l.status = :status and "
                + anyMatch(List.of("l.ingredientName"), patterns.size()), Long.class);
        q.setParameter("userId", userId).setParameter("status", LotStatus.ACTIVE);
        bind(q, patterns);
        return q.getSingleResult();
    }

    /** 기한이 빠른 순, 기한 미등록은 마지막 */
    public List<InventoryLot> lots(Long userId, List<String> patterns, int offset, int limit) {
        var q = em.createQuery("select l from InventoryLot l where l.userId = :userId and l.status = :status and "
                + anyMatch(List.of("l.ingredientName"), patterns.size())
                + " order by case when l.expiryDate is null then 1 else 0 end, l.expiryDate, l.id", InventoryLot.class);
        q.setParameter("userId", userId).setParameter("status", LotStatus.ACTIVE);
        bind(q, patterns);
        return q.setFirstResult(offset).setMaxResults(limit).getResultList();
    }

    public long countMealPlans(Long userId, List<String> patterns) {
        var q = em.createQuery("select count(m) from MealPlan m join m.recipe r where m.userId = :userId and "
                + anyMatch(List.of("r.name"), patterns.size()), Long.class);
        q.setParameter("userId", userId);
        bind(q, patterns);
        return q.getSingleResult();
    }

    /** 최근 날짜 순 */
    public List<MealPlan> mealPlans(Long userId, List<String> patterns, int offset, int limit) {
        var q = em.createQuery("select m from MealPlan m join fetch m.recipe r where m.userId = :userId and "
                + anyMatch(List.of("r.name"), patterns.size()) + " order by m.planDate desc, m.id desc", MealPlan.class);
        q.setParameter("userId", userId);
        bind(q, patterns);
        return q.setFirstResult(offset).setMaxResults(limit).getResultList();
    }

    public long countShopping(Long userId, List<String> patterns) {
        var q = em.createQuery("select count(s) from ShoppingItem s where s.userId = :userId and "
                + anyMatch(List.of("s.ingredientName"), patterns.size()), Long.class);
        q.setParameter("userId", userId);
        bind(q, patterns);
        return q.getSingleResult();
    }

    public List<ShoppingItem> shopping(Long userId, List<String> patterns, int offset, int limit) {
        var q = em.createQuery("select s from ShoppingItem s where s.userId = :userId and "
                + anyMatch(List.of("s.ingredientName"), patterns.size()) + " order by s.id", ShoppingItem.class);
        q.setParameter("userId", userId);
        bind(q, patterns);
        return q.setFirstResult(offset).setMaxResults(limit).getResultList();
    }

    public long countExercises(List<String> patterns) {
        var q = em.createQuery("select count(e) from ExerciseCatalog e where "
                + anyMatch(List.of("e.nameKo", "e.code"), patterns.size()), Long.class);
        bind(q, patterns);
        return q.getSingleResult();
    }

    public List<ExerciseCatalog> exercises(List<String> patterns, int offset, int limit) {
        var q = em.createQuery("select e from ExerciseCatalog e where "
                + anyMatch(List.of("e.nameKo", "e.code"), patterns.size()) + " order by e.nameKo, e.id", ExerciseCatalog.class);
        bind(q, patterns);
        return q.setFirstResult(offset).setMaxResults(limit).getResultList();
    }

    public long countWorkouts(Long userId, List<String> patterns) {
        var q = em.createQuery("select count(w) from WorkoutSession w where w.userId = :userId and "
                + anyMatch(List.of("w.title", "w.items"), patterns.size()), Long.class);
        q.setParameter("userId", userId);
        bind(q, patterns);
        return q.getSingleResult();
    }

    /** 최근 날짜 순 */
    public List<WorkoutSession> workouts(Long userId, List<String> patterns, int offset, int limit) {
        var q = em.createQuery("select w from WorkoutSession w where w.userId = :userId and "
                + anyMatch(List.of("w.title", "w.items"), patterns.size())
                + " order by w.sessionDate desc, w.id desc", WorkoutSession.class);
        q.setParameter("userId", userId);
        bind(q, patterns);
        return q.setFirstResult(offset).setMaxResults(limit).getResultList();
    }
}
