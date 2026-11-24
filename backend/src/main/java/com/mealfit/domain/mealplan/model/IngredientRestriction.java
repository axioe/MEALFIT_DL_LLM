package com.mealfit.domain.mealplan.model;

import java.util.Collection;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 알레르기·제외 재료 검사.
 * D09의 동의어는 표준명으로 비교하고, 기존 재료명 포함 검사도 적용한다.
 * 가공식품으로의 확장은 UserDietProfile이 알레르기에만 적용한다.
 */
public final class IngredientRestriction {

    private static final Map<String, String> STANDARD_NAMES = Map.of(
            "계란", "달걀",
            "egg", "달걀",
            "milk", "우유",
            "쇠고기", "소고기"
    );

    private IngredientRestriction() {
    }

    /** 위반한 재료명 목록. 비어 있으면 통과 */
    public static List<String> violations(Collection<String> ingredientNames, Set<String> restricted) {
        if (restricted.isEmpty()) {
            return List.of();
        }
        List<String> normalizedRestricted = restricted.stream()
                .map(IngredientRestriction::normalize)
                .filter(term -> !term.isEmpty())
                .toList();
        Set<String> standardRestricted = normalizedRestricted.stream()
                .map(IngredientRestriction::standardName)
                .collect(Collectors.toUnmodifiableSet());
        return ingredientNames.stream()
                .filter(name -> {
                    String normalized = normalize(name);
                    return standardRestricted.contains(standardName(normalized))
                            || normalizedRestricted.stream().anyMatch(normalized::contains);
                })
                .toList();
    }

    private static String standardName(String normalizedName) {
        return STANDARD_NAMES.getOrDefault(normalizedName, normalizedName);
    }

    private static String normalize(String value) {
        return value == null ? "" : value.replaceAll("\\s+", "").toLowerCase(Locale.ROOT);
    }
}
