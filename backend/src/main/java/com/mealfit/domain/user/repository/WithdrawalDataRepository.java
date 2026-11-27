package com.mealfit.domain.user.repository;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

/** 회원 계정 삭제 전에 회원 소유 데이터를 외래 키 순서에 맞춰 삭제합니다. */
@Repository
@RequiredArgsConstructor
public class WithdrawalDataRepository {
    private final JdbcTemplate jdbc;

    @Transactional(propagation = Propagation.MANDATORY)
    public void deleteByUserId(Long userId) {
        jdbc.update("delete from workout_logs where user_id = ?", userId);
        jdbc.update("delete from workout_sessions where user_id = ?", userId);
        jdbc.update("delete from workout_routines where user_id = ?", userId);

        // 영수증 일괄 등록의 중복 방지 기록(V17)도 users를 참조하므로 먼저 삭제합니다.
        jdbc.update("delete from inventory_batch_requests where user_id = ?", userId);
        jdbc.update("delete from inventory_transactions where user_id = ?", userId);
        jdbc.update("delete from inventory_lots where user_id = ?", userId);
        jdbc.update("delete from intake_logs where user_id = ?", userId);
        jdbc.update("delete from cooking_events where user_id = ?", userId);
        jdbc.update("delete from meal_plans where user_id = ?", userId);
        // 공용 레시피의 user_id는 NULL이고, 개인 레시피의 하위 행은 DB가 함께 삭제합니다.
        jdbc.update("delete from recipes where user_id = ?", userId);
        jdbc.update("delete from shopping_items where user_id = ?", userId);

        jdbc.update("""
            delete from profile_allergies
            where profile_id in (select id from profiles where user_id = ?)
            """, userId);
        jdbc.update("""
            delete from profile_excluded_ingredients
            where profile_id in (select id from profiles where user_id = ?)
            """, userId);
        // 상세 프로필과 그 하위 행은 DB가 함께 삭제합니다.
        jdbc.update("delete from profiles where user_id = ?", userId);

        jdbc.update("delete from refresh_tokens where user_id = ?", userId);
        jdbc.update("delete from email_verification_tokens where user_id = ?", userId);
        jdbc.update("delete from user_social_accounts where user_id = ?", userId);
    }
}
