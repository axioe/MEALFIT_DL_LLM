package com.mealfit.domain.user.service;

import com.mealfit.domain.allergen.service.AllergenIngredientResolver;
import com.mealfit.domain.mealplan.model.UserDietProfile;
import java.util.LinkedHashSet;
import java.util.Set;
import com.mealfit.domain.mealplan.service.UserDietProfileProvider;
import com.mealfit.domain.user.entity.Profile;
import com.mealfit.domain.user.repository.ProfileRepository;
import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

/**
 * 회원 프로필의 식단 조건을 식단 도메인에 전달합니다.
 * 이름·이메일 등 개인 식별 정보는 전달하지 않습니다.
 */
@Component
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UserDietProfileProviderImpl
    implements UserDietProfileProvider {

    private final ProfileRepository profileRepository;
    private final AllergenIngredientResolver allergenIngredientResolver;

    /**
     * 식단 추천·확정에 사용할 목표와 제한 재료를 반환합니다.
     * 알레르기·제외 재료 목록도 트랜잭션 안에서 읽습니다.
     * 알레르기 사전(V13)에 있는 알레르기는 연결된 재료(포함 + 확인 필요)까지 알레르기 목록에 더합니다.
     * 예: 밀 → 간장·오트밀(확인 필요)도 제외. 저장된 프로필 값은 바꾸지 않습니다.
     */
    @Override
    public UserDietProfile getProfile(Long userId) {
        Profile profile = profileRepository.findByUserId(userId)
            .orElseThrow(() ->
                new BusinessException(ErrorCode.INTERNAL_ERROR)
            );

        Set<String> allergies = new LinkedHashSet<>(profile.getAllergies());
        allergies.addAll(allergenIngredientResolver.linkedIngredients(profile.getAllergies()));

        return new UserDietProfile(
            profile.getGoal(),
            profile.getCookTimeMin(),
            profile.getMealBudget(),
            allergies,
            profile.getExcludedIngredients()
        );
    }
}
