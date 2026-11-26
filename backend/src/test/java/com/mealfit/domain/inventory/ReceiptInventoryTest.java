package com.mealfit.domain.inventory;

import com.mealfit.domain.inventory.dto.*;
import com.mealfit.domain.inventory.entity.StorageLocation;
import com.mealfit.domain.inventory.service.InventoryBatchService;
import com.mealfit.support.TestUserFixture;
import com.mealfit.support.TestJwt;
import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.*;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.web.servlet.MockMvc;
import static org.assertj.core.api.Assertions.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class ReceiptInventoryTest {
    @Autowired InventoryBatchService batches;
    @Autowired com.mealfit.domain.inventory.service.InventoryService inventoryService;
    @Autowired JdbcTemplate jdbc;
    @Autowired MockMvc mvc;
    TestUserFixture fixture;
    static final long USER = 88110;

    // H2에서만 테스트 회원을 만들고 실제 DB는 사용하지 않음
    @BeforeEach void setup() { fixture = TestUserFixture.create(jdbc, USER); }

    // 이번 테스트 회원의 자료만 정리함
    @AfterEach void cleanup() {
        jdbc.update("delete from inventory_batch_requests where user_id=?", USER);
        jdbc.update("delete from inventory_transactions where user_id=?", USER);
        jdbc.update("delete from inventory_lots where user_id=?", USER);
        fixture.close();
    }

    // 기존 단건 입고 계약으로 확인 품목을 생성함
    StockInRequest item(String name) {
        return new StockInRequest(name, new BigDecimal("2"), "개", null, StorageLocation.FRIDGE, BigDecimal.ZERO, null);
    }

    // 같은 키 재전송은 최초 로트와 이력을 그대로 유지함
    @Test void replayReturnsSameLots() {
        var request = new BatchStockInRequest(UUID.randomUUID().toString(), List.of(item("당근"), item("양파")));
        var first = batches.stockIn(USER, request);
        assertThat(batches.stockIn(USER, request)).isEqualTo(first);
        assertThat(jdbc.queryForObject("select count(*) from inventory_lots where user_id=?", Integer.class, USER)).isEqualTo(2);
        assertThat(jdbc.queryForObject("select count(*) from inventory_transactions where user_id=?", Integer.class, USER)).isEqualTo(2);
    }

    // 사용자 확정 상품 정보·수량·위치·메모가 H2에 저장되고 재조회됨
    @Test void confirmedProductSurvivesReadAndReplay() {
        String memo = "@mealfit-product:v1:[\"불닭볶음면 치즈맛\",\"직접 입력한 메모\"]";
        var item = new StockInRequest("라면", new BigDecimal("10"), "개", java.time.LocalDate.of(2027, 1, 1),
                StorageLocation.PANTRY, BigDecimal.ONE, memo);
        var request = new BatchStockInRequest(UUID.randomUUID().toString(), List.of(item));
        var first = batches.stockIn(USER, request);
        assertThat(first.lots().getFirst().ingredientName()).isEqualTo("라면");
        assertThat(first.lots().getFirst().memo()).isEqualTo(memo);
        assertThat(first.lots().getFirst().quantity()).isEqualByComparingTo("10");
        assertThat(batches.stockIn(USER, request)).isEqualTo(first);
        assertThat(jdbc.queryForObject("select memo from inventory_lots where id=? and user_id=?", String.class,
                first.lots().getFirst().id(), USER)).isEqualTo(memo);
        var inventory = inventoryService.getInventory(USER);
        assertThat(inventory.groups().getFirst().lots().getFirst().memo()).isEqualTo(memo);
        assertThat(jdbc.queryForObject("select count(*) from inventory_transactions where user_id=?", Integer.class, USER)).isEqualTo(1);
    }

    // 동일 키의 다른 내용은 새 입고로 처리하지 않음
    @Test void changedPayloadIsRejected() {
        String key = UUID.randomUUID().toString();
        batches.stockIn(USER, new BatchStockInRequest(key, List.of(item("당근"))));
        assertThatThrownBy(() -> batches.stockIn(USER, new BatchStockInRequest(key, List.of(item("양파"))))).isInstanceOf(com.mealfit.global.exception.BusinessException.class);
        assertThat(jdbc.queryForObject("select count(*) from inventory_lots where user_id=?", Integer.class, USER)).isEqualTo(1);
    }

    // 두 번째 품목의 DB 저장 실패 시 첫 품목과 이력도 함께 롤백함
    @Test void partialFailureRollsBackEverything() {
        var request = new BatchStockInRequest(UUID.randomUUID().toString(), List.of(item("당근"), item("가".repeat(101))));
        assertThatThrownBy(() -> batches.stockIn(USER, request)).isInstanceOf(RuntimeException.class);
        assertThat(jdbc.queryForObject("select count(*) from inventory_lots where user_id=?", Integer.class, USER)).isZero();
        assertThat(jdbc.queryForObject("select count(*) from inventory_transactions where user_id=?", Integer.class, USER)).isZero();
        assertThat(jdbc.queryForObject("select count(*) from inventory_batch_requests where user_id=?", Integer.class, USER)).isZero();
    }

    // 동시 재전송도 사용자 잠금 뒤 최초 결과 하나만 반환함
    @Test void concurrentReplayCreatesOnce() throws Exception {
        var request = new BatchStockInRequest(UUID.randomUUID().toString(), List.of(item("당근")));
        try (var pool = Executors.newFixedThreadPool(2)) {
            var start = new CountDownLatch(1);
            Callable<BatchStockInResponse> call = () -> { start.await(); return batches.stockIn(USER, request); };
            var a = pool.submit(call); var b = pool.submit(call); start.countDown();
            assertThat(a.get(20, TimeUnit.SECONDS)).isEqualTo(b.get(20, TimeUnit.SECONDS));
        }
        assertThat(jdbc.queryForObject("select count(*) from inventory_lots where user_id=?", Integer.class, USER)).isEqualTo(1);
    }

    // 다른 사용자의 같은 키는 최초 사용자의 결과를 노출하지 않음
    @Test void usersHaveIndependentKeys() {
        long other = 88112L;
        var otherFixture = TestUserFixture.create(jdbc, other);
        try {
            String key = UUID.randomUUID().toString();
            var a = batches.stockIn(USER, new BatchStockInRequest(key, List.of(item("당근"))));
            var b = batches.stockIn(other, new BatchStockInRequest(key, List.of(item("양파"))));
            assertThat(b.lots().getFirst().id()).isNotEqualTo(a.lots().getFirst().id());
            assertThat(b.lots().getFirst().ingredientName()).isEqualTo("양파");
        } finally {
            jdbc.update("delete from inventory_batch_requests where user_id=?", other);
            jdbc.update("delete from inventory_transactions where user_id=?", other);
            jdbc.update("delete from inventory_lots where user_id=?", other);
            otherFixture.close();
        }
    }

    // 인증되지 않은 분석과 입고 요청을 차단함
    @Test void authenticationRequired() throws Exception {
        mvc.perform(post("/api/v1/inventory/lots/batch").contentType("application/json").content("{}"))
            .andExpect(status().isUnauthorized());
        mvc.perform(multipart("/api/v1/inventory/recognitions/receipt")).andExpect(status().isUnauthorized());
    }

    // 잘못된 수량은 저장 전에 거부함
    @Test void invalidQuantityRejected() throws Exception {
        mvc.perform(post("/api/v1/inventory/lots/batch").with(TestJwt.user(USER)).contentType("application/json")
            .content(new com.fasterxml.jackson.databind.ObjectMapper().writeValueAsString(java.util.Map.of(
                "clientRequestId", UUID.randomUUID().toString(), "items", List.of(java.util.Map.of(
                    "ingredientName", "당근", "quantity", 0, "unit", "개", "storageLocation", "FRIDGE"))))))
            .andExpect(status().isBadRequest());
    }
}
