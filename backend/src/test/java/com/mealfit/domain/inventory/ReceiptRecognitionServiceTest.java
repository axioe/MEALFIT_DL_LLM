package com.mealfit.domain.inventory;

import com.mealfit.domain.inventory.service.ReceiptRecognitionService;
import com.mealfit.global.exception.BusinessException;
import java.io.ByteArrayOutputStream;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import org.junit.jupiter.api.*;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.springframework.http.*;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.web.client.RestClient;
import static org.assertj.core.api.Assertions.*;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.*;
import static org.springframework.test.web.client.response.MockRestResponseCreators.*;

class ReceiptRecognitionServiceTest {
    MockRestServiceServer server;
    ReceiptRecognitionService service;
    static final String RESPONSE = """
      {"modelVersion":"receipt-test","status":"SUCCESS","purchaseDate":"2026-11-26","items":[
        {"productName":"당근","ingredientName":"당근","quantity":"2","unit":"개","price":"2000",
         "textConfidence":0.9,"parsingStatus":"CHECK_REQUIRED","requiresConfirmation":true,"mappingStatus":"UNMAPPED"}],
       "warnings":[],"elapsedMs":100}
      """;

    // Flask 통신만 대체하고 실제 이미지 검증 코드를 사용함
    @BeforeEach void setup() {
        var builder = RestClient.builder().baseUrl("http://receipt.test");
        server = MockRestServiceServer.bindTo(builder).build();
        service = new ReceiptRecognitionService(builder.build());
    }

    // 개인정보가 없는 가상 이미지를 메모리에 만듦
    MockMultipartFile image() throws Exception {
        var bytes = new ByteArrayOutputStream();
        ImageIO.write(new BufferedImage(20, 30, BufferedImage.TYPE_INT_RGB), "png", bytes);
        return new MockMultipartFile("image", "private-name.png", "image/png", bytes.toByteArray());
    }

    // 분석 요청에는 사용자 식별 정보와 원본 파일명이 포함되지 않음
    @Test void forwardsOnlyImage() throws Exception {
        server.expect(requestTo("http://receipt.test/ai/ocr/receipt")).andExpect(method(HttpMethod.POST))
            .andExpect(headerDoesNotExist("Authorization")).andExpect(headerDoesNotExist("X-User-Id"))
            .andExpect(request -> assertThat(((org.springframework.mock.http.client.MockClientHttpRequest)request).getBodyAsString())
                .doesNotContain("private-name", "userId").contains("receipt.png"))
            .andRespond(withSuccess(RESPONSE, MediaType.APPLICATION_JSON));
        assertThat(service.recognize(image()).items().getFirst().ingredientName()).isEqualTo("당근");
        server.verify();
    }

    // OCR 미준비·시간 초과·서버 오류를 정상 결과로 위장하지 않음
    @ParameterizedTest @ValueSource(ints = {400, 404, 413, 503, 504, 500})
    void upstreamFailure(int status) throws Exception {
        server.expect(anything()).andRespond(withStatus(HttpStatusCode.valueOf(status)));
        var file = image();
        assertThatThrownBy(() -> service.recognize(file)).isInstanceOf(BusinessException.class);
    }

    // 연결 실패와 읽기 시간 초과를 별도로 안전하게 처리함
    @Test void timeout() throws Exception {
        server.expect(anything()).andRespond(withException(new java.net.SocketTimeoutException()));
        var file = image();
        assertThatThrownBy(() -> service.recognize(file)).isInstanceOf(BusinessException.class);
    }

    // 잘못된 JSON 계약과 자동 확정 결과를 차단함
    @Test void malformedResponse() throws Exception {
        server.expect(anything()).andRespond(withSuccess(RESPONSE.replace("CHECK_REQUIRED", "CONFIRMED"), MediaType.APPLICATION_JSON));
        var file = image();
        assertThatThrownBy(() -> service.recognize(file)).isInstanceOf(BusinessException.class);
    }

    // 손상되거나 과도하게 큰 파일은 AI 호출 전에 차단함
    @Test void invalidImage() {
        for (byte[] bytes : new byte[][] {new byte[] {1, 2}, new byte[10*1024*1024+1]}) {
            var file = new MockMultipartFile("image", "x.png", "image/png", bytes);
            assertThatThrownBy(() -> service.recognize(file)).isInstanceOf(BusinessException.class);
        }
        server.verify();
    }
    // 내부 영수증 경로가 없는 서버는 OCR 서비스 미준비로 구분함
    @Test void missingRouteIsUnavailable() throws Exception {
        server.expect(anything()).andRespond(withStatus(HttpStatus.NOT_FOUND));
        var file = image();
        assertThatThrownBy(() -> service.recognize(file)).isInstanceOfSatisfying(BusinessException.class,
                error -> assertThat(error.getErrorCode()).isEqualTo(com.mealfit.global.exception.ErrorCode.INVENTORY_RECEIPT_UNAVAILABLE));
    }

    // OCR 성공 후 품목 미발견은 잘못된 응답으로 거부하지 않음
    @ParameterizedTest @ValueSource(strings = {"NO_ITEMS", "NO_TEXT"})
    void legitimateEmptyResult(String status) throws Exception {
        String body = "{\"modelVersion\":\"receipt-test\",\"status\":\"" + status
                + "\",\"items\":[],\"warnings\":[],\"elapsedMs\":100}";
        server.expect(anything()).andRespond(withSuccess(body, MediaType.APPLICATION_JSON));
        assertThat(service.recognize(image()).status()).isEqualTo(status);
    }

    // 미확인 상품명은 분석 후보로만 전달하며 입고 검증은 기존 필수 이름 규칙을 유지함
    @Test void unmappedNameCanBeReviewed() throws Exception {
        server.expect(anything()).andRespond(withSuccess(RESPONSE.replace("\"ingredientName\":\"당근\"", "\"ingredientName\":\"\""), MediaType.APPLICATION_JSON));
        assertThat(service.recognize(image()).items().getFirst().ingredientName()).isEmpty();
    }

}
