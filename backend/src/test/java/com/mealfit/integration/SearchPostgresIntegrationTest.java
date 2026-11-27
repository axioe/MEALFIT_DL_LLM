package com.mealfit.integration;

import static org.assertj.core.api.Assertions.assertThat;

import com.mealfit.domain.search.dto.SearchResponse;
import com.mealfit.domain.search.service.SearchService;
import com.mealfit.support.TestUserFixture;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.EnabledIfEnvironmentVariable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.springframework.transaction.annotation.Transactional;

/**
 * 통합 검색 쿼리(replace·lower·LIKE ESCAPE·정렬)가 실제 PostgreSQL에서도 도는지 확인한다.
 * PG_TEST_URL이 있을 때만 돈다 (CI backend 작업). 데이터는 테스트 끝에 롤백된다.
 */
@SpringBootTest
@ActiveProfiles("test")
@Transactional
@EnabledIfEnvironmentVariable(named = "PG_TEST_URL", matches = ".+")
class SearchPostgresIntegrationTest {

    private static final long USER = 86101L;

    @DynamicPropertySource
    static void postgres(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", () -> System.getenv("PG_TEST_URL"));
        registry.add("spring.datasource.username", () -> System.getenv().getOrDefault("PG_TEST_USERNAME", "mealfit"));
        registry.add("spring.datasource.password", () -> System.getenv().getOrDefault("PG_TEST_PASSWORD", "mealfit"));
        registry.add("spring.datasource.driver-class-name", () -> "org.postgresql.Driver");
    }

    @Autowired SearchService searchService;
    @Autowired JdbcTemplate jdbc;

    @Test
    void 모든_대상을_PostgreSQL에서_검색한다() {
        TestUserFixture.create(jdbc, USER);
        jdbc.update("""
                insert into inventory_lots (user_id, ingredient_name, quantity, unit, storage_location,
                    status, created_at, updated_at)
                values (?, '방울 토마토', 2, '개', 'FRIDGE', 'ACTIVE', current_timestamp, current_timestamp),
                       (?, '달걀', 2, '개', 'FRIDGE', 'ACTIVE', current_timestamp, current_timestamp)
                """, USER, USER);
        jdbc.update("""
                insert into shopping_items (user_id, ingredient_name, required_qty, unit, status, created_at, updated_at)
                values (?, '계란', 1, '개', 'NEEDED', current_timestamp, current_timestamp)
                """, USER);

        SearchResponse egg = searchService.search(USER, "계란", null, 5, 0);
        assertThat(egg.terms()).contains("달걀");
        assertThat(egg.recipes().total()).isPositive();
        assertThat(egg.inventory().total()).isEqualTo(1);
        assertThat(egg.shoppingItems().total()).isEqualTo(1);
        assertThat(egg.mealPlans().total()).isZero();
        assertThat(egg.workouts().total()).isZero();

        assertThat(searchService.search(USER, "방울토마토", null, 5, 0).inventory().total()).isEqualTo(1);
        assertThat(searchService.search(USER, "스쿼트", null, 5, 0).exercises().total()).isGreaterThan(3);
        assertThat(searchService.search(USER, "%", null, 5, 0).inventory().total()).isZero();
    }
}
