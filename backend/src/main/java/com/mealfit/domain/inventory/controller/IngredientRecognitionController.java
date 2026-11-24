package com.mealfit.domain.inventory.controller;

import com.mealfit.domain.inventory.dto.IngredientRecognitionResponse;
import com.mealfit.domain.inventory.service.IngredientRecognitionService;
import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import com.mealfit.global.web.CurrentUserId;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@RestController
@RequestMapping("/api/v1/inventory/recognitions")
@RequiredArgsConstructor
@Tag(name = "Inventory", description = "냉장고 재고 및 변경 이력")
public class IngredientRecognitionController {
    private final IngredientRecognitionService service;

    // 인증한 사용자의 사진만 인식하며 재고와 이미지는 저장하지 않음.
    @PostMapping(value = "/photo", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "식재료 사진의 Top-3 후보 조회", description = "image에 JPEG·PNG 한 장(10MiB 이하, 1600만 픽셀 이하)을 전송합니다. "
            + "표준 재료 사전 연결 전이므로 후보는 UNMAPPED이며, 사용자 확인 후 기존 입고 API를 별도 호출해야 합니다. "
            + "인식 ID·피드백은 저장하지 않습니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "미매핑 Top-3 후보"),
            @ApiResponse(responseCode = "400", description = "누락·손상·잘못된 이미지", content = @Content),
            @ApiResponse(responseCode = "401", description = "인증 필요", content = @Content),
            @ApiResponse(responseCode = "413", description = "업로드 한도 초과", content = @Content),
            @ApiResponse(responseCode = "415", description = "지원하지 않는 형식", content = @Content),
            @ApiResponse(responseCode = "502", description = "잘못된 AI 응답", content = @Content),
            @ApiResponse(responseCode = "503", description = "AI 서비스 연결·모델 준비 실패", content = @Content),
            @ApiResponse(responseCode = "504", description = "AI 호출 시간 초과", content = @Content)
    })
    public IngredientRecognitionResponse recognize(@CurrentUserId Long userId,
            @RequestPart(value = "image", required = false) @Schema(type = "string", format = "binary") MultipartFile image,
            MultipartHttpServletRequest request) {
        if (request.getMultiFileMap().size() != 1 || request.getFiles("image").size() != 1
                || !request.getParameterMap().isEmpty()) {
            throw new BusinessException(ErrorCode.INVENTORY_VISION_INVALID_IMAGE);
        }
        return service.recognize(image);
    }
}
