package com.mealfit.domain.inventory;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.*;
import static org.springframework.test.web.client.response.MockRestResponseCreators.*;

import com.mealfit.domain.inventory.dto.IngredientRecognitionResponse.MappingStatus;
import com.mealfit.domain.inventory.service.IngredientRecognitionService;
import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.ConnectException;
import java.net.SocketTimeoutException;
import java.nio.ByteBuffer;
import java.util.stream.Stream;
import javax.imageio.ImageIO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.MethodSource;
import org.junit.jupiter.params.provider.ValueSource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.web.client.RestClient;
import org.springframework.web.multipart.MultipartFile;

class IngredientRecognitionServiceTest {
    static final String RESPONSE = """
            {"modelVersion":"efficientnet-b0-stage3-epoch19","candidates":[
            {"className":"tomato","confidence":0.8},
            {"className":"paprika","confidence":0.1},
            {"className":"egg","confidence":0.05}]}
            """;
    private MockRestServiceServer server;
    private IngredientRecognitionService service;

    // 실제 HTTP 대신 Mock 서버를 연결함.
    @BeforeEach
    void setup() {
        var builder = RestClient.builder().baseUrl("http://flask.test");
        server = MockRestServiceServer.bindTo(builder).build();
        service = new IngredientRecognitionService(builder.build(), true);
    }

    // 외부 데이터 없이 정상 이미지 바이트를 생성함.
    static byte[] image(String format) throws IOException {
        var output = new ByteArrayOutputStream();
        ImageIO.write(new BufferedImage(3, 2, BufferedImage.TYPE_INT_RGB), format, output);
        return output.toByteArray();
    }

    // 테스트 이미지에 사용자가 제출한 파일 정보를 지정함.
    static MockMultipartFile upload(String format, String type) throws IOException {
        return new MockMultipartFile("image", "private-original-name." + format, type, image(format));
    }

    // 이미지 전송 계약과 사용자 정보 미전달 및 Top-3 확률 보존을 검사함.
    @ParameterizedTest
    @ValueSource(strings = {"png", "jpeg"})
    void forwardsImageAndPreservesCandidates(String format) throws Exception {
        server.expect(requestTo("http://flask.test/ai/vision/ingredients"))
                .andExpect(method(org.springframework.http.HttpMethod.POST))
                .andExpect(content().contentTypeCompatibleWith(MediaType.MULTIPART_FORM_DATA))
                .andExpect(headerDoesNotExist("Authorization"))
                .andExpect(headerDoesNotExist("X-User-Id"))
                .andExpect(request -> {
                    String wire = ((org.springframework.mock.http.client.MockClientHttpRequest) request).getBodyAsString();
                    assertThat(wire).contains("name=\"image\"", "filename=\"image.")
                            .doesNotContain("private-original-name", "userId", "Bearer");
                })
                .andRespond(withSuccess(RESPONSE, MediaType.APPLICATION_JSON));
        var result = service.recognize(upload(format, "image/" + format));
        assertThat(result.modelVersion()).isEqualTo("efficientnet-b0-stage3-epoch19");
        assertThat(result.candidates()).hasSize(3).allMatch(candidate -> candidate.mappingStatus() == MappingStatus.UNMAPPED);
        assertThat(result.candidates().getFirst().confidence()).isEqualTo(0.8);
        assertThat(result.candidates().getFirst().className()).isEqualTo("tomato");
        server.verify();
    }

    // 한도와 정확히 같은 크기는 허용하고 파일명·MIME 누락은 내용으로 판별함.
    @Test
    void acceptsExactByteLimitAndMissingMimeType() throws Exception {
        byte[] bytes = java.util.Arrays.copyOf(image("png"), IngredientRecognitionService.MAX_IMAGE_BYTES);
        server.expect(anything()).andRespond(withSuccess(RESPONSE, MediaType.APPLICATION_JSON));
        var result = service.recognize(new MockMultipartFile("image", "", null, bytes));
        assertThat(result.candidates()).hasSize(3);
        server.verify();
    }

    // 비활성화 상태에서는 AI를 호출하지 않음을 검사함.
    @Test
    void disabledFeatureDoesNotCallAi() throws Exception {
        var disabled = new IngredientRecognitionService(RestClient.create(), false);
        assertFailure(() -> disabled.recognize(upload("png", "image/png")), ErrorCode.INVENTORY_VISION_UNAVAILABLE);
    }

