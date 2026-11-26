package com.mealfit.domain.inventory.repository;

import com.mealfit.domain.inventory.entity.InventoryBatchRequest;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface InventoryBatchRequestRepository extends JpaRepository<InventoryBatchRequest, Long> {
    // 다른 사용자의 요청 키는 조회하지 않음
    Optional<InventoryBatchRequest> findByUserIdAndClientRequestId(Long userId, String clientRequestId);
}
