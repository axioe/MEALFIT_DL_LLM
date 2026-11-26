package com.mealfit.domain.recipe;

import static org.assertj.core.api.Assertions.assertThat;

import com.mealfit.domain.recipe.entity.IngredientStandard;
import com.mealfit.domain.recipe.entity.IngredientStandard.OwnershipRule;
import com.mealfit.domain.recipe.repository.IngredientStandardRepository;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

/** V15 검수 레시피·재료 기준표 시드가 정제 결과대로 들어갔는지 확인한다. */
@SpringBootTest
@ActiveProfiles("test")
@Transactional
class CuratedRecipeSeedTest {

    @Autowired JdbcTemplate jdbc;
    @Autowired IngredientStandardRepository standardRepository;

    private long count(String sql, Object... args) {
        return jdbc.queryForObject(sql, Long.class, args);
    }

    @Test
    void 검수_레시피_2481개가_끼니별로_들어간다() {
        assertThat(count("select count(*) from recipes where source = 'SEED' and recipe_code is not null")).isEqualTo(2481);
        assertThat(count("select count(*) from recipes where recipe_code is not null and meal_slot = 'BREAKFAST'")).isEqualTo(551);
        assertThat(count("select count(*) from recipes where recipe_code is not null and meal_slot = 'LUNCH_DINNER'")).isEqualTo(1930);
        assertThat(count("select count(*) from recipes where recipe_code like 'Q%'")).isEqualTo(91);
    }

    @Test
    void 모든_레시피에_재료와_단계가_있고_이름은_겹치지_않는다() {
        assertThat(count("""
                select count(*) from recipes r where r.recipe_code is not null
                and (not exists (select 1 from recipe_ingredients i where i.recipe_id = r.id)
                  or not exists (select 1 from recipe_steps s where s.recipe_id = r.id))""")).isZero();
        assertThat(count("select count(*) from recipe_ingredients i join recipes r on r.id = i.recipe_id where r.recipe_code is not null"))
                .isEqualTo(17210);
        assertThat(count("select count(*) from recipe_steps s join recipes r on r.id = s.recipe_id where r.recipe_code is not null"))
                .isEqualTo(12333);
        assertThat(count("select count(distinct name) from recipes where recipe_code is not null")).isEqualTo(2481);
    }

    @Test
    void 레시피_재료는_모두_재료_기준표에_있다() {
        assertThat(jdbc.queryForList("""
                select distinct i.ingredient_name from recipe_ingredients i join recipes r on r.id = i.recipe_id
                where r.recipe_code is not null
                and i.ingredient_name not in (select name from ingredient_standards)""", String.class)).isEmpty();
    }

    @Test
    void 문장은_명사형이고_알레르기_열_없이_재료로_판단한다() {
        assertThat(count("select count(*) from recipe_steps s join recipes r on r.id = s.recipe_id "
                + "where r.recipe_code is not null and (s.description like '%다.' or s.description like '%요.')")).isZero();
        assertThat(count("select count(*) from ingredient_allergens where ingredient_name = '참기름'")).isEqualTo(1);
    }

    @Test
    void 기존_로컬_대체_레시피_9개는_그대로다() {
        assertThat(count("select count(*) from recipes where source = 'LOCAL_FALLBACK'")).isEqualTo(9);
        assertThat(count("select count(*) from recipes where source = 'LOCAL_FALLBACK' and meal_slot is not null")).isZero();
    }

    @Test
    void 재료_기준표는_59종이고_보유_규칙과_별칭이_있다() {
        List<IngredientStandard> all = standardRepository.findAllByOrderByIdAsc();
        assertThat(all).hasSize(59);
        Map<OwnershipRule, Long> byRule = all.stream()
                .collect(Collectors.groupingBy(IngredientStandard::getOwnershipRule, Collectors.counting()));
        assertThat(byRule).containsEntry(OwnershipRule.REQUIRED, 44L)
                .containsEntry(OwnershipRule.OPTIONAL, 10L)
                .containsEntry(OwnershipRule.EXCLUDED, 5L);
        assertThat(all).filteredOn(s -> s.getOwnershipRule() == OwnershipRule.EXCLUDED)
                .extracting(IngredientStandard::getName)
                .containsExactlyInAnyOrder("올리브유", "간장", "소금", "후추", "물");
        assertThat(all).filteredOn(s -> "밥".equals(s.getSubstituteGroup()))
                .extracting(IngredientStandard::getName)
                .containsExactlyInAnyOrder("현미밥", "잡곡밥", "보리밥");

        Map<String, String> aliasToName = all.stream()
                .flatMap(s -> s.getAliases().stream().map(a -> Map.entry(a, s.getName())))
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));
        assertThat(aliasToName).containsEntry("참치캔", "참치 통조림")
                .containsEntry("계란", "달걀")
                .containsEntry("마늘", "다진 마늘");
        assertThat(Set.copyOf(aliasToName.values())).allMatch(name ->
                all.stream().anyMatch(s -> s.getName().equals(name)));
    }
}
