package com.mealfit.domain.shopping.service;

import com.mealfit.domain.cooking.repository.CookingEventRepository;
import com.mealfit.domain.cooking.entity.CookingStatus;
import com.mealfit.domain.inventory.entity.ExpirationStatus;
import com.mealfit.domain.inventory.entity.InventoryLot;
import com.mealfit.domain.inventory.repository.InventoryLotRepository;
import com.mealfit.domain.inventory.entity.LotStatus;
import com.mealfit.domain.mealplan.entity.MealPlan;
import com.mealfit.domain.mealplan.repository.MealPlanRepository;
import com.mealfit.domain.mealplan.entity.MealPlanStatus;
import com.mealfit.domain.recipe.model.Quantity;
import com.mealfit.domain.recipe.entity.Recipe;
import com.mealfit.domain.recipe.entity.RecipeIngredient;
import com.mealfit.domain.shopping.entity.ShoppingItem;
import com.mealfit.domain.shopping.repository.ShoppingItemRepository;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.SortedMap;
import java.util.TreeMap;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 장보기 부족분 계산 (BR-04).
 * 대상은 오늘 이후의 확정 식단 중 아직 조리하지 않은 것 전체이며, 재료·단위 계열마다 한 줄로 합친다(D06).
 * 부족분 = max(0, 필요량 합계 + 최소 유지량 - 사용 가능한 재고)
 * - 필요량: 레시피 재료량을 식단 인분으로 환산한 값 (개수 단위는 끼니마다 올림)
 * - 사용 가능한 재고: ACTIVE 묶음 중 기한이 지나지 않은 것 (BR-05).
 *   식단마다 그 식단 날짜까지 기한이 남은 묶음만 쓸 수 있다 (SDD 8.7). 날짜가 빠른 식단부터
 *   기한이 빠른 묶음을 배정하고, 배정하지 못한 필요량이 부족분이 된다.
 *   최소 유지량은 배정 후 남은(오늘 기준 기한이 지나지 않은) 재고와 비교한다.
 * - 최소 유지량: 같은 재료 묶음들(폐기 제외) 중 가장 큰 값 (D05)
 * - kg·L는 g·ml로 바꿔 합치고, 개·팩처럼 다른 계열 단위는 따로 계산한다 (BR-03)
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ShoppingListService {

    private final ShoppingItemRepository shoppingItemRepository;
    private final MealPlanRepository mealPlanRepository;
    private final CookingEventRepository cookingEventRepository;
    private final InventoryLotRepository inventoryLotRepository;

    /** 재료명 + 기본 단위(g, ml, 개 …) */
    private record Key(String ingredientName, String unit) {

        static Key of(String ingredientName, Quantity baseQuantity) {
            return new Key(ingredientName.strip(), baseQuantity.unit());
        }
    }

    /** 식단 확정·취소 후 호출한다. 다시 계산한 장보기 목록 전체를 돌려준다. */
    @Transactional
    public List<ShoppingItem> recalculate(Long userId, LocalDate today) {
        Map<Key, TreeMap<LocalDate, BigDecimal>> needs = sumNeeds(userId, today);
        Map<Key, List<Stock>> stock = new HashMap<>();
        Map<Key, BigDecimal> minStock = new HashMap<>();
        for (InventoryLot lot : inventoryLotRepository.findByUserIdAndStatusOrderByExpiryDateAsc(
                userId, LotStatus.ACTIVE)) {
            Quantity quantity = Quantity.of(lot.getQuantity(), lot.getUnit()).toBaseUnit();
            Key key = Key.of(lot.getIngredientName(), quantity);
            if (lot.expirationStatus(today) != ExpirationStatus.EXPIRED) {
                stock.computeIfAbsent(key, k -> new ArrayList<>())
                        .add(new Stock(lot.getExpiryDate(), quantity.amount()));
            }
            mergeMinStock(minStock, lot);
        }
        for (InventoryLot lot : inventoryLotRepository.findByUserIdAndStatusOrderByExpiryDateAsc(
                userId, LotStatus.DEPLETED)) {
            mergeMinStock(minStock, lot);
        }

        Map<Key, ShoppingItem> items = new LinkedHashMap<>();
        for (ShoppingItem item : shoppingItemRepository.findByUserIdOrderByIdAsc(userId)) {
            items.putIfAbsent(Key.of(item.getIngredientName(),
                    Quantity.of(item.getRequiredQty(), item.getUnit()).toBaseUnit()), item);
        }

        Set<Key> keys = new LinkedHashSet<>(items.keySet());
        keys.addAll(needs.keySet());
        List<ShoppingItem> result = new ArrayList<>();
        for (Key key : keys) {
            BigDecimal shortage = BigDecimal.ZERO;
            if (needs.containsKey(key)) {
                shortage = shortage(needs.get(key), stock.getOrDefault(key, List.of()),
                        minStock.getOrDefault(key, BigDecimal.ZERO));
            }
            ShoppingItem item = items.get(key);
            if (item == null) {
                if (shortage.signum() > 0) {
                    result.add(shoppingItemRepository.save(
                            ShoppingItem.create(userId, key.ingredientName(), shortage, key.unit())));
                }
                continue;
            }
            item.updateRequiredQty(shortage);
            if (item.isEmpty()) {
                shoppingItemRepository.delete(item);
            } else {
                result.add(item);
            }
        }
        return result;
    }

    /** 재고 묶음 하나의 기한과 남은 양(기본 단위). 기한 없음(null)은 언제든 쓸 수 있다고 본다 (D11 전까지 현행 유지) */
    private static final class Stock {
        private final LocalDate expiryDate;
        private BigDecimal remaining;

        private Stock(LocalDate expiryDate, BigDecimal remaining) {
            this.expiryDate = expiryDate;
            this.remaining = remaining;
        }

        private boolean usableOn(LocalDate date) {
            return expiryDate == null || !expiryDate.isBefore(date);
        }
    }

    private static final Comparator<Stock> EXPIRY_FIRST =
            Comparator.comparing((Stock stock) -> stock.expiryDate, Comparator.nullsLast(Comparator.naturalOrder()));

    /**
     * 부족분 = 배정하지 못한 필요량 + max(0, 최소 유지량 - 배정 후 남은 재고).
     * 모든 묶음이 모든 식단 날짜에 쓸 수 있으면 기존 식 max(0, 필요량 + 최소 유지량 - 재고)와 같다.
     */
    private static BigDecimal shortage(SortedMap<LocalDate, BigDecimal> needsByDate, List<Stock> lots, BigDecimal minStock) {
        List<Stock> ordered = new ArrayList<>(lots.size());
        lots.forEach(lot -> ordered.add(new Stock(lot.expiryDate, lot.remaining)));
        ordered.sort(EXPIRY_FIRST);

        BigDecimal unmet = BigDecimal.ZERO;
        for (Map.Entry<LocalDate, BigDecimal> need : needsByDate.entrySet()) {
            BigDecimal left = need.getValue();
            for (Stock lot : ordered) {
                if (left.signum() == 0) {
                    break;
                }
                if (lot.remaining.signum() == 0 || !lot.usableOn(need.getKey())) {
                    continue;
                }
                BigDecimal used = left.min(lot.remaining);
                lot.remaining = lot.remaining.subtract(used);
                left = left.subtract(used);
            }
            unmet = unmet.add(left);
        }
        BigDecimal leftover = ordered.stream().map(lot -> lot.remaining).reduce(BigDecimal.ZERO, BigDecimal::add);
        return unmet.add(minStock.subtract(leftover).max(BigDecimal.ZERO));
    }

    private Map<Key, TreeMap<LocalDate, BigDecimal>> sumNeeds(Long userId, LocalDate today) {
        Map<Key, TreeMap<LocalDate, BigDecimal>> needs = new LinkedHashMap<>();
        List<MealPlan> plans = mealPlanRepository.findByUserIdAndStatusAndPlanDateGreaterThanEqual(
                userId, MealPlanStatus.CONFIRMED, today);
        for (MealPlan plan : plans) {
            if (cookingEventRepository.existsByMealPlanIdAndStatus(plan.getId(), CookingStatus.COOKED)) {
                continue;
            }
            Recipe recipe = plan.getRecipe();
            for (RecipeIngredient ingredient : recipe.getIngredients()) {
                Quantity need = Quantity.of(ingredient.getRequiredQty(), ingredient.getUnit())
                        .scaleServings(recipe.getServingSize(), plan.getServings())
                        .toBaseUnit();
                needs.computeIfAbsent(Key.of(ingredient.getIngredientName(), need), key -> new TreeMap<>())
                        .merge(plan.getPlanDate(), need.amount(), BigDecimal::add);
            }
        }
        return needs;
    }

    private static void mergeMinStock(Map<Key, BigDecimal> minStock, InventoryLot lot) {
        Quantity min = Quantity.of(lot.getMinStockQty(), lot.getUnit()).toBaseUnit();
        minStock.merge(Key.of(lot.getIngredientName(), min), min.amount(), BigDecimal::max);
    }
}
