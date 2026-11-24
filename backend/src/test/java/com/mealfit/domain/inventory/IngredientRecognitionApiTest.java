package com.mealfit.domain.inventory;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.anything;
import static org.springframework.test.web.client.response.MockRestResponseCreators.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import com.mealfit.domain.ai.config.AiClientConfig;
import com.mealfit.domain.ai.config.AiServiceProperties;
import com.mealfit.domain.inventory.repository.InventoryLotRepository;
import com.mealfit.domain.inventory.repository.InventoryTransactionRepository;
import com.mealfit.domain.inventory.service.IngredientRecognitionService;
import com.mealfit.global.security.JwtTokenProvider;
import com.mealfit.support.TestJwt;
import com.mealfit.support.TestUserFixture;
import java.net.SocketTimeoutException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.EnabledIfEnvironmentVariable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.web.servlet.MultipartProperties;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.*;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.web.client.RestClient;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureMockMvc
@ActiveProfiles("test")
class IngredientRecognitionApiTest {
    static final String URL = "/api/v1/inventory/recognitions/photo";
    @Autowired MockMvc mvc;
    @Autowired TestRestTemplate http;
    @Autowired MultipartProperties multipart;
    @Autowired JwtTokenProvider jwt;
    @Autowired JdbcTemplate jdbc;
    @Autowired InventoryLotRepository lots;
    @Autowired InventoryTransactionRepository transactions;
    @MockitoBean IngredientRecognitionService service;
    private MockRestServiceServer flask;

    // 인증과 MVC는 실제 구성을 사용하고 Flask HTTP 응답만 대체함.
    @BeforeEach
    void setup() {
        var builder = RestClient.builder().baseUrl("http://flask.test");
        flask = MockRestServiceServer.bindTo(builder).build();
        var bridge = new IngredientRecognitionService(builder.build(), true);
        org.mockito.Mockito.doAnswer(call -> bridge.recognize(call.getArgument(0))).when(service).recognize(any());
    }

    // 인증된 요청이 Flask 결과를 반환하고 재고·이력을 변경하지 않음을 검사함.
    @Test
    void authenticatedRecognitionDoesNotRegisterInventory() throws Exception {
        long lotCount = lots.count();
        long historyCount = transactions.count();
        flask.expect(anything()).andRespond(withSuccess(IngredientRecognitionServiceTest.RESPONSE, MediaType.APPLICATION_JSON));
        mvc.perform(multipart(URL).file(IngredientRecognitionServiceTest.upload("png", "image/png")).with(TestJwt.user(7L)))
                .andExpect(status().isOk()).andExpect(jsonPath("$.candidates.length()").value(3))
                .andExpect(jsonPath("$.candidates[0].mappingStatus").value("UNMAPPED"))
                .andExpect(jsonPath("$.candidates[0].ingredientId").doesNotExist())
                .andExpect(jsonPath("$.recognitionId").doesNotExist());
        assertThat(lots.count()).isEqualTo(lotCount);
        assertThat(transactions.count()).isEqualTo(historyCount);
        flask.verify();
    }

    // 사용자 ID 헤더만으로는 인식을 요청할 수 없음을 검사함.
    @Test
    void rejectsAnonymousEvenWithUserIdHeader() throws Exception {
        mvc.perform(multipart(URL).file(IngredientRecognitionServiceTest.upload("png", "image/png")).header("X-User-Id", "7"))
                .andExpect(status().isUnauthorized()).andExpect(jsonPath("$.code").value("COMMON_401"));
    }

