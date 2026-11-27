package com.mealfit.domain.workout.service;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.List;
import org.junit.jupiter.api.Test;

class WorkoutConditionsResolverTest {

    @Test
    void 빠진조건_안내는_받침에_맞춰_조사를_고르고_입력할_곳을_알려준다() {
        assertThat(WorkoutConditionsResolver.missingMessage(List.of("회당 운동 시간")))
            .isEqualTo("운동 조건 중 회당 운동 시간이 비어 있어요. 내 설정 > 운동 목표 & 장비에서 입력해 주세요.");
        assertThat(WorkoutConditionsResolver.missingMessage(List.of("운동 목표")))
            .isEqualTo("운동 조건 중 운동 목표가 비어 있어요. 내 설정 > 운동 목표 & 장비에서 입력해 주세요.");
        assertThat(WorkoutConditionsResolver.missingMessage(List.of("운동 목표", "주당 운동 일수")))
            .startsWith("운동 조건 중 운동 목표, 주당 운동 일수가 비어 있어요.");
    }

    @Test
    void 프로필_회당시간은_허용값_중_가까운_아래값으로_내린다() {
        assertThat(WorkoutConditionsResolver.floorMinutes(10)).isEqualTo(15);
        assertThat(WorkoutConditionsResolver.floorMinutes(40)).isEqualTo(30);
        assertThat(WorkoutConditionsResolver.floorMinutes(90)).isEqualTo(60);
    }
}
