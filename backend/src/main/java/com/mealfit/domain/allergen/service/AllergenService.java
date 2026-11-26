package com.mealfit.domain.allergen.service;

import com.mealfit.domain.allergen.dto.AllergenCatalogResponse;
import com.mealfit.domain.allergen.dto.AllergenSearchResult;
import com.mealfit.domain.allergen.dto.AllergenSearchResult.MatchType;
import com.mealfit.domain.allergen.dto.MyAllergiesRequest;
import com.mealfit.domain.allergen.dto.MyAllergiesResponse;
import com.mealfit.domain.allergen.entity.Allergen;
import com.mealfit.domain.allergen.entity.IngredientAllergen;
import com.mealfit.domain.allergen.repository.AllergenRepository;
import com.mealfit.domain.allergen.repository.IngredientAllergenRepository;
import com.mealfit.domain.user.entity.Profile;
import com.mealfit.domain.user.repository.ProfileRepository;
import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 알레르기 목록·검색과 내 알레르기 저장 (MEALFIT-139).
 *
 * <p>저장은 기존 프로필 알레르기(텍스트)를 그대로 쓴다. 목록에서 고른 항목은 고시 이름(예: "알류")으로,
 * 목록에 없는 직접 입력은 입력한 글자 그대로 넣는다. 기존 차단 로직(AllergenFamilies·IngredientRestriction)이
 * 그대로 동작하도록 하기 위해서다. 직접 입력이 이름·별칭과 같으면(예: "계란") 고시 이름으로 바꿔 저장한다.
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AllergenService {

    static final int SEARCH_LIMIT = 10;

    private final AllergenRepository allergenRepository;
    private final IngredientAllergenRepository ingredientAllergenRepository;
    private final ProfileRepository profileRepository;

    public AllergenCatalogResponse catalog() {
        return AllergenCatalogResponse.from(allergenRepository.findAllByOrderByDisplayOrderAsc());
    }

    /** 이름 → 별칭 → 재료 순으로, 완전 일치를 부분 일치보다 앞에 둔다. 같은 알레르기는 한 번만 보여 준다. */
    public List<AllergenSearchResult> search(String query) {
        String q = normalize(query);
        if (q.isEmpty()) {
            return List.of();
        }
        List<Allergen> all = allergenRepository.findAllByOrderByDisplayOrderAsc();
        Map<String, Ranked> best = new LinkedHashMap<>();
        for (Allergen allergen : all) {
            rank(q, allergen.getName()).ifPresent(r ->
                    keep(best, allergen, r, MatchType.NAME, allergen.getName(), null));
            for (String alias : allergen.getAliases()) {
                rank(q, alias).ifPresent(r -> keep(best, allergen, 10 + r, MatchType.ALIAS, alias, null));
            }
        }
        for (IngredientAllergen link : ingredientAllergenRepository.findAll()) {
            rank(q, link.getIngredientName()).ifPresent(r -> keep(best, link.getAllergen(), 20 + r,
                    MatchType.INGREDIENT, link.getIngredientName(), link.getCertainty()));
        }
        return best.values().stream()
                .sorted(Comparator.comparingInt(Ranked::score).thenComparingInt(Ranked::displayOrder))
                .limit(SEARCH_LIMIT)
                .map(Ranked::result)
                .toList();
    }

    public MyAllergiesResponse myAllergies(Long userId) {
        return toResponse(profile(userId, false).getAllergies());
    }

    @Transactional
    public MyAllergiesResponse replaceMyAllergies(Long userId, MyAllergiesRequest request) {
        Map<String, Allergen> byCode = allergenRepository.findAllByOrderByDisplayOrderAsc().stream()
                .collect(Collectors.toMap(Allergen::getCode, Function.identity()));
        Set<String> unknown = request.codes().stream().filter(code -> !byCode.containsKey(code))
                .collect(Collectors.toCollection(java.util.TreeSet::new));
        if (!unknown.isEmpty()) {
            throw new BusinessException(ErrorCode.INVALID_INPUT, "알 수 없는 알레르기 코드입니다: " + String.join(", ", unknown));
        }
        Map<String, Allergen> byNameOrAlias = indexByNameOrAlias(byCode.values());
        Set<String> names = new LinkedHashSet<>();
        request.codes().forEach(code -> names.add(byCode.get(code).getName()));
        for (String raw : request.custom()) {
            String text = raw.strip();
            Allergen known = byNameOrAlias.get(normalize(text));
            names.add(known != null ? known.getName() : text);
        }
        if (names.size() > 50) {
            throw new BusinessException(ErrorCode.INVALID_INPUT, "알레르기는 50개까지 등록할 수 있습니다.");
        }
        Profile profile = profile(userId, true);
        profile.replaceAllergies(names);
        return toResponse(names);
    }

    private MyAllergiesResponse toResponse(Set<String> stored) {
        List<Allergen> all = allergenRepository.findAllByOrderByDisplayOrderAsc();
        Map<String, Allergen> byNameOrAlias = indexByNameOrAlias(all);
        Set<Allergen> selected = new LinkedHashSet<>();
        List<String> custom = new java.util.ArrayList<>();
        for (String name : stored) {
            Allergen known = byNameOrAlias.get(normalize(name));
            if (known != null) {
                selected.add(known);
            } else {
                custom.add(name);
            }
        }
        return new MyAllergiesResponse(
                selected.stream().sorted(Comparator.comparingInt(Allergen::getDisplayOrder))
                        .map(a -> new MyAllergiesResponse.Selected(a.getCode(), a.getName(), a.getCategory()))
                        .toList(),
                custom.stream().sorted().toList());
    }

    private Profile profile(Long userId, boolean lock) {
        return (lock ? profileRepository.findByUserIdForUpdate(userId) : profileRepository.findByUserId(userId))
                .orElseThrow(() -> new BusinessException(ErrorCode.UNAUTHORIZED));
    }

    private static Map<String, Allergen> indexByNameOrAlias(Iterable<Allergen> allergens) {
        Map<String, Allergen> index = new java.util.HashMap<>();
        for (Allergen allergen : allergens) {
            index.put(normalize(allergen.getName()), allergen);
            allergen.getAliases().forEach(alias -> index.put(normalize(alias), allergen));
        }
        return index;
    }

    /** 0 = 완전 일치, 1 = 앞부분 일치, 2 = 포함 */
    private static Optional<Integer> rank(String q, String candidate) {
        String c = normalize(candidate);
        if (c.equals(q)) return Optional.of(0);
        if (c.startsWith(q)) return Optional.of(1);
        if (c.contains(q)) return Optional.of(2);
        return Optional.empty();
    }

    private static void keep(Map<String, Ranked> best, Allergen allergen, int score, MatchType type,
                             String text, com.mealfit.domain.allergen.entity.AllergenCertainty certainty) {
        Ranked current = best.get(allergen.getCode());
        if (current == null || score < current.score()) {
            best.put(allergen.getCode(), new Ranked(score, allergen.getDisplayOrder(), new AllergenSearchResult(
                    allergen.getCode(), allergen.getName(), allergen.getCategory(), type, text, certainty)));
        }
    }

    private static String normalize(String value) {
        return value == null ? "" : value.replaceAll("\\s+", "").toLowerCase(Locale.ROOT);
    }

    private record Ranked(int score, int displayOrder, AllergenSearchResult result) {
    }
}