    // 누락·복수 파일·추가 입력값이 단일 사진 계약을 위반하는지 검사함.
    @Test
    void rejectsMissingMultipleOrExtraParts() throws Exception {
        mvc.perform(multipart(URL).with(TestJwt.user(7L)))
                .andExpect(status().isBadRequest()).andExpect(jsonPath("$.code").value("INVENTORY_VISION_001"));
        mvc.perform(multipart(URL).file(IngredientRecognitionServiceTest.upload("png", "image/png"))
                        .file(IngredientRecognitionServiceTest.upload("png", "image/png")).with(TestJwt.user(7L)))
                .andExpect(status().isBadRequest());
        mvc.perform(multipart(URL).file(IngredientRecognitionServiceTest.upload("png", "image/png"))
                        .file(new MockMultipartFile("other", new byte[]{1})).with(TestJwt.user(7L)))
                .andExpect(status().isBadRequest());
        mvc.perform(multipart(URL).file(IngredientRecognitionServiceTest.upload("png", "image/png"))
                        .param("userId", "999").with(TestJwt.user(7L)))
                .andExpect(status().isBadRequest());
    }

    // JSON 요청과 손상 이미지는 업스트림 호출 전에 거부함.
    @Test
    void rejectsWrongBodyAndInvalidImage() throws Exception {
        mvc.perform(post(URL).contentType(MediaType.APPLICATION_JSON).content("{}").with(TestJwt.user(7L)))
                .andExpect(status().isUnsupportedMediaType());
        mvc.perform(multipart(URL).file(new MockMultipartFile("image", "bad.png", "image/png", new byte[]{1, 2}))
                        .with(TestJwt.user(7L)))
                .andExpect(status().isBadRequest()).andExpect(jsonPath("$.errors").isArray())
                .andExpect(jsonPath("$.timestamp").exists());
    }

    // 시간 초과와 서버 오류가 공통 응답 형식으로 변환되는지 검사함.
    @Test
    void returnsSafeTimeoutAndServerErrors() throws Exception {
        flask.expect(anything()).andRespond(withException(new SocketTimeoutException("private timeout")));
        mvc.perform(multipart(URL).file(IngredientRecognitionServiceTest.upload("png", "image/png")).with(TestJwt.user(7L)))
                .andExpect(status().isGatewayTimeout()).andExpect(jsonPath("$.code").value("INVENTORY_VISION_004"));
        flask.verify();
        flask.reset();
        flask.expect(anything()).andRespond(withServerError().body("private upstream detail"));
        mvc.perform(multipart(URL).file(IngredientRecognitionServiceTest.upload("png", "image/png")).with(TestJwt.user(7L)))
                .andExpect(status().isBadGateway()).andExpect(jsonPath("$.code").value("INVENTORY_VISION_005"))
                .andExpect(jsonPath("$.message").value("사진 인식 결과를 확인하지 못했습니다. 다시 시도해 주세요."));
        flask.verify();
    }

    // 내장 서버의 실제 multipart 한도와 HTTP 413 응답을 검사함.
    @Test
    void embeddedServerRejectsOversizeUpload() throws Exception {
        assertThat(multipart.getMaxFileSize().toBytes()).isEqualTo(10 * 1024 * 1024);
        assertThat(multipart.getMaxRequestSize().toBytes()).isEqualTo(11 * 1024 * 1024);
        TestUserFixture.create(jdbc, 7L);
        String boundary = "mealfit-test-boundary";
        var body = new java.io.ByteArrayOutputStream();
        // 브라우저처럼 파일 파트에는 Content-Length를 넣지 않음.
        body.writeBytes(("--" + boundary + "\r\nContent-Disposition: form-data; name=\"image\"; filename=\"large.png\"\r\n"
                + "Content-Type: image/png\r\n\r\n").getBytes(java.nio.charset.StandardCharsets.UTF_8));
        body.writeBytes(new byte[IngredientRecognitionService.MAX_IMAGE_BYTES + 1]);
        body.writeBytes(("\r\n--" + boundary + "--\r\n").getBytes(java.nio.charset.StandardCharsets.UTF_8));
        var request = java.net.http.HttpRequest.newBuilder(java.net.URI.create(http.getRootUri() + URL))
                .header("Content-Type", "multipart/form-data; boundary=" + boundary)
                .header("Authorization", "Bearer " + jwt.createAccessToken(7L, "test-7@example.com"))
                .timeout(Duration.ofSeconds(15)).POST(java.net.http.HttpRequest.BodyPublishers.ofByteArray(body.toByteArray())).build();
        var result = java.net.http.HttpClient.newHttpClient().send(request, java.net.http.HttpResponse.BodyHandlers.ofString());
        assertThat(result.statusCode()).isEqualTo(413);
        assertThat(result.body()).contains("COMMON_413", "timestamp");
    }
    // Swagger 문서에 multipart 요청과 오류 계약이 포함되는지 검사함.
    @Test
    void exposesMultipartContractInSwagger() throws Exception {
        mvc.perform(get("/v3/api-docs")).andExpect(status().isOk())
                .andExpect(jsonPath("$.paths['" + URL + "'].post.requestBody.content['multipart/form-data']").exists())
                .andExpect(jsonPath("$.paths['" + URL + "'].post.responses['504']").exists());
    }

