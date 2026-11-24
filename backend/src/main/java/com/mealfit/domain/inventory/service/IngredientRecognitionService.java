package com.mealfit.domain.inventory.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.mealfit.domain.inventory.dto.IngredientRecognitionResponse;
import com.mealfit.domain.inventory.dto.IngredientRecognitionResponse.OcrCandidate;
import com.mealfit.domain.inventory.dto.IngredientRecognitionResponse.OcrResult;
import com.mealfit.domain.inventory.dto.IngredientRecognitionResponse.OcrStatus;
import java.util.ArrayList;
import com.mealfit.domain.inventory.dto.IngredientRecognitionResponse.Candidate;
import com.mealfit.domain.inventory.dto.IngredientRecognitionResponse.MappingStatus;
import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.net.SocketTimeoutException;
import java.net.http.HttpTimeoutException;
import java.util.HashSet;
import java.util.List;
import javax.imageio.ImageIO;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.MediaType;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.stereotype.Service;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestClientResponseException;
import org.springframework.web.multipart.MultipartFile;

@Service
public class IngredientRecognitionService {
    public static final int MAX_IMAGE_BYTES = 10 * 1024 * 1024;
    private static final long MAX_IMAGE_PIXELS = 16_000_000L;
    private final RestClient ai;
    private final boolean enabled;

    // 기존 AI 클라이언트와 사진 인식 활성 설정을 주입함.
    public IngredientRecognitionService(@Qualifier("aiRestClient") RestClient ai,
                                        @Value("${ai.vision.enabled:true}") boolean enabled) {
        this.ai = ai;
        this.enabled = enabled;
    }

    // 검증한 이미지 한 장을 전달하고 미매핑 Top-3 후보만 반환함.
    public IngredientRecognitionResponse recognize(MultipartFile image) {
        if (!enabled) throw new BusinessException(ErrorCode.INVENTORY_VISION_UNAVAILABLE);
        byte[] bytes = readImage(image);
        MediaType type = validateImage(bytes, image.getContentType());
        var body = new LinkedMultiValueMap<String, Object>();
        var headers = new HttpHeaders();
        headers.setContentType(type);
        // 원래 파일명과 사용자 식별 정보는 AI 서버로 보내지 않음.
        var resource = new ByteArrayResource(bytes) {
            // 검증한 실제 이미지 형식에 맞는 고정 파일명을 반환함.
            @Override public String getFilename() {
                return type.equals(MediaType.IMAGE_PNG) ? "image.png" : "image.jpg";
            }
        };
        body.add("image", new HttpEntity<>(resource, headers));
        AiResponse response;
        try {
            response = ai.post().uri("/ai/vision/ingredients").contentType(MediaType.MULTIPART_FORM_DATA)
                    .body(body).retrieve().body(AiResponse.class);
        } catch (RestClientResponseException error) {
            throw upstreamError(error);
        } catch (ResourceAccessException error) {
            for (Throwable cause = error; cause != null; cause = cause.getCause()) {
                if (cause instanceof SocketTimeoutException || cause instanceof HttpTimeoutException) {
                    throw new BusinessException(ErrorCode.INVENTORY_VISION_TIMEOUT);
                }
            }
            throw new BusinessException(ErrorCode.INVENTORY_VISION_UNAVAILABLE);
        } catch (RestClientException error) {
            throw new BusinessException(ErrorCode.INVENTORY_VISION_BAD_RESPONSE);
        }
        validateResponse(response);
        return new IngredientRecognitionResponse(response.modelVersion(), response.candidates().stream()
                .map(candidate -> new Candidate(candidate.className(), candidate.confidence(), MappingStatus.UNMAPPED)).toList(), readOcr(response.ocr()));
    }

    // 파일 크기와 실제 읽은 바이트 수를 함께 검사함.
    private byte[] readImage(MultipartFile image) {
        if (image == null || image.isEmpty()) throw new BusinessException(ErrorCode.INVENTORY_VISION_INVALID_IMAGE);
        if (image.getSize() > MAX_IMAGE_BYTES) throw new BusinessException(ErrorCode.PAYLOAD_TOO_LARGE);
        try (var input = image.getInputStream()) {
            byte[] bytes = input.readNBytes(MAX_IMAGE_BYTES + 1);
            if (bytes.length > MAX_IMAGE_BYTES) throw new BusinessException(ErrorCode.PAYLOAD_TOO_LARGE);
            if (bytes.length == 0) throw new BusinessException(ErrorCode.INVENTORY_VISION_INVALID_IMAGE);
            return bytes;
        } catch (IOException error) {
            throw new BusinessException(ErrorCode.INVENTORY_VISION_INVALID_IMAGE);
        }
    }

