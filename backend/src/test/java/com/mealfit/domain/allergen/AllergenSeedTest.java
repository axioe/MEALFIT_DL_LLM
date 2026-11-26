package com.mealfit.domain.allergen;

import static org.assertj.core.api.Assertions.assertThat;

import com.mealfit.domain.allergen.entity.Allergen;
import com.mealfit.domain.allergen.entity.AllergenCertainty;
import com.mealfit.domain.allergen.entity.AllergenLegalStatus;
import com.mealfit.domain.allergen.entity.IngredientAllergen;
import com.mealfit.domain.allergen.repository.AllergenRepository;
import com.mealfit.domain.allergen.repository.IngredientAllergenRepository;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

/** V13 알레르기 사전 시드가 식약처 기준(현행 19 + 예고 4)과 화면 묶음 규칙대로 들어갔는지 확인한다. */
@SpringBootTest
@ActiveProfiles("test")
@Transactional
class AllergenSeedTest {

    @Autowired
    private AllergenRepository allergenRepository;

    @Autowired
    private IngredientAllergenRepository ingredientAllergenRepository;

    @Test
    void 현행_19종과_개정_예고_4종이_있다() {
        List<Allergen> all = allergenRepository.findAllByOrderByDisplayOrderAsc();

        assertThat(all).hasSize(23);
        assertThat(all).filteredOn(a -> a.getLegalStatus() == AllergenLegalStatus.CURRENT).hasSize(19);
        assertThat(all).filteredOn(a -> a.getLegalStatus() == AllergenLegalStatus.PROPOSED)
                .extracting(Allergen::getName)
                .containsExactlyInAnyOrder("참깨", "들깨", "아몬드", "캐슈너트");
    }

    @Test
    void 카테고리_8개가_순서대로_묶이고_땅콩은_콩류에_있다() {
        List<Allergen> all = allergenRepository.findAllByOrderByDisplayOrderAsc();

        assertThat(all.stream().map(Allergen::getCategory).distinct().toList())
                .containsExactly("알·유제품", "곡류", "콩류", "견과·씨앗", "해산물", "육류", "과일·채소", "첨가물");
        assertThat(allergenRepository.findByCode("PEANUT")).get()
                .extracting(Allergen::getCategory).isEqualTo("콩류");
        assertThat(all).filteredOn(a -> !a.isSelectAll())
                .extracting(Allergen::getCategory)
                .containsOnly("육류", "첨가물");
    }

    @Test
    void 별칭으로_찾을_수_있다() {
        Map<String, String> aliasToName = allergenRepository.findAllByOrderByDisplayOrderAsc().stream()
                .flatMap(a -> a.getAliases().stream().map(alias -> Map.entry(alias, a.getName())))
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));

        assertThat(aliasToName).containsEntry("계란", "알류")
                .containsEntry("굴", "조개류")
                .containsEntry("캐슈넛", "캐슈너트")
                .containsEntry("소고기", "쇠고기");
    }

    @Test
    void 재료는_포함과_확인_필요로_연결된다() {
        Map<String, AllergenCertainty> soySauce = ingredientAllergenRepository
                .findByIdIngredientNameIn(List.of("간장")).stream()
                .collect(Collectors.toMap(ia -> ia.getAllergen().getName(), IngredientAllergen::getCertainty));
        assertThat(soySauce).containsExactlyInAnyOrderEntriesOf(Map.of(
                "대두", AllergenCertainty.CONTAINS,
                "밀", AllergenCertainty.MAY_CONTAIN));

        assertThat(ingredientAllergenRepository.findByIdIngredientNameIn(List.of("참기름", "들기름")))
                .extracting(ia -> ia.getIngredientName() + "→" + ia.getAllergen().getName() + ":" + ia.getCertainty())
                .containsExactlyInAnyOrder("참기름→참깨:CONTAINS", "들기름→들깨:CONTAINS");

        assertThat(ingredientAllergenRepository.findByIdIngredientNameIn(List.of("양파", "올리브유"))).isEmpty();
    }
}