    // 빈 파일과 손상 파일을 AI 호출 전에 거부함.
    @Test
    void rejectsMissingEmptyAndCorruptImages() {
        assertFailure(() -> service.recognize(null), ErrorCode.INVENTORY_VISION_INVALID_IMAGE);
        assertFailure(() -> service.recognize(new MockMultipartFile("image", new byte[0])), ErrorCode.INVENTORY_VISION_INVALID_IMAGE);
        assertFailure(() -> service.recognize(new MockMultipartFile("image", new byte[]{1, 2, 3})), ErrorCode.INVENTORY_VISION_INVALID_IMAGE);
    }

    // 지원하지 않는 이미지와 위장 MIME 유형을 거부함.
    @Test
    void rejectsGifAndMismatchedContentType() {
        assertFailure(() -> service.recognize(upload("gif", "image/gif")), ErrorCode.INVENTORY_VISION_UNSUPPORTED_IMAGE);
        assertFailure(() -> service.recognize(upload("png", "image/jpeg")), ErrorCode.INVENTORY_VISION_UNSUPPORTED_IMAGE);
    }

    // 파일 크기 메타데이터와 실제 스트림의 초과를 모두 거부함.
    @Test
    void rejectsOversizeEvenWithFalseMetadata() throws Exception {
        var bytes = new byte[IngredientRecognitionService.MAX_IMAGE_BYTES + 1];
        assertFailure(() -> service.recognize(new MockMultipartFile("image", bytes)), ErrorCode.PAYLOAD_TOO_LARGE);
        var image = mock(MultipartFile.class);
        when(image.getInputStream()).thenReturn(new java.io.ByteArrayInputStream(bytes));
        when(image.getSize()).thenReturn(1L);
        assertFailure(() -> service.recognize(image), ErrorCode.PAYLOAD_TOO_LARGE);
    }

    // 디코딩 전에 픽셀 상한을 검사함.
    @Test
    void rejectsExcessivePixelDimensions() throws Exception {
        byte[] bytes = image("png");
        ByteBuffer.wrap(bytes).putInt(16, 4001).putInt(20, 4000);
        assertFailure(() -> service.recognize(new MockMultipartFile("image", "large.png", "image/png", bytes)),
                ErrorCode.INVENTORY_VISION_INVALID_IMAGE);
    }

    // 읽기 실패도 이미지 입력 오류로 안내함.
    @Test
    void rejectsUnreadableUpload() throws Exception {
        var image = mock(MultipartFile.class);
        when(image.getInputStream()).thenThrow(new IOException("private detail"));
        assertFailure(() -> service.recognize(image), ErrorCode.INVENTORY_VISION_INVALID_IMAGE);
    }

    // 잘못된 응답의 누락·중복·확률·정렬 사례를 제공함.
    static Stream<String> invalidResponses() {
        return Stream.of("null", "{}", "not-json", RESPONSE.replace("efficientnet-b0-stage3-epoch19", ""),
                RESPONSE.replace("0.8", "1.1"), RESPONSE.replace("0.8", "-0.1"),
                RESPONSE.replace("0.8", "0.01"), RESPONSE.replace("0.8", "0.99"),
                RESPONSE.replace("0.8", "null"), RESPONSE.replace("tomato", "egg"),
                RESPONSE.replace("tomato", "<script>"), RESPONSE.replace("0.8", "\"NaN\""),
                "{\"modelVersion\":\"v1\",\"candidates\":[]}",
                "{\"modelVersion\":\"v1\",\"candidates\":[null,null,null]}",
                RESPONSE.replace(",\n{\"className\":\"egg\",\"confidence\":0.05}", ""));
    }

    // 잘못된 AI 출력을 성공 후보로 노출하지 않음을 검사함.
    @ParameterizedTest
    @MethodSource("invalidResponses")
    void rejectsInvalidAiResponses(String response) {
        server.expect(anything()).andRespond(withSuccess(response, MediaType.APPLICATION_JSON));
        assertFailure(() -> service.recognize(upload("png", "image/png")), ErrorCode.INVENTORY_VISION_BAD_RESPONSE);
        server.verify();
    }

    // 내부 오류 본문 대신 허용된 상태와 오류 코드만 반환함.
    @ParameterizedTest
    @ValueSource(ints = {400, 413, 415, 500, 503, 504})
    void translatesUpstreamFailures(int status) {
        ErrorCode expected = switch (status) {
            case 400 -> ErrorCode.INVENTORY_VISION_INVALID_IMAGE;
            case 413 -> ErrorCode.PAYLOAD_TOO_LARGE;
            case 415 -> ErrorCode.INVENTORY_VISION_UNSUPPORTED_IMAGE;
            case 503 -> ErrorCode.INVENTORY_VISION_UNAVAILABLE;
            case 504 -> ErrorCode.INVENTORY_VISION_TIMEOUT;
            default -> ErrorCode.INVENTORY_VISION_BAD_RESPONSE;
        };
        server.expect(anything()).andRespond(withStatus(HttpStatus.valueOf(status)).body("private upstream detail"));
        assertFailure(() -> service.recognize(upload("png", "image/png")), expected);
        server.verify();
    }

