package com.mealfit.integration;

import static org.assertj.core.api.Assertions.assertThat;

import java.math.BigDecimal;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.EnabledIfEnvironmentVariable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;

/**
 * 실제 PostgreSQL에서 Flyway(db/migration/postgresql)와 JPA 엔티티(ddl-auto: validate)가 맞는지 확인한다.
 * 평소 테스트는 H2(PostgreSQL 모드)로 돌고, 이 테스트는 PG_TEST_URL이 있을 때만 돈다.
 * CI의 backend 작업이 PostgreSQL 서비스 컨테이너를 띄워 PG_TEST_URL을 넣어 준다.
 */
@SpringBootTest
@ActiveProfiles("test")
@EnabledIfEnvironmentVariable(named = "PG_TEST_URL", matches = ".+")
class PostgresSchemaIntegrationTest {

    @DynamicPropertySource
    static void postgres(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", () -> System.getenv("PG_TEST_URL"));
        registry.add("spring.datasource.username", () -> System.getenv().getOrDefault("PG_TEST_USERNAME", "mealfit"));
        registry.add("spring.datasource.password", () -> System.getenv().getOrDefault("PG_TEST_PASSWORD", "mealfit"));
        registry.add("spring.datasource.driver-class-name", () -> "org.postgresql.Driver");
    }

    @Autowired
    private JdbcTemplate jdbc;

    @Test
    void 마이그레이션이_모두_적용되고_엔티티와_맞는다() {
        Integer applied = jdbc.queryForObject(
                "select count(*) from flyway_schema_history where success = true and version is not null", Integer.class);
        assertThat(applied).isGreaterThanOrEqualTo(7);
        assertThat(jdbc.queryForObject("select version()", String.class)).startsWith("PostgreSQL");
    }

    @Test
    void 로컬_대체_레시피_시드가_들어가_있다() {
        Integer seeded = jdbc.queryForObject(
                "select count(*) from recipes where source = 'LOCAL_FALLBACK' and user_id is null", Integer.class);
        assertThat(seeded).isEqualTo(9);
    }

    @Test
    void 수량_컬럼은_NUMERIC_12_3이다() {
        String type = jdbc.queryForObject("""
                select data_type || '(' || numeric_precision || ',' || numeric_scale || ')'
                from information_schema.columns
                where table_name = 'inventory_lots' and column_name = 'quantity'
                """, String.class);
        assertThat(type).isEqualTo("numeric(12,3)");
        BigDecimal sum = jdbc.queryForObject("select cast(0.1 as numeric(12, 3)) + cast(0.2 as numeric(12, 3))", BigDecimal.class);
        assertThat(sum).isEqualByComparingTo("0.300");
    }
}
