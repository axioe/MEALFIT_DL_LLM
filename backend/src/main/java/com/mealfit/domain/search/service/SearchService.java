package com.mealfit.domain.search.service;

import com.mealfit.domain.inventory.entity.InventoryLot;
import com.mealfit.domain.mealplan.entity.MealPlan;
import com.mealfit.domain.mealplan.model.IngredientRestriction;
import com.mealfit.domain.mealplan.service.UserDietProfileProvider;
import com.mealfit.domain.recipe.entity.IngredientStandard;
import com.mealfit.domain.recipe.entity.Recipe;
import com.mealfit.domain.recipe.entity.RecipeIngredient;
import com.mealfit.domain.recipe.repository.IngredientStandardRepository;
import com.mealfit.domain.search.dto.SearchResponse;
import com.mealfit.domain.search.dto.SearchResponse.ExerciseHit;
import com.mealfit.domain.search.dto.SearchResponse.Group;
import com.mealfit.domain.search.dto.SearchResponse.InventoryHit;
import com.mealfit.domain.search.dto.SearchResponse.MealPlanHit;
import com.mealfit.domain.search.dto.SearchResponse.RecipeHit;
import com.mealfit.domain.search.dto.SearchResponse.ShoppingHit;
import com.mealfit.domain.search.dto.SearchResponse.WorkoutHit;
import com.mealfit.domain.search.dto.SearchType;
import com.mealfit.domain.search.repository.SearchRepository;
import com.mealfit.domain.shopping.entity.ShoppingItem;
import com.mealfit.domain.workout.entity.ExerciseCatalog;
import com.mealfit.domain.workout.entity.WorkoutSession;
import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.EnumSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 웹 통합 검색 (키워드 + 재료 별칭).
 * <ul>
 *   <li>공백·대소문자를 무시하고 포함 여부로 찾는다 ("김치 찌개" = "김치찌개").</li>
 *   <li>검색어가 재료 기준표의 이름·별칭과 같으면 같은 재료의 다른 이름도 함께 찾는다 (계란 → 달걀).</li>
 *   <li>공용 레시피 외에는 본인 데이터만 찾는다. 레시피는 내 알레르기·제외 재료가 있어도 빼지 않고 restricted로 표시한다.</li>
 *   <li>의미 검색(LLM-02, pgvector)은 별도 작업이라 여기서 하지 않는다.</li>
 * </ul>
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class SearchService {

    public static final int MAX_QUERY_LENGTH = 50;
    public static final int DEFAULT_LIMIT = 5;
    public static final int MAX_LIMIT = 20;
    private static final int MAX_TERMS = 10;
    private static final Set<SearchType> PUBLIC_TYPES = Set.of(SearchType.RECIPE, SearchType.EXERCISE);
    private static final ZoneId KST = ZoneId.of("Asia/Seoul");

    private final SearchRepository searchRepository;
    private final IngredientStandardRepository ingredientStandardRepository;
    private final UserDietProfileProvider userDietProfileProvider;

    public SearchResponse searchPublic(String query, Set<SearchType> requested, Integer limit, Integer offset) {
        Set<SearchType> types = requested == null || requested.isEmpty() ? PUBLIC_TYPES : requested;
        if (!PUBLIC_TYPES.containsAll(types)) {
            throw new BusinessException(ErrorCode.INVALID_INPUT);
        }
        return search(null, query, types, limit, offset);
    }

    public SearchResponse search(Long userId, String rawQuery, Set<SearchType> requested, Integer limit, Integer offset) {
        String query = cleanQuery(rawQuery);
        int size = limit == null ? DEFAULT_LIMIT : limit;
        int from = offset == null ? 0 : offset;
        if (size < 1 || size > MAX_LIMIT || from < 0) {
            throw new BusinessException(ErrorCode.INVALID_INPUT);
        }
        Set<SearchType> types = requested == null || requested.isEmpty() ? EnumSet.allOf(SearchType.class) : requested;

        List<String> terms = expandTerms(query);
        List<String> patterns = terms.stream().map(SearchService::likePattern).distinct().toList();

        return new SearchResponse(query, terms,
                types.contains(SearchType.RECIPE) ? recipes(userId, terms, patterns, from, size) : null,
                types.contains(SearchType.INVENTORY) ? inventory(userId, patterns, from, size) : null,
                types.contains(SearchType.MEAL_PLAN) ? group(searchRepository.countMealPlans(userId, patterns),
                        searchRepository.mealPlans(userId, patterns, from, size), SearchService::toHit) : null,
                types.contains(SearchType.SHOPPING) ? group(searchRepository.countShopping(userId, patterns),
                        searchRepository.shopping(userId, patterns, from, size), SearchService::toHit) : null,
                types.contains(SearchType.EXERCISE) ? group(searchRepository.countExercises(patterns),
                        searchRepository.exercises(patterns, from, size), SearchService::toHit) : null,
                types.contains(SearchType.WORKOUT) ? group(searchRepository.countWorkouts(userId, patterns),
                        searchRepository.workouts(userId, patterns, from, size), SearchService::toHit) : null);
    }

    /** 앞뒤 공백 제거, 연속 공백은 하나로. 비었거나 50자를 넘으면 400 */
    static String cleanQuery(String raw) {
        String query = raw == null ? "" : raw.strip().replaceAll("\\s+", " ");
        if (query.isEmpty() || query.length() > MAX_QUERY_LENGTH) {
            throw new BusinessException(ErrorCode.INVALID_INPUT);
        }
        return query;
    }

    /** 비교용: 소문자 + 공백 제거 */
    static String compact(String value) {
        return value.toLowerCase(Locale.ROOT).replaceAll("\\s+", "");
    }

    /** LIKE 패턴 (와일드카드 문자는 글자 그대로 찾도록 이스케이프) */
    static String likePattern(String term) {
        String escaped = compact(term).replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_");
        return "%" + escaped + "%";
    }

    /** 검색어 + 재료 기준표에서 같은 재료로 묶인 이름·별칭 */
    List<String> expandTerms(String query) {
        Set<String> terms = new LinkedHashSet<>();
        terms.add(query);
        String key = compact(query);
        for (IngredientStandard standard : ingredientStandardRepository.findAllByOrderByIdAsc()) {
            Set<String> names = new LinkedHashSet<>();
            names.add(standard.getName());
            names.addAll(standard.getAliases());
            if (names.stream().map(SearchService::compact).anyMatch(key::equals)) {
                terms.addAll(names);
            }
        }
        return terms.stream().limit(MAX_TERMS).toList();
    }

    private Group<RecipeHit> recipes(Long userId, List<String> terms, List<String> patterns, int from, int size) {
        Map<Long, Boolean> ids = searchRepository.recipeIds(userId, patterns);
        List<Long> page = ids.keySet().stream().skip(from).limit(size).toList();
        Map<Long, Recipe> loaded = searchRepository.recipesWithIngredients(page).stream()
                .collect(Collectors.toMap(Recipe::getId, Function.identity()));
        Set<String> restrictedSet = userId == null ? Set.of() : userDietProfileProvider.getProfile(userId).restrictedIngredients();
        Set<String> keys = terms.stream().map(SearchService::compact).collect(Collectors.toSet());

        List<RecipeHit> hits = new ArrayList<>();
        for (Long id : page) {
            Recipe recipe = loaded.get(id);
            if (recipe == null) {
                continue;
            }
            List<String> ingredients = recipe.getIngredients().stream()
                    .map(RecipeIngredient::getIngredientName).distinct().toList();
            List<String> matched = ingredients.stream()
                    .filter(name -> keys.stream().anyMatch(compact(name)::contains)).toList();
            List<String> violations = IngredientRestriction.violations(ingredients, restrictedSet);
            hits.add(new RecipeHit(recipe.getId(), recipe.getName(), recipe.getCookTimeMin(), recipe.getSource(),
                    userId != null && userId.equals(recipe.getUserId()), matched, !violations.isEmpty(), violations));
        }
        return new Group<>(ids.size(), hits);
    }

    private Group<InventoryHit> inventory(Long userId, List<String> patterns, int from, int size) {
        LocalDate today = LocalDate.now(KST);
        return group(searchRepository.countLots(userId, patterns), searchRepository.lots(userId, patterns, from, size),
                lot -> toHit(lot, today));
    }

    private static <E, T> Group<T> group(long total, List<E> rows, Function<E, T> mapper) {
        return new Group<>(total, rows.stream().map(mapper).toList());
    }

    private static InventoryHit toHit(InventoryLot lot, LocalDate today) {
        return new InventoryHit(lot.getId(), lot.getIngredientName(), lot.getQuantity(), lot.getUnit(),
                lot.getExpiryDate(), lot.expirationStatus(today), lot.getStorageLocation());
    }

    private static MealPlanHit toHit(MealPlan plan) {
        return new MealPlanHit(plan.getId(), plan.getPlanDate(), plan.getMealType(), plan.getStatus(),
                plan.getRecipe().getId(), plan.getRecipe().getName());
    }

    private static ShoppingHit toHit(ShoppingItem item) {
        return new ShoppingHit(item.getId(), item.getIngredientName(), item.getRequiredQty(), item.getPurchasedQty(),
                item.getUnit(), item.getStatus());
    }

    private static ExerciseHit toHit(ExerciseCatalog exercise) {
        return new ExerciseHit(exercise.getCode(), exercise.getNameKo(), exercise.getFocusArea().name(),
                exercise.getEquipment().name(), exercise.getIntensity(), exercise.getPoseExerciseKey() != null);
    }

    private static WorkoutHit toHit(WorkoutSession session) {
        return new WorkoutHit(session.getId(), session.getSessionDate(), session.getTitle(), session.getFocusArea(),
                session.getPlannedMinutes());
    }
}
