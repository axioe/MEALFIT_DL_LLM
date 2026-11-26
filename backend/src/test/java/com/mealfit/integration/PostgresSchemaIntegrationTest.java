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
        assertThat(applied).isGreaterThanOrEqualTo(8); // V1–V7 + V8(pgvector, db/vendor/postgresql)
        assertThat(jdbc.queryForObject("select version()", String.class)).startsWith("PostgreSQL");
    }

    @Test
    void 로컬_대체_레시피_시드가_들어가_있다() {
        // V2 기본 레시피 9개 + V15 검수 레시피 2,481개(V16에서 로컬 대체로 사용)
        Integer seeded = jdbc.queryForObject(
                "select count(*) from recipes where source = 'LOCAL_FALLBACK' and user_id is null and recipe_code is null",
                Integer.class);
        assertThat(seeded).isEqualTo(9);
        Integer curated = jdbc.queryForObject(
                "select count(*) from recipes where source = 'LOCAL_FALLBACK' and user_id is null and recipe_code is not null",
                Integer.class);
        assertThat(curated).isEqualTo(2481);
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

    @Test
    void 레시피_임베딩은_pgvector_1024차원과_HNSW_코사인_인덱스를_쓴다() {
        assertThat(jdbc.queryForObject(
                "select count(*) from pg_extension where extname = 'vector'", Integer.class)).isEqualTo(1);
        assertThat(jdbc.queryForObject("""
                select format_type(atttypid, atttypmod) from pg_attribute
                where attrelid = 'recipe_embeddings'::regclass and attname = 'embedding'
                """, String.class)).isEqualTo("vector(1024)");
        assertThat(jdbc.queryForObject(
                "select indexdef from pg_indexes where indexname = 'idx_recipe_embeddings_hnsw'", String.class))
                .contains("hnsw").contains("vector_cosine_ops");
    }

    @Test
    void 코사인_거리로_가까운_레시피부터_찾고_레시피를_지우면_임베딩도_지워진다() {
        Long near = jdbc.queryForObject("""
                insert into recipes (user_id, name, serving_size, cook_time_min, nutrition_estimated, source, created_at, updated_at)
                values (null, '임베딩 검사 A', 1, 10, true, 'SEED', current_timestamp, current_timestamp) returning id
                """, Long.class);
        Long far = jdbc.queryForObject("""
                insert into recipes (user_id, name, serving_size, cook_time_min, nutrition_estimated, source, created_at, updated_at)
                values (null, '임베딩 검사 B', 1, 10, true, 'SEED', current_timestamp, current_timestamp) returning id
                """, Long.class);
        try {
            // A는 첫 축, B는 둘째 축 방향의 단위 벡터. 질의는 첫 축이므로 A가 거리 0으로 먼저 나와야 한다
            String insert = """
                    insert into recipe_embeddings (recipe_id, model_version, content_hash, embedding, created_at, updated_at)
                    values (?, 'bge-m3@test', repeat('0', 64), cast(? as vector), current_timestamp, current_timestamp)
                    """;
            jdbc.update(insert, near, unitVector(0));
            jdbc.update(insert, far, unitVector(1));

            Long nearest = jdbc.queryForObject("""
                    select recipe_id from recipe_embeddings
                    where recipe_id in (?, ?)
                    order by embedding <=> cast(? as vector) limit 1
                    """, Long.class, near, far, unitVector(0));
            assertThat(nearest).isEqualTo(near);
        } finally {
            jdbc.update("delete from recipes where id in (?, ?)", near, far);
        }
        assertThat(jdbc.queryForObject(
                "select count(*) from recipe_embeddings where recipe_id in (?, ?)", Integer.class, near, far)).isZero();
    }

    /** 1024차원 단위 벡터를 pgvector 텍스트 형식([..])으로 만든다. */
    private static String unitVector(int axis) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < 1024; i++) {
            if (i > 0) {
                sb.append(',');
            }
            sb.append(i == axis ? '1' : '0');
        }
        return sb.append(']').toString();
    }
}
