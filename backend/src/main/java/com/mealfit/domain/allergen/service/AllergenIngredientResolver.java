package com.mealfit.domain.allergen.service;

import com.mealfit.domain.allergen.entity.Allergen;
import com.mealfit.domain.allergen.entity.IngredientAllergen;
import com.mealfit.domain.allergen.repository.AllergenRepository;
import com.mealfit.domain.allergen.repository.IngredientAllergenRepository;
import java.util.Collection;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

/**
 * 회원 알레르기(텍스트)를 V13 알레르기 사전과 재료 연결표로 해석한다 (MEALFIT-140).
 *
 * <p>사전에 있는 알레르기(이름·별칭)는 연결된 재료를 모두 찾는다. 포함(CONTAINS)과 확인 필요(MAY_CONTAIN)를
 * 함께 돌려주므로, 확인 필요 재료가 든 레시피도 제외된다(결정: 확인 필요는 기본 제외).
 * 사전에 없는 직접 입력(예: 키위)은 여기서 다루지 않고 기존 이름 포함 검사가 맡는다.
 */
@Component
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AllergenIngredientResolver {

    private final AllergenRepository allergenRepository;
    private final IngredientAllergenRepository ingredientAllergenRepository;

    /** 알레르기 이름·별칭 → 사전 항목. 사전에 없으면 빈 값 */
    public Map<String, Allergen> recognize(Collection<String> allergies) {
        Map<String, Allergen> index = new HashMap<>();
        for (Allergen allergen : allergenRepository.findAllByOrderByDisplayOrderAsc()) {
            index.put(normalize(allergen.getName()), allergen);
            allergen.getAliases().forEach(alias -> index.put(normalize(alias), allergen));
        }
        Map<String, Allergen> recognized = new HashMap<>();
        for (String allergy : allergies) {
            Optional.ofNullable(index.get(normalize(allergy))).ifPresent(a -> recognized.put(allergy, a));
        }
        return recognized;
    }

    /** 회원 알레르기에 연결된 재료 이름(포함 + 확인 필요) */
    public Set<String> linkedIngredients(Collection<String> allergies) {
        Set<Long> allergenIds = new java.util.HashSet<>();
        recognize(allergies).values().forEach(a -> allergenIds.add(a.getId()));
        if (allergenIds.isEmpty()) {
            return Set.of();
        }
        Set<String> names = new LinkedHashSet<>();
        for (IngredientAllergen link : ingredientAllergenRepository.findByIdAllergenIdIn(allergenIds)) {
            names.add(link.getIngredientName());
        }
        return names;
    }

    /** 레시피 재료 중 회원 알레르기와 연결된 것 (안내용) */
    public List<IngredientAllergen> linksFor(Collection<String> ingredientNames, Collection<String> allergies) {
        Set<Long> allergenIds = new java.util.HashSet<>();
        recognize(allergies).values().forEach(a -> allergenIds.add(a.getId()));
        if (allergenIds.isEmpty() || ingredientNames.isEmpty()) {
            return List.of();
        }
        return ingredientAllergenRepository.findByIdIngredientNameIn(ingredientNames).stream()
                .filter(link -> allergenIds.contains(link.getAllergen().getId()))
                .toList();
    }

    static String normalize(String value) {
        return value == null ? "" : value.replaceAll("\\s+", "").toLowerCase(Locale.ROOT);
    }
}
