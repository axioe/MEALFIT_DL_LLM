package com.mealfit.domain.inventory.controller;

import com.mealfit.domain.inventory.dto.*;
import com.mealfit.domain.inventory.service.*;
import com.mealfit.global.exception.*;
import com.mealfit.global.web.CurrentUserId;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.*;

@RestController
@RequestMapping("/api/v1/inventory")
@RequiredArgsConstructor
@Tag(name = "Inventory")
public class ReceiptInventoryController {
    private final ReceiptRecognitionService receipts;
    private final InventoryBatchService batches;

    // 인증된 사용자의 영수증 후보만 분석하며 원본과 재고를 저장하지 않음
    @PostMapping(value = "/recognitions/receipt", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "영수증 구매 품목 후보 분석", description = "image: JPEG·PNG 1장, 10MiB·1600만 픽셀 이하. 사용자 확인 필수, DB 저장 없음.")
    public ReceiptResponse recognize(@CurrentUserId Long userId,
            @RequestPart(value = "image", required = false) MultipartFile image, MultipartHttpServletRequest request) {
        if (request.getMultiFileMap().size() != 1 || request.getFiles("image").size() != 1 || !request.getParameterMap().isEmpty())
            throw new BusinessException(ErrorCode.INVENTORY_RECEIPT_INVALID_IMAGE);
        return receipts.recognize(image);
    }

    // 같은 키와 내용의 재전송은 최초 응답을 반환하고 전체 실패는 롤백함
    @PostMapping("/lots/batch")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "확인한 품목 일괄 입고", description = "clientRequestId: UUID, items: 기존 입고 DTO 1~50개. 전부 성공 또는 전부 롤백. 같은 키의 다른 내용은 409.")
    public BatchStockInResponse stockIn(@CurrentUserId Long userId, @Valid @RequestBody BatchStockInRequest request) {
        return batches.stockIn(userId, request);
    }
}
