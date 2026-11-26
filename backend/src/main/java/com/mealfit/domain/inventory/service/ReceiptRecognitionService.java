package com.mealfit.domain.inventory.service;

import com.mealfit.domain.inventory.dto.ReceiptResponse;
import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import javax.imageio.ImageIO;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.web.client.*;
import org.springframework.web.multipart.MultipartFile;

@Service
public class ReceiptRecognitionService {
    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(ReceiptRecognitionService.class);
    private final RestClient ai;

    // 기존 연결 3초·읽기 20초 AI 클라이언트를 재사용함
    public ReceiptRecognitionService(@Qualifier("aiRestClient") RestClient ai) { this.ai = ai; }

    // 개인정보와 원본 파일명은 전달하지 않고 확인 전 품목만 반환함
    public ReceiptResponse recognize(MultipartFile file) {
        if (file == null || file.isEmpty()) throw new BusinessException(ErrorCode.INVENTORY_RECEIPT_INVALID_IMAGE);
        if (file.getSize() > 10 * 1024 * 1024) throw new BusinessException(ErrorCode.PAYLOAD_TOO_LARGE);
        byte[] bytes;
        String format;
        try {
            bytes = file.getBytes();
            if (bytes.length > 10 * 1024 * 1024) throw new BusinessException(ErrorCode.PAYLOAD_TOO_LARGE);
            try (var input = ImageIO.createImageInputStream(new ByteArrayInputStream(bytes))) {
                var readers = ImageIO.getImageReaders(input);
                if (!readers.hasNext()) throw new IOException();
                var reader = readers.next();
                try {
                    reader.setInput(input);
                    format = reader.getFormatName().toLowerCase();
                    if (!(format.equals("png") || format.equals("jpeg"))) throw new BusinessException(ErrorCode.INVENTORY_RECEIPT_UNSUPPORTED_IMAGE);
                    if ((long)reader.getWidth(0) * reader.getHeight(0) > 16_000_000 || reader.read(0) == null) throw new IOException();
                } finally { reader.dispose(); }
            }
        } catch (IOException | IllegalArgumentException error) {
            throw new BusinessException(ErrorCode.INVENTORY_RECEIPT_INVALID_IMAGE);
        }
        var body = new LinkedMultiValueMap<String, Object>();
        var headers = new HttpHeaders();
        headers.setContentType(format.equals("png") ? MediaType.IMAGE_PNG : MediaType.IMAGE_JPEG);
        body.add("image", new HttpEntity<>(new ByteArrayResource(bytes) {
            // 원본 파일명을 제거함
            @Override public String getFilename() { return "receipt." + format; }
        }, headers));
        try {
            var result = ai.post().uri("/ai/ocr/receipt").contentType(MediaType.MULTIPART_FORM_DATA)
                    .body(body).retrieve().body(ReceiptResponse.class);
            validate(result);
            return result;
        } catch (RestClientResponseException error) {
            log.warn("Receipt AI HTTP failure: status={}", error.getStatusCode().value());
            throw new BusinessException(switch (error.getStatusCode().value()) {
                case 400 -> ErrorCode.INVENTORY_RECEIPT_INVALID_IMAGE;
                case 413 -> ErrorCode.PAYLOAD_TOO_LARGE;
                case 404, 503 -> ErrorCode.INVENTORY_RECEIPT_UNAVAILABLE;
                case 504 -> ErrorCode.INVENTORY_RECEIPT_TIMEOUT;
                default -> ErrorCode.INVENTORY_RECEIPT_BAD_RESPONSE;
            });
        } catch (ResourceAccessException error) {
            Throwable cause = error;
            while (cause != null) {
                if (cause instanceof java.net.SocketTimeoutException || cause instanceof java.net.http.HttpTimeoutException)
                    throw new BusinessException(ErrorCode.INVENTORY_RECEIPT_TIMEOUT);
                cause = cause.getCause();
            }
            throw new BusinessException(ErrorCode.INVENTORY_RECEIPT_UNAVAILABLE);
        } catch (RestClientException error) {
            log.warn("Receipt AI response conversion failure: type={}", error.getClass().getSimpleName());
            throw new BusinessException(ErrorCode.INVENTORY_RECEIPT_BAD_RESPONSE);
        }
    }

    // 원문 전체·식재료 ID 없이 제한된 품목 계약만 허용함
    private void validate(ReceiptResponse result) {
        if (result == null || result.modelVersion() == null || result.modelVersion().isBlank()
                || result.status() == null || !java.util.Set.of("SUCCESS", "NO_TEXT", "NO_ITEMS").contains(result.status())
                || result.items() == null || result.items().size() > 50 || result.elapsedMs() < 0
                || result.elapsedMs() > 20000 || result.warnings() == null || result.warnings().size() > 10
                || (result.status().equals("SUCCESS") != !result.items().isEmpty())) invalid();
        for (var item : result.items()) {
            if (item == null || item.productName() == null || item.productName().isBlank() || item.productName().length() > 100
                    || item.ingredientName() == null || !(item.ingredientName().isEmpty() || item.ingredientName().matches("[가-힣]+(?: [가-힣]+)*"))
                    || item.ingredientName().length() > 100 || !Double.isFinite(item.textConfidence())
                    || item.textConfidence() < 0 || item.textConfidence() > 1 || !item.requiresConfirmation()
                    || !"CHECK_REQUIRED".equals(item.parsingStatus()) || !"UNMAPPED".equals(item.mappingStatus())
                    || (item.quantity() != null && (item.quantity().signum() <= 0 || item.quantity().scale() > 3
                        || item.quantity().compareTo(new java.math.BigDecimal("999999999.999")) > 0))
                    || (item.packageCount() != null && !validNumber(item.packageCount()))
                    || (item.purchaseQuantity() != null && !validNumber(item.purchaseQuantity()))
                    || (item.netQuantity() != null && !validNumber(item.netQuantity()))
                    || (item.quantityStatus() != null && !java.util.Set.of("PROPOSED", "UNCERTAIN").contains(item.quantityStatus()))
                    || (item.purchaseUnit() != null && item.purchaseUnit().length() > 20)
                    || (item.netUnit() != null && item.netUnit().length() > 20)
                    || (item.price() != null && (item.price().signum() < 0 || item.price().precision() > 15))
                    || (item.unit() != null && (item.unit().isBlank() || item.unit().length() > 20))) invalid();
        }
    }

    // 수량 메타데이터도 기존 재고 정밀도 범위로 제한함
    private boolean validNumber(java.math.BigDecimal value) {
        return value.signum() > 0 && value.scale() <= 3
                && value.compareTo(new java.math.BigDecimal("999999999.999")) <= 0;
    }

    // 손상된 AI 응답은 빈 성공으로 처리하지 않음
    private void invalid() { throw new BusinessException(ErrorCode.INVENTORY_RECEIPT_BAD_RESPONSE); }
}
