package com.mealfit.domain.mealplan.service;

import com.mealfit.domain.cooking.repository.CookingEventRepository;
import com.mealfit.domain.cooking.entity.CookingStatus;
import com.mealfit.domain.inventory.entity.ExpirationStatus;
import com.mealfit.domain.inventory.entity.InventoryLot;
import com.mealfit.domain.inventory.repository.InventoryLotRepository;
import com.mealfit.domain.inventory.entity.LotStatus;
import com.mealfit.domain.mealplan.dto.AiMealPlanRequest;
import com.mealfit.domain.mealplan.dto.AiMealSuggestion;
import com.mealfit.domain.mealplan.dto.MealPlanConfirmResponse;
import com.mealfit.domain.mealplan.dto.MealPlanRecommendRequest;
import com.mealfit.domain.mealplan.dto.MealPlanRecommendResponse;
import com.mealfit.domain.mealplan.dto.MealPlanResponse;
import com.mealfit.domain.mealplan.entity.MealPlan;
import com.mealfit.domain.mealplan.entity.MealPlanStatus;
import com.mealfit.domain.mealplan.entity.MealType;
import com.mealfit.domain.mealplan.model.IngredientRestriction;
import com.mealfit.domain.mealplan.model.UserDietProfile;
import com.mealfit.domain.mealplan.repository.MealPlanRepository;
import com.mealfit.domain.recipe.entity.Recipe;
import com.mealfit.domain.recipe.repository.RecipeRepository;
import com.mealfit.domain.recipe.entity.RecipeSource;
import com.mealfit.domain.shopping.service.ShoppingListService;
import com.mealfit.domain.shopping.dto.ShoppingItemResponse;
import com.mealfit.domain.user.repository.UserRepository;
import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import jakarta.persistence.EntityManager;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 식단 추천. AI 제안을 먼저 쓰고, AI가 없거나 실패하거나 서버 검증을 통과하지 못한 끼니는 검증된 로컬 대체로 채운다.
 * 추천 결과는 항상 DRAFT이며 재고를 바꾸지 않는다.
 * 추천·재추천은 준비(prepare*) → AI 호출(MealPlanRecommender, 트랜잭션 밖) → 저장(save*) 순서로 나눈다.
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class MealPlanService {

    /** 반복 최소화에 쓰는 최근 식단 기간 (D10 확정 전 임시값) */
    private static final int RECENT_DAYS = 7;
    private static final int MAX_TEXT_LENGTH = 500;
    /** 서버 시간대(EC2는 UTC)와 상관없이 한국 날짜로 계산한다. 냉장고 도메인과 같은 기준 */
    private static final ZoneId ZONE = ZoneId.of("Asia/Seoul");

    private final MealPlanRepository mealPlanRepository;
    private final RecipeRepository recipeRepository;
    private final InventoryLotRepository inventoryLotRepository;
    private final FallbackRecipeSelector fallbackRecipeSelector;
    private final ObjectProvider<UserDietProfileProvider> profileProvider;
    private final ShoppingListService shoppingListService;
    private final CookingEventRepository cookingEventRepository;
    private final EntityManager entityManager;
    private final UserRepository userRepository;

    /** 날짜별 식단 조회. 취소된 식단은 빼고 아침·점심·저녁 순서로 돌려준다. */
    public MealPlanRecommendResponse getByDate(Long userId, LocalDate planDate) {
        LocalDate date = planDate != null ? planDate : LocalDate.now(ZONE);
        List<MealPlanResponse> mealPlans = mealPlanRepository.findByUserIdAndPlanDateAndStatusNot(
                        userId, date, MealPlanStatus.CANCELED).stream()
                .sorted(Comparator.comparing(MealPlan::getMealType))
                .map(this::toResponse)
                .toList();
        return new MealPlanRecommendResponse(date, mealPlans);
    }

    /** AI 호출에 필요한 요청과 검증 기준. 잠금 없이 읽어서 만든다. */
    public record AiPreparation(AiMealPlanRequest request, Set<String> restricted) {
    }

    /**
     * 하루 세 끼 추천 1단계: AI 요청 준비 (읽기 전용, 잠금 없음).
     * AI 호출은 MealPlanRecommender가 트랜잭션 밖에서 하고, 결과는 {@link #saveRecommendation}이 저장한다.
     * AI를 기다리는 동안 회원·식단 행을 잠그거나 DB 연결을 붙잡지 않기 위해서다 (TRD AI-01).
     */
    public AiPreparation prepareRecommend(Long userId, MealPlanRecommendRequest request) {
        LocalDate planDate = request.planDate();
        List<MealPlan> confirmed = mealPlanRepository.findByUserIdAndPlanDateAndStatusNot(
                        userId, planDate, MealPlanStatus.CANCELED).stream()
                .filter(plan -> plan.getStatus() == MealPlanStatus.CONFIRMED)
                .toList();
        List<MealType> targets = targetsExcept(confirmed);
        if (targets.isEmpty()) {
            throw new BusinessException(ErrorCode.MEAL_PLAN_ALL_CONFIRMED);
        }
        return prepare(userId, planDate, targets, request.servingsOrDefault(), confirmed);
    }

    /**
     * 하루 세 끼 추천 2단계: 저장. 같은 날짜로 다시 부르면 전체 재추천이다:
     * 기존 초안은 취소하고, 이미 확정된 끼니는 그대로 두고 나머지 끼니만 새로 만든다.
     * 그 날짜의 식단을 잠가서, 재추천이 동시에 들어와도 살아 있는 초안이 끼니마다 하나만 남게 한다 (D06).
     * 준비 이후 상태가 바뀌었을 수 있으므로 잠근 뒤 대상 끼니를 다시 계산한다.
     *
     * @param aiSuggestions 트랜잭션 밖에서 받은 AI 제안 (없으면 로컬 대체)
     */
    @Transactional
    public MealPlanRecommendResponse saveRecommendation(Long userId, MealPlanRecommendRequest request,
                                                        Map<MealType, AiMealSuggestion> aiSuggestions) {
        LocalDate planDate = request.planDate();
        List<MealPlan> existing = lockDate(userId, planDate);
        List<MealPlan> confirmed = existing.stream()
                .filter(plan -> plan.getStatus() == MealPlanStatus.CONFIRMED)
                .toList();
        List<MealType> targets = targetsExcept(confirmed);
        if (targets.isEmpty()) {
            throw new BusinessException(ErrorCode.MEAL_PLAN_ALL_CONFIRMED);
        }
        List<MealPlan> drafts = existing.stream()
                .filter(plan -> plan.getStatus() == MealPlanStatus.DRAFT)
                .toList();
        Set<String> previousNames = drafts.stream()
                .map(plan -> plan.getRecipe().getName())
                .collect(Collectors.toSet());
        drafts.forEach(MealPlan::cancel);

        List<MealPlan> created = generate(userId, planDate, targets, request.servingsOrDefault(), confirmed,
                previousNames, aiSuggestions);
        List<MealPlanResponse> mealPlans = new ArrayList<>();
        confirmed.forEach(plan -> mealPlans.add(toResponse(plan)));
        created.forEach(plan -> mealPlans.add(MealPlanResponse.from(plan)));
        mealPlans.sort(Comparator.comparing(MealPlanResponse::mealType));
        return new MealPlanRecommendResponse(planDate, mealPlans);
    }

    /** 한 끼 재추천 1단계: AI 요청 준비 (읽기 전용, 잠금 없음). 초안만 가능하다. */
    public AiPreparation prepareRegenerate(Long userId, Long mealPlanId) {
        MealPlan plan = mealPlanRepository.findByIdAndUserId(mealPlanId, userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.MEAL_PLAN_NOT_FOUND));
        if (plan.getStatus() != MealPlanStatus.DRAFT) {
            throw new BusinessException(ErrorCode.MEAL_PLAN_NOT_DRAFT);
        }
        return prepare(userId, plan.getPlanDate(), List.of(plan.getMealType()), plan.getServings(),
                othersOnSameDay(userId, plan));
    }

    /** 한 끼 재추천 2단계: 저장. 잠근 뒤 초안인지 다시 확인하고, 같은 날 다른 끼니는 바꾸지 않는다. */
    @Transactional
    public MealPlanResponse saveRegeneration(Long userId, Long mealPlanId,
                                             Map<MealType, AiMealSuggestion> aiSuggestions) {
        MealPlan plan = lockPlan(userId, mealPlanId);
        if (plan.getStatus() != MealPlanStatus.DRAFT) {
            throw new BusinessException(ErrorCode.MEAL_PLAN_NOT_DRAFT);
        }
        List<MealPlan> others = othersOnSameDay(userId, plan);
        plan.cancel();

        List<MealPlan> created = generate(userId, plan.getPlanDate(), List.of(plan.getMealType()),
                plan.getServings(), others, Set.of(plan.getRecipe().getName()), aiSuggestions);
        return MealPlanResponse.from(created.get(0));
    }

    private List<MealPlan> othersOnSameDay(Long userId, MealPlan plan) {
        return mealPlanRepository.findByUserIdAndPlanDateAndStatusNot(
                        userId, plan.getPlanDate(), MealPlanStatus.CANCELED).stream()
                .filter(other -> !other.getId().equals(plan.getId()))
                .toList();
    }

    private static List<MealType> targetsExcept(List<MealPlan> confirmed) {
        Set<MealType> confirmedTypes = confirmed.stream().map(MealPlan::getMealType).collect(Collectors.toSet());
        return Arrays.stream(MealType.values())
                .filter(type -> !confirmedTypes.contains(type))
                .toList();
    }

    /**
     * 서버 검증 후 확정 (FR-MEAL-05, BR-12). 레시피 데이터와 알레르기·제외 재료를 다시 검사하고,
     * 통과하면 CONFIRMED로 바꾼 뒤 장보기 부족분을 다시 계산한다.
     */
    @Transactional
    public MealPlanConfirmResponse confirm(Long userId, Long mealPlanId) {
        MealPlan plan = lockPlan(userId, mealPlanId);
        plan.getStatus().validateTransition(MealPlanStatus.CONFIRMED);
        Recipe recipe = plan.getRecipe();

        List<String> problems = dataProblems(recipe, plan);
        if (!problems.isEmpty()) {
            throw new BusinessException(ErrorCode.MEAL_PLAN_INVALID_DATA,
                    ErrorCode.MEAL_PLAN_INVALID_DATA.getMessage() + " (" + String.join(", ", problems) + ")");
        }
        List<String> ingredientNames = recipe.getIngredients().stream()
                .map(ingredient -> ingredient.getIngredientName().strip())
                .toList();
        List<String> violations = IngredientRestriction.violations(
                ingredientNames, profileOf(userId).restrictedIngredients());
        if (!violations.isEmpty()) {
            throw new BusinessException(ErrorCode.MEAL_PLAN_RESTRICTED_INGREDIENT,
                    ErrorCode.MEAL_PLAN_RESTRICTED_INGREDIENT.getMessage()
                            + " (" + String.join(", ", violations) + ")");
        }

        plan.confirm();
        List<ShoppingItemResponse> shortages = shoppingListService.recalculate(userId, LocalDate.now(ZONE)).stream()
                .filter(item -> ingredientNames.contains(item.getIngredientName()))
                .filter(item -> item.remainingQty().signum() > 0)
                .map(ShoppingItemResponse::from)
                .toList();
        return new MealPlanConfirmResponse(MealPlanResponse.from(plan), shortages);
    }

    /**
     * 식단 취소 (FR-MEAL-06). 초안·확정 식단을 취소하고, 확정 식단이었다면 장보기 부족분을 다시 계산한다.
     * 이미 조리한 식단은 조리를 먼저 취소해야 한다(재고 복원이 먼저).
     */
    @Transactional
    public MealPlanResponse cancel(Long userId, Long mealPlanId) {
        MealPlan plan = lockPlan(userId, mealPlanId);
        if (cookingEventRepository.existsByMealPlanIdAndStatus(plan.getId(), CookingStatus.COOKED)) {
            throw new BusinessException(ErrorCode.MEAL_PLAN_ALREADY_COOKED);
        }
        boolean wasConfirmed = plan.getStatus() == MealPlanStatus.CONFIRMED;
        plan.cancel();
        if (wasConfirmed) {
            shoppingListService.recalculate(userId, LocalDate.now(ZONE));
        }
        return MealPlanResponse.from(plan);
    }

    /** 확정 식단만 조리될 수 있으므로 그때만 조리 기록을 조회한다. */
    private MealPlanResponse toResponse(MealPlan plan) {
        boolean cooked = plan.getStatus() == MealPlanStatus.CONFIRMED
                && cookingEventRepository.existsByMealPlanIdAndStatus(plan.getId(), CookingStatus.COOKED);
        return MealPlanResponse.from(plan, cooked);
    }

    /**
     * 상태를 바꾸기 전에 식단을 잠근다. 조리(CookingService.cook)도 같은 식단을 잠그므로
     * 확정·취소·재추천·조리가 동시에 들어와도 한 번에 하나씩 처리되고 상태 검사가 어긋나지 않는다 (BR-09, BR-13).
     */
    private MealPlan lockPlan(Long userId, Long mealPlanId) {
        return mealPlanRepository.findForUpdate(mealPlanId, userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.MEAL_PLAN_NOT_FOUND));
    }

    /**
     * 그 날짜의 살아 있는 식단을 잠근다. 다른 재추천이 먼저 잠갔다면 끝날 때까지 기다리는데,
     * 기다린 조회 결과에는 그동안 취소된 초안이 남고 새로 만든 초안은 빠질 수 있다.
     * 그래서 잠근 뒤 영속성 컨텍스트를 비우고 한 번 더 읽어 최신 상태를 쓴다.
     */
    private List<MealPlan> lockDate(Long userId, LocalDate planDate) {
        // 첫 추천도 회원 잠금으로 순서대로 처리한다.
        userRepository.findByIdForUpdate(userId)
                .filter(user -> user.getDeletedAt() == null)
                .orElseThrow(() -> new BusinessException(ErrorCode.UNAUTHORIZED));
        mealPlanRepository.findForUpdateByDate(userId, planDate, MealPlanStatus.CANCELED);
        entityManager.clear();
        return mealPlanRepository.findForUpdateByDate(userId, planDate, MealPlanStatus.CANCELED);
    }

    /** 확정 전 데이터 무결성 검사: 재료·수량·단위 누락, 비정상 인분 */
    private static List<String> dataProblems(Recipe recipe, MealPlan plan) {
        List<String> problems = new ArrayList<>();
        if (recipe.getServingSize() < 1 || plan.getServings() < 1) {
            problems.add("인분 비정상");
        }
        if (recipe.getIngredients().isEmpty()) {
            problems.add("재료 누락");
        }
        recipe.getIngredients().forEach(ingredient -> {
            String name = ingredient.getIngredientName();
            if (name == null || name.isBlank()) {
                problems.add("재료명 누락");
            } else if (ingredient.getRequiredQty() == null || ingredient.getRequiredQty().signum() <= 0) {
                problems.add("수량 비정상: " + name.strip());
            } else if (ingredient.getUnit() == null || ingredient.getUnit().isBlank()) {
                problems.add("단위 누락: " + name.strip());
            }
        });
        return problems;
    }

    private UserDietProfile profileOf(Long userId) {
        return Optional.ofNullable(profileProvider.getIfAvailable())
                .map(provider -> provider.getProfile(userId))
                .orElseGet(UserDietProfile::empty);
    }

    /** 재료는 오늘이 아니라 그 식단을 먹는 날 기준으로 판단한다 (SDD 8.7). 과거 날짜면 오늘 기준 */
    private static LocalDate basisDate(LocalDate planDate) {
        LocalDate today = LocalDate.now(ZONE);
        return planDate.isBefore(today) ? today : planDate;
    }

    /** 먹는 날 전에 기한이 지나는 재료는 보유 재료로 보지 않는다. */
    private List<InventoryLot> availableLots(Long userId, LocalDate basis) {
        return inventoryLotRepository
                .findByUserIdAndStatusOrderByExpiryDateAsc(userId, LotStatus.ACTIVE).stream()
                .filter(lot -> lot.expirationStatus(basis) != ExpirationStatus.EXPIRED)
                .toList();
    }

    /** AI 요청을 만든다. 임박 여부도 식단 날짜 기준으로 계산한다. */
    private AiPreparation prepare(Long userId, LocalDate planDate, List<MealType> targets, int servings,
                                  List<MealPlan> keptPlans) {
        LocalDate basis = basisDate(planDate);
        UserDietProfile profile = profileOf(userId);
        AiMealPlanRequest aiRequest = new AiMealPlanRequest(planDate, targets, servings,
                profile.goal(), profile.cookTimeMin(), profile.mealBudget(),
                profile.allergies(), profile.excludedIngredients(),
                availableLots(userId, basis).stream()
                        .map(lot -> new AiMealPlanRequest.InventoryItem(lot.getIngredientName(), lot.getQuantity(),
                                lot.getUnit(), lot.getExpiryDate(), lot.expirationStatus(basis)))
                        .toList(),
                keptPlans.stream().map(plan -> plan.getRecipe().getName()).toList(),
                recentRecipeNames(userId, planDate));
        return new AiPreparation(aiRequest, profile.restrictedIngredients());
    }

    /**
     * @param keptPlans     같은 날 그대로 두는 끼니 (메뉴가 겹치지 않게 한다)
     * @param previousNames 직전 초안 메뉴명 (가능하면 다른 메뉴를 고른다)
     * @param aiSuggestions 트랜잭션 밖에서 받은 AI 제안. 준비 이후 프로필이 바뀌었을 수 있어 제한 재료를 다시 검사한다.
     */
    private List<MealPlan> generate(Long userId, LocalDate planDate, List<MealType> targets, int servings,
                                    List<MealPlan> keptPlans, Set<String> previousNames,
                                    Map<MealType, AiMealSuggestion> aiSuggestions) {
        LocalDate basis = basisDate(planDate);
        UserDietProfile profile = profileOf(userId);
        List<InventoryLot> availableLots = availableLots(userId, basis);
        List<String> keptNames = keptPlans.stream().map(plan -> plan.getRecipe().getName()).toList();
        List<String> recentNames = recentRecipeNames(userId, planDate);

        Set<String> usedNames = new HashSet<>(keptNames);
        List<MealPlan> created = new ArrayList<>();
        for (MealType mealType : targets) {
            AiMealSuggestion suggestion = aiSuggestions.get(mealType);
            if (suggestion != null
                    && AiSuggestionValidator.validate(suggestion, profile.restrictedIngredients()).isPresent()) {
                suggestion = null;
            }
            Recipe recipe;
            String reason;
            if (suggestion != null && !usedNames.contains(suggestion.recipeName().strip())
                    && !previousNames.contains(suggestion.recipeName().strip())) {
                recipe = recipeRepository.save(toRecipe(userId, suggestion));
                reason = suggestion.reason();
            } else {
                FallbackRecipeSelector.Selection selection = fallbackRecipeSelector
                        .select(mealType, profile, availableLots, usedNames, previousNames, recentNames, basis)
                        .orElseThrow(() -> new BusinessException(ErrorCode.MEAL_PLAN_NO_CANDIDATE));
                recipe = selection.recipe();
                reason = selection.reason();
            }
            usedNames.add(recipe.getName());
            created.add(mealPlanRepository.save(MealPlan.builder()
                    .userId(userId)
                    .planDate(planDate)
                    .mealType(mealType)
                    .recipe(recipe)
                    .servings(servings)
                    .recommendationReason(truncate(reason))
                    .build()));
        }
        return created;
    }

    private Recipe toRecipe(Long userId, AiMealSuggestion suggestion) {
        Recipe recipe = Recipe.builder()
                .userId(userId)
                .name(suggestion.recipeName().strip())
                .description(truncate(suggestion.description()))
                .servingSize(suggestion.servingSize())
                .cookTimeMin(suggestion.cookTimeMin())
                .calories(suggestion.calories())
                .proteinG(suggestion.proteinG())
                .carbsG(suggestion.carbsG())
                .fatG(suggestion.fatG())
                .nutritionEstimated(true)
                .source(RecipeSource.AI_GENERATED)
                .mealType(suggestion.mealType())
                .steps(suggestion.steps().stream().map(String::strip).toList())
                .build();
        suggestion.ingredients().forEach(ingredient ->
                recipe.addIngredient(ingredient.name().strip(), ingredient.quantity(), ingredient.unit().strip()));
        return recipe;
    }

    private List<String> recentRecipeNames(Long userId, LocalDate planDate) {
        return mealPlanRepository.findByUserIdAndPlanDateBetweenOrderByPlanDateAscMealTypeAsc(
                        userId, planDate.minusDays(RECENT_DAYS), planDate.minusDays(1)).stream()
                .filter(plan -> plan.getStatus() != MealPlanStatus.CANCELED)
                .map(plan -> plan.getRecipe().getName())
                .distinct()
                .toList();
    }

    private static String truncate(String text) {
        if (text == null) {
            return null;
        }
        String stripped = text.strip();
        return stripped.length() <= MAX_TEXT_LENGTH ? stripped : stripped.substring(0, MAX_TEXT_LENGTH);
    }
}