    // 확장자 대신 이미지 내용과 픽셀 수를 확인해 위장 파일과 과도한 디코딩을 막음.
    private MediaType validateImage(byte[] bytes, String declaredType) {
        try (var input = new javax.imageio.stream.MemoryCacheImageInputStream(new ByteArrayInputStream(bytes))) {
            var readers = ImageIO.getImageReaders(input);
            if (!readers.hasNext()) throw new BusinessException(ErrorCode.INVENTORY_VISION_INVALID_IMAGE);
            var reader = readers.next();
            try {
                String format = reader.getFormatName();
                MediaType type;
                if (format.equalsIgnoreCase("PNG")) type = MediaType.IMAGE_PNG;
                else if (format.equalsIgnoreCase("JPEG")) type = MediaType.IMAGE_JPEG;
                else throw new BusinessException(ErrorCode.INVENTORY_VISION_UNSUPPORTED_IMAGE);
                if (declaredType != null && !declaredType.equalsIgnoreCase(type.toString())
                        && !declaredType.equalsIgnoreCase(MediaType.APPLICATION_OCTET_STREAM_VALUE)) {
                    throw new BusinessException(ErrorCode.INVENTORY_VISION_UNSUPPORTED_IMAGE);
                }
                reader.setInput(input, true, true);
                int width = reader.getWidth(0);
                int height = reader.getHeight(0);
                if (width <= 0 || height <= 0 || (long) width * height > MAX_IMAGE_PIXELS) {
                    throw new BusinessException(ErrorCode.INVENTORY_VISION_INVALID_IMAGE);
                }
                if (reader.read(0) == null) throw new BusinessException(ErrorCode.INVENTORY_VISION_INVALID_IMAGE);
                return type;
            } finally {
                reader.dispose();
            }
        } catch (IOException | IllegalArgumentException error) {
            throw new BusinessException(ErrorCode.INVENTORY_VISION_INVALID_IMAGE);
        }
    }

    // Flask 오류 내용을 노출하지 않고 공통 오류 코드로 변환함.
    private BusinessException upstreamError(RestClientResponseException error) {
        return new BusinessException(switch (error.getStatusCode().value()) {
            case 400 -> ErrorCode.INVENTORY_VISION_INVALID_IMAGE;
            case 413 -> ErrorCode.PAYLOAD_TOO_LARGE;
            case 415 -> ErrorCode.INVENTORY_VISION_UNSUPPORTED_IMAGE;
            case 503 -> ErrorCode.INVENTORY_VISION_UNAVAILABLE;
            case 504 -> ErrorCode.INVENTORY_VISION_TIMEOUT;
            default -> ErrorCode.INVENTORY_VISION_BAD_RESPONSE;
        });
    }

    // 후보 개수·중복·정렬·확률 범위를 검증하고 확률을 임의 보정하지 않음.
    private void validateResponse(AiResponse response) {
        if (response == null || response.modelVersion() == null || response.modelVersion().isBlank()
                || response.modelVersion().length() > 100 || response.candidates() == null || response.candidates().size() != 3) {
            throw new BusinessException(ErrorCode.INVENTORY_VISION_BAD_RESPONSE);
        }
        var names = new HashSet<String>();
        double previous = 1;
        double sum = 0;
        for (AiCandidate candidate : response.candidates()) {
            if (candidate == null || candidate.className() == null || !candidate.className().matches("[a-z][a-z0-9_]{0,99}")
                    || !names.add(candidate.className()) || candidate.confidence() == null
                    || !Double.isFinite(candidate.confidence()) || candidate.confidence() < 0
                    || candidate.confidence() > previous) {
                throw new BusinessException(ErrorCode.INVENTORY_VISION_BAD_RESPONSE);
            }
            previous = candidate.confidence();
            sum += previous;
        }
        if (sum > 1.000001) throw new BusinessException(ErrorCode.INVENTORY_VISION_BAD_RESPONSE);
    }

    // 선택 OCR 출력이 잘못돼도 검증된 이미지 분류 후보는 보존함.
    private OcrResult readOcr(JsonNode data) {
        if (data == null || data.isNull()) return null;
        OcrResult invalid = new OcrResult(OcrStatus.ERROR, List.of(), 0);
        if (!data.isObject() || !data.path("status").isTextual()
                || !data.path("candidates").isArray() || data.path("candidates").size() > 20
                || !data.path("elapsedMs").isIntegralNumber() || !data.path("elapsedMs").canConvertToLong()
                || data.path("elapsedMs").asLong() < 0 || data.path("elapsedMs").asLong() > 60_000) return invalid;
        OcrStatus status;
        try {
            status = OcrStatus.valueOf(data.path("status").asText());
        } catch (IllegalArgumentException error) {
            return invalid;
        }
        var candidates = new ArrayList<OcrCandidate>();
        var names = new HashSet<String>();
        for (JsonNode candidate : data.path("candidates")) {
            String name = candidate.path("ingredientName").asText("");
            JsonNode score = candidate.path("textConfidence");
            if (name.length() > 100 || !name.matches("[가-힣]+(?: [가-힣]+)*") || !names.add(name)
                    || !score.isNumber() || !Double.isFinite(score.asDouble())
                    || score.asDouble() < 0 || score.asDouble() > 1) return invalid;
            candidates.add(new OcrCandidate(name, score.asDouble()));
        }
        if ((status == OcrStatus.SUCCESS) != !candidates.isEmpty()) return invalid;
        return new OcrResult(status, List.copyOf(candidates), data.path("elapsedMs").asLong());
    }

    public record AiResponse(String modelVersion, List<AiCandidate> candidates, JsonNode ocr) { }
    public record AiCandidate(String className, Double confidence) { }
}
