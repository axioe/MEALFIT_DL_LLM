package com.mealfit.domain.inventory.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mealfit.domain.inventory.dto.*;
import com.mealfit.domain.inventory.entity.InventoryBatchRequest;
import com.mealfit.domain.inventory.repository.InventoryBatchRequestRepository;
import com.mealfit.domain.user.repository.UserRepository;
import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HexFormat;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class InventoryBatchService {
    private final UserRepository users;
    private final InventoryBatchRequestRepository requests;
    private final InventoryService inventory;
    private final ObjectMapper mapper;

    // 사용자별 직렬화와 단일 트랜잭션으로 전체 입고·최초 응답을 한 번만 확정함
    @Transactional
    public BatchStockInResponse stockIn(Long userId, BatchStockInRequest request) {
        String key = UUID.fromString(request.clientRequestId()).toString();
        users.findByIdForUpdate(userId).orElseThrow(() -> new BusinessException(ErrorCode.UNAUTHORIZED));
        try {
            String hash = HexFormat.of().formatHex(MessageDigest.getInstance("SHA-256")
                    .digest(mapper.writeValueAsString(request.items()).getBytes(StandardCharsets.UTF_8)));
            var previous = requests.findByUserIdAndClientRequestId(userId, key);
            if (previous.isPresent()) {
                if (!previous.get().getPayloadSha256().equals(hash))
                    throw new BusinessException(ErrorCode.INVALID_STATUS_TRANSITION);
                return mapper.readValue(previous.get().getResponseJson(), BatchStockInResponse.class);
            }
            var lots = request.items().stream().map(item -> inventory.stockIn(userId, item)).toList();
            var result = new BatchStockInResponse(key, lots);
            requests.saveAndFlush(new InventoryBatchRequest(userId, key, hash, mapper.writeValueAsString(result)));
            return result;
        } catch (JsonProcessingException | NoSuchAlgorithmException error) {
            throw new BusinessException(ErrorCode.INTERNAL_ERROR);
        }
    }
}
