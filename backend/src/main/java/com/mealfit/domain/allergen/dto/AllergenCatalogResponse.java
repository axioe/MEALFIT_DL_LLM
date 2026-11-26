package com.mealfit.domain.allergen.dto;

import com.mealfit.domain.allergen.entity.Allergen;
import com.mealfit.domain.allergen.entity.AllergenLegalStatus;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** 알레르기 선택 화면용 목록: 카테고리 묶음 → 세부 항목 (MEALFIT-139). */
public record AllergenCatalogResponse(List<Category> categories) {

    public record Category(String name, int order, List<Item> items) {
    }

    /**
     * @param selectAll 묶음의 [전체 선택]에 포함되는지
     * @param legalStatus CURRENT(현행 고시) / PROPOSED(개정 예고). 화면에 시행 예정 문구는 넣지 않는다
     */
    public record Item(String code, String name, boolean selectAll, AllergenLegalStatus legalStatus,
                       String legalCondition, List<String> aliases) {

        public static Item from(Allergen allergen) {
            return new Item(allergen.getCode(), allergen.getName(), allergen.isSelectAll(), allergen.getLegalStatus(),
                    allergen.getLegalCondition(), allergen.getAliases().stream().sorted().toList());
        }
    }

    /** displayOrder 순으로 정렬된 목록을 카테고리 순서대로 묶는다. */
    public static AllergenCatalogResponse from(List<Allergen> ordered) {
        Map<String, Category> groups = new LinkedHashMap<>();
        for (Allergen allergen : ordered) {
            groups.computeIfAbsent(allergen.getCategory(),
                    name -> new Category(name, allergen.getCategoryOrder(), new java.util.ArrayList<>()))
                    .items().add(Item.from(allergen));
        }
        return new AllergenCatalogResponse(groups.values().stream()
                .map(c -> new Category(c.name(), c.order(), List.copyOf(c.items())))
                .toList());
    }
}