    // 시간 초과와 연결 실패를 서로 다른 오류로 안내함.
    @Test
    void distinguishesTimeoutFromConnectionFailure() {
        server.expect(anything()).andRespond(withException(new SocketTimeoutException("timeout")));
        assertFailure(() -> service.recognize(upload("png", "image/png")), ErrorCode.INVENTORY_VISION_TIMEOUT);
        server.verify();
        server.reset();
        server.expect(anything()).andRespond(withException(new ConnectException("refused")));
        assertFailure(() -> service.recognize(upload("png", "image/png")), ErrorCode.INVENTORY_VISION_UNAVAILABLE);
        server.verify();
    }


    // 라벨 후보와 모델 후보가 달라도 확률을 합산하거나 순서를 바꾸지 않음.
    @Test
    void preservesOcrAndDlSeparately() throws Exception {
        String ocr = """
                "ocr":{"status":"SUCCESS","candidates":[
                {"ingredientName":"당근","textConfidence":0.91},
                {"ingredientName":"깻잎","textConfidence":0.82}],"elapsedMs":321}
                """;
        String response = RESPONSE.stripTrailing().replaceFirst("}$", "," + ocr + "}");
        server.expect(anything()).andRespond(withSuccess(response, MediaType.APPLICATION_JSON));
        var result = service.recognize(upload("png", "image/png"));
        assertThat(result.candidates().getFirst().className()).isEqualTo("tomato");
        assertThat(result.candidates().getFirst().confidence()).isEqualTo(.8);
        assertThat(result.ocr().status().name()).isEqualTo("SUCCESS");
        assertThat(result.ocr().candidates()).extracting(candidate -> candidate.ingredientName()).containsExactly("당근", "깻잎");
        assertThat(result.ocr().elapsedMs()).isEqualTo(321);
        server.verify();
    }

    // OCR 실패 상태는 기존 이미지 인식 성공을 유지함.
    @ParameterizedTest
    @ValueSource(strings = {"NO_TEXT", "NO_MATCH", "TIMEOUT", "UNAVAILABLE", "ERROR"})
    void preservesDlOnOcrFailure(String status) throws Exception {
        String ocr = "\"ocr\":{\"status\":\"" + status + "\",\"candidates\":[],\"elapsedMs\":12}";
        server.expect(anything()).andRespond(withSuccess(
                RESPONSE.stripTrailing().replaceFirst("}$", "," + ocr + "}"), MediaType.APPLICATION_JSON));
        var result = service.recognize(upload("png", "image/png"));
        assertThat(result.candidates()).hasSize(3);
        assertThat(result.ocr().status().name()).isEqualTo(status);
        server.verify();
    }

    // 잘못된 선택 필드만 오류로 바꾸고 OCR 원문이나 식재료 ID를 만들지 않음.
    @ParameterizedTest
    @ValueSource(strings = {
            "[]", "\"raw private text\"", "{}",
            "{\"status\":\"SUCCESS\",\"candidates\":[],\"elapsedMs\":1}",
            "{\"status\":\"UNKNOWN\",\"candidates\":[],\"elapsedMs\":1}",
            "{\"status\":\"ERROR\",\"candidates\":[],\"elapsedMs\":-1}",
            "{\"status\":\"SUCCESS\",\"candidates\":[{\"ingredientName\":\"당근\",\"textConfidence\":2}],\"elapsedMs\":1}",
            "{\"status\":\"ERROR\",\"candidates\":[{\"ingredientName\":\"당근\",\"textConfidence\":0.9}],\"elapsedMs\":1}"})
    void malformedOcrDoesNotBreakDl(String ocr) throws Exception {
        server.expect(anything()).andRespond(withSuccess(
                RESPONSE.stripTrailing().replaceFirst("}$", ",\"ocr\":" + ocr + "}"), MediaType.APPLICATION_JSON));
        var result = service.recognize(upload("png", "image/png"));
        assertThat(result.candidates()).hasSize(3);
        assertThat(result.ocr().status().name()).isEqualTo("ERROR");
        assertThat(result.ocr().candidates()).isEmpty();
        server.verify();
    }


    // 공통 비즈니스 예외와 민감 정보 미노출을 검사함.
    static void assertFailure(org.assertj.core.api.ThrowableAssert.ThrowingCallable call, ErrorCode code) {
        assertThatThrownBy(call).isInstanceOfSatisfying(BusinessException.class, error -> {
            assertThat(error.getErrorCode()).isEqualTo(code);
            assertThat(error.getMessage()).doesNotContain("private", "refused");
        });
    }
}
