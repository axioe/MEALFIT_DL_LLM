package com.mealfit.domain.search;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;

import com.mealfit.domain.mealplan.model.UserDietProfile;
import com.mealfit.domain.mealplan.service.UserDietProfileProvider;
import com.mealfit.domain.recipe.entity.IngredientStandard;
import com.mealfit.domain.recipe.repository.IngredientStandardRepository;
import com.mealfit.domain.search.dto.SearchResponse;
import com.mealfit.domain.search.dto.SearchType;
import com.mealfit.domain.search.repository.SearchRepository;
import com.mealfit.domain.search.service.SearchService;
import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

/**
 * 웹 통합 검색 서비스 단위 테스트 (JUnit5 + Mockito, Spring·DB 없이 규칙만 검증).
 * 통합 동작은 SearchApiTest(H2)·SearchPostgresIntegrationTest(PostgreSQL)에서 본다.
 */
class SearchServiceTest {

    private SearchRepository searchRepository;
    private IngredientStandardRepository standardRepository;
    private SearchService service;

    private static IngredientStandard standard(String name, String... aliases) {
        IngredientStandard s = mock(IngredientStandard.class);
        given(s.getName()).willReturn(name);
        given(s.getAliases()).willReturn(Set.of(aliases));
        return s;
    }

    @BeforeEach
    void setUp() {
        searchRepository = mock(SearchRepository.class);
        standardRepository = mock(IngredientStandardRepository.class);
        UserDietProfileProvider profiles = mock(UserDietProfileProvider.class);
        given(profiles.getProfile(any())).willReturn(UserDietProfile.empty());
        List<IngredientStandard> standards =
                List.of(standard("달걀", "계란"), standard("다진 마늘", "마늘"), standard("참치 통조림", "참치캔"));
        given(standardRepository.findAllByOrderByIdAsc()).willReturn(standards);
        given(searchRepository.recipeIds(anyLong(), any())).willReturn(Map.of());
        service = new SearchService(searchRepository, standardRepository, profiles);
    }

    @Nested
    @DisplayName("검색어 정리")
    class QueryCleaning {

        @Test
        void 앞뒤_공백을_지우고_연속_공백은_하나로_만든다() {
            SearchResponse res = service.search(1L, "  greek   YOGURT ", Set.of(SearchType.EXERCISE), null, null);
            assertThat(res.query()).isEqualTo("greek YOGURT");
        }

        @ParameterizedTest
        @ValueSource(strings = {"", "   ", "\t\n"})
        void 빈_검색어는_400(String blank) {
            assertThatThrownBy(() -> service.search(1L, blank, null, null, null))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ErrorCode.INVALID_INPUT);
        }

        @Test
        void 검색어는_50자까지_허용하고_51자는_거절한다() {
            service.search(1L, "가".repeat(50), Set.of(SearchType.EXERCISE), null, null);
            assertThatThrownBy(() -> service.search(1L, "가".repeat(51), null, null, null))
                    .isInstanceOf(BusinessException.class);
        }

        @Test
        void null_검색어도_400() {
            assertThatThrownBy(() -> service.search(1L, null, null, null, null)).isInstanceOf(BusinessException.class);
        }
    }

    @Nested
    @DisplayName("재료 별칭 확장")
    class AliasExpansion {

        @Test
        void 별칭으로_찾으면_표준_이름도_함께_찾는다() {
            assertThat(service.search(1L, "계란", Set.of(SearchType.EXERCISE), null, null).terms())
                    .containsExactly("계란", "달걀");
        }

        @Test
        void 표준_이름으로_찾으면_별칭도_함께_찾는다_공백_대소문자_무시() {
            assertThat(service.search(1L, "참치  통조림", Set.of(SearchType.EXERCISE), null, null).terms())
                    .contains("참치 통조림", "참치캔");
        }

        @Test
        void 부분_일치는_확장하지_않는다() {
            // '마늘빵'은 '마늘'과 같지 않으므로 다진 마늘로 넓히지 않는다
            assertThat(service.search(1L, "마늘빵", Set.of(SearchType.EXERCISE), null, null).terms())
                    .containsExactly("마늘빵");
        }
    }

    @Nested
    @DisplayName("LIKE 패턴 이스케이프")
    class LikeEscape {

        @Test
        void 와일드카드_문자는_글자_그대로_찾도록_이스케이프한다() {
            service.search(1L, "50%_할인\\", Set.of(SearchType.EXERCISE), null, null);
            org.mockito.ArgumentCaptor<List<String>> captor = org.mockito.ArgumentCaptor.forClass(List.class);
            verify(searchRepository).countExercises(captor.capture());
            assertThat(captor.getValue()).containsExactly("%50\\%\\_할인\\\\%");
        }

        @Test
        void 공백을_빼고_소문자로_비교한다() {
            service.search(1L, "Greek Yogurt", Set.of(SearchType.EXERCISE), null, null);
            org.mockito.ArgumentCaptor<List<String>> captor = org.mockito.ArgumentCaptor.forClass(List.class);
            verify(searchRepository).countExercises(captor.capture());
            assertThat(captor.getValue()).containsExactly("%greekyogurt%");
        }
    }

    @Nested
    @DisplayName("페이지 범위와 대상 선택")
    class Paging {

        @ParameterizedTest
        @ValueSource(ints = {0, 21, -1})
        void limit은_1부터_20까지만_허용한다(int limit) {
            assertThatThrownBy(() -> service.search(1L, "달걀", null, limit, null)).isInstanceOf(BusinessException.class);
        }

        @Test
        void offset이_음수면_400() {
            assertThatThrownBy(() -> service.search(1L, "달걀", null, 5, -1)).isInstanceOf(BusinessException.class);
        }

        @Test
        void 요청한_대상만_조회하고_나머지는_null() {
            SearchResponse res = service.search(1L, "스쿼트", Set.of(SearchType.EXERCISE), 5, 0);
            assertThat(res.exercises()).isNotNull();
            assertThat(res.recipes()).isNull();
            assertThat(res.inventory()).isNull();
            verify(searchRepository, never()).recipeIds(anyLong(), any());
            verify(searchRepository, never()).lots(anyLong(), any(), anyInt(), anyInt());
        }

        @Test
        void 대상을_생략하면_6개_대상을_모두_조회한다() {
            SearchResponse res = service.search(1L, "달걀", null, null, null);
            assertThat(res.recipes()).isNotNull();
            assertThat(res.inventory()).isNotNull();
            assertThat(res.mealPlans()).isNotNull();
            assertThat(res.shoppingItems()).isNotNull();
            assertThat(res.exercises()).isNotNull();
            assertThat(res.workouts()).isNotNull();
        }
    }
}
