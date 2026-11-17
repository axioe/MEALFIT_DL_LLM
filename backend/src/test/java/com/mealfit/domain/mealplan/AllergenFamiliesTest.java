package com.mealfit.domain.mealplan;

import static org.assertj.core.api.Assertions.assertThat;

import com.mealfit.domain.mealplan.model.IngredientRestriction;
import com.mealfit.domain.mealplan.model.UserDietProfile;
import java.util.List;
import java.util.Set;
import org.junit.jupiter.api.Test;

/** 알레르기는 이름이 다른 동의어·가공식품까지 막는다 (D09 확정 전 임시 확장표) */
class AllergenFamiliesTest {

    private static List<String> violations(Set<String> allergies, Set<String> excluded, String... ingredients) {
        UserDietProfile profile = new UserDietProfile(null, null, null, allergies, excluded);
        return IngredientRestriction.violations(List.of(ingredients), profile.restrictedIngredients());
    }

    @Test
    void 우유_알레르기는_치즈_버터_생크림_요거트도_막는다() {
        assertThat(violations(Set.of("우유"), Set.of(), "모짜렐라 치즈", "버터", "생크림", "플레인 요거트", "두부"))
                .containsExactly("모짜렐라 치즈", "버터", "생크림", "플레인 요거트");
    }

    @Test
    void 달걀과_계란은_서로_동의어이고_마요네즈도_막는다() {
        assertThat(violations(Set.of("달걀"), Set.of(), "계란", "메추리알", "마요네즈", "감자"))
                .containsExactly("계란", "메추리알", "마요네즈");
        assertThat(violations(Set.of("계란"), Set.of(), "달걀")).containsExactly("달걀");
    }

    @Test
    void 밀_알레르기는_빵_국수_부침가루도_막는다() {
        assertThat(violations(Set.of("밀"), Set.of(), "식빵", "소면 국수", "부침가루", "쌀"))
                .containsExactly("식빵", "소면 국수", "부침가루");
    }

    @Test
    void 조개류는_굴소스와_홍합도_막는다() {
        assertThat(violations(Set.of("조개류"), Set.of(), "굴소스", "홍합", "연어"))
                .containsExactly("굴소스", "홍합");
    }

    @Test
    void 표에_없는_재료는_기존처럼_이름_포함으로만_막는다() {
        assertThat(violations(Set.of("키위"), Set.of(), "골드키위", "사과")).containsExactly("골드키위");
        assertThat(violations(Set.of("땅콩"), Set.of(), "땅콩버터", "피넛소스")).containsExactly("땅콩버터", "피넛소스");
    }

    @Test
    void 제외_재료는_넓히지_않는다() {
        // 취향으로 뺀 우유는 우유만 막고 치즈는 허용한다
        assertThat(violations(Set.of(), Set.of("우유"), "우유", "치즈")).containsExactly("우유");
    }
}
