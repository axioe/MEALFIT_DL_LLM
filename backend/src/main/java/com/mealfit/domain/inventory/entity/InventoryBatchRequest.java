package com.mealfit.domain.inventory.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "inventory_batch_requests", uniqueConstraints = @UniqueConstraint(name = "uk_inventory_batch_request", columnNames = {"user_id", "client_request_id"}))
@Getter
@NoArgsConstructor(access = lombok.AccessLevel.PROTECTED)
public class InventoryBatchRequest {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    @Column(nullable = false) private Long userId;
    @Column(nullable = false, length = 36) private String clientRequestId;
    @Column(nullable = false, length = 64) private String payloadSha256;
    @Column(nullable = false, columnDefinition = "TEXT") private String responseJson;
    @Column(nullable = false) private LocalDateTime createdAt;

    // 사용자 확인을 마친 요청의 키와 최초 응답만 보존함
    public InventoryBatchRequest(Long userId, String key, String hash, String result) {
        this.userId = userId;
        this.clientRequestId = key;
        this.payloadSha256 = hash;
        this.responseJson = result;
        this.createdAt = LocalDateTime.now(java.time.ZoneId.of("Asia/Seoul"));
    }
}
