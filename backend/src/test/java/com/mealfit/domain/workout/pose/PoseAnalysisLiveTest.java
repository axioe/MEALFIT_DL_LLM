package com.mealfit.domain.workout.pose;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.mealfit.support.TestJwt;
import java.nio.file.Files;
import java.nio.file.Path;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.EnabledIfEnvironmentVariable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.springframework.test.web.servlet.MockMvc;

/**
 * 실제 AI 서비스(모델 연결)까지 끝까지 확인한다. 평소·CI에서는 건너뛴다.
 * 실행: MEALFIT_LIVE_POSE_URL=http://127.0.0.1:8000 (POSE_MODEL_DIR 지정한 ai-service),
 *       선택 MEALFIT_LIVE_POSE_SAMPLE=푸시업 관절 좌표 JSON 파일 경로(요청 본문 형식)
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@EnabledIfEnvironmentVariable(named = "MEALFIT_LIVE_POSE_URL", matches = ".+")
class PoseAnalysisLiveTest {
    @Autowired MockMvc mvc;

    @DynamicPropertySource
    static void live(DynamicPropertyRegistry registry) {
        registry.add("mealfit.ai.base-url", () -> System.getenv("MEALFIT_LIVE_POSE_URL"));
        registry.add("ai.pose.enabled", () -> "true");
    }

    @Test
    void liveExercisesAndAnalysis() throws Exception {
        mvc.perform(get("/api/v1/workout/pose-exercises").with(TestJwt.user(41L)))
                .andExpect(status().isOk()).andExpect(jsonPath("$.exercises.length()").value(41));
        String nobody = "{\"exercise\":\"푸시업\",\"fps\":15,\"frames\":[" + "null,".repeat(19) + "null]}";
        mvc.perform(post("/api/v1/workout/pose-analyses").with(TestJwt.user(41L)).contentType(MediaType.APPLICATION_JSON).content(nobody))
                .andExpect(status().isOk()).andExpect(jsonPath("$.status").value("RETAKE"))
                .andExpect(jsonPath("$.retakeCode").value("POSE_NO_PERSON"));
        mvc.perform(post("/api/v1/workout/pose-analyses").with(TestJwt.user(41L)).contentType(MediaType.APPLICATION_JSON)
                        .content(nobody.replace("푸시업", "없는 운동")))
                .andExpect(status().isBadRequest()).andExpect(jsonPath("$.code").value("WORKOUT_POSE_002"));
        String sample = System.getenv("MEALFIT_LIVE_POSE_SAMPLE");
        if (sample != null && !sample.isBlank()) {
            mvc.perform(post("/api/v1/workout/pose-analyses").with(TestJwt.user(41L)).contentType(MediaType.APPLICATION_JSON)
                            .content(Files.readString(Path.of(sample))))
                    .andExpect(status().isOk()).andExpect(jsonPath("$.status").value("OK"))
                    .andExpect(jsonPath("$.repCount").value(org.hamcrest.Matchers.greaterThan(0)))
                    .andExpect(jsonPath("$.conditions[0].accuracy").isNumber());
        }
    }
}