    // 명시한 로컬 Flask와 Validation 이미지만으로 실제 모델 추론을 검증함.
    @Test
    @EnabledIfEnvironmentVariable(named = "MEALFIT_LIVE_VISION_URL", matches = ".+")
    void liveFlaskInferenceWithoutDatabaseWrites() throws Exception {
        Path image = Path.of(System.getenv("MEALFIT_LIVE_VISION_IMAGE")).toAbsolutePath();
        assertThat(image.toString().replace('\\', '/')).contains("/valid/").doesNotContain("/test/");
        var client = new AiClientConfig().aiRestClient(RestClient.builder(), new AiServiceProperties(
                System.getenv("MEALFIT_LIVE_VISION_URL"), Duration.ofSeconds(3), Duration.ofSeconds(20)));
        var bridge = new IngredientRecognitionService(client, true);
        org.mockito.Mockito.doAnswer(call -> bridge.recognize(call.getArgument(0))).when(service).recognize(any());
        long lotCount = lots.count();
        long historyCount = transactions.count();
        mvc.perform(multipart(URL).file(new MockMultipartFile("image", "image.png", "image/png", Files.readAllBytes(image)))
                        .with(TestJwt.user(7L)))
                .andExpect(status().isOk()).andExpect(jsonPath("$.candidates.length()").value(3))
                .andExpect(jsonPath("$.modelVersion").value("efficientnet-b0-stage3-epoch19"));
        assertThat(lots.count()).isEqualTo(lotCount);
        assertThat(transactions.count()).isEqualTo(historyCount);
        System.out.println("LIVE_SPRING_FLASK_VISION_SUCCESS candidates=3 inventoryUnchanged=true");
    }

    // 실제 Flask OCR과 인증된 Spring 응답을 연결하되 재고·이력은 변경하지 않음.
    @Test
    @EnabledIfEnvironmentVariable(named = "MEALFIT_LIVE_OCR_URL", matches = ".+")
    void liveOcrKeepsInventoryUnchanged() throws Exception {
        Path image = Path.of(System.getenv("MEALFIT_LIVE_OCR_IMAGE")).toAbsolutePath();
        assertThat(image.getFileName().toString()).isEqualTo("토마토.jfif");
        var client = new AiClientConfig().aiRestClient(RestClient.builder(), new AiServiceProperties(
                System.getenv("MEALFIT_LIVE_OCR_URL"), Duration.ofSeconds(3), Duration.ofSeconds(20)));
        var bridge = new IngredientRecognitionService(client, true);
        org.mockito.Mockito.doAnswer(call -> bridge.recognize(call.getArgument(0))).when(service).recognize(any());
        long lotCount = lots.count();
        long historyCount = transactions.count();
        mvc.perform(multipart(URL).file(new MockMultipartFile("image", "image.jpg", "image/jpeg", Files.readAllBytes(image)))
                        .with(TestJwt.user(7L)))
                .andExpect(status().isOk()).andExpect(jsonPath("$.candidates.length()").value(3))
                .andExpect(jsonPath("$.ocr.status").value("SUCCESS"))
                .andExpect(jsonPath("$.ocr.candidates[0].ingredientName").value("토마토"))
                .andExpect(jsonPath("$.ocr.candidates[0].ingredientId").doesNotExist());
        assertThat(lots.count()).isEqualTo(lotCount);
        assertThat(transactions.count()).isEqualTo(historyCount);
    }
}
