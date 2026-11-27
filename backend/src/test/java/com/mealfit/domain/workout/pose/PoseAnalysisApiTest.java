package com.mealfit.domain.workout.pose;

import static org.mockito.ArgumentMatchers.any;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.requestTo;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withSuccess;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mealfit.domain.workout.pose.client.PoseAiClient;
import com.mealfit.domain.workout.pose.service.PoseAnalysisService;
import com.mealfit.support.TestJwt;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.web.client.RestClient;

/**
 * 인증·MVC·오류 응답은 실제 구성을 쓰고 AI 서비스 HTTP 응답만 대체한다. 기본 설정은 기능 플래그 꺼짐.
 * 개발자 PC의 루트 .env에 AI_POSE_ENABLED=true가 있어도 결과가 같도록, 테스트에서는 이 값을 꺼진 상태로 고정한다
 * (테스트 속성이 .env보다 우선한다).
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@TestPropertySource(properties = "AI_POSE_ENABLED=false")
class PoseAnalysisApiTest {
    static final String URL = "/api/v1/workout/pose-analyses";
    static final String EXERCISES = """
            {"modelVersion":"pose-test","exercises":[{"name":"푸시업","conditions":["척추의 중립","고개 젖힘/숙임 여부"]}]}""";
    static final String OK = """
            {"exercise":"푸시업","status":"OK","retakeCode":null,"modelVersion":"pose-test","repCount":1,
             "reps":[{"index":1,"startFrame":0,"endFrame":20,"conditions":[
                {"name":"척추의 중립","probability":0.83,"correct":true},{"name":"고개 젖힘/숙임 여부","probability":0.21,"correct":false}]}],
             "conditions":[{"name":"척추의 중립","correctReps":1,"totalReps":1,"accuracy":0.762,"accuracyBasis":"EXTERNAL","feedback":"척추의 중립: 잘 지켜졌어요."},
                           {"name":"고개 젖힘/숙임 여부","correctReps":0,"totalReps":1,"accuracy":null,"accuracyBasis":null,"feedback":"고개 젖힘/숙임 여부: 확인이 필요해요."}],
             "notice":"판정은 참고용이며 의학적 진단이 아니에요."}""";

    @Autowired MockMvc mvc;
    @org.springframework.beans.factory.annotation.Value("${ai.pose.enabled:false}") boolean poseEnabled;
    @MockitoBean PoseAnalysisService service;
    private final ObjectMapper mapper = new ObjectMapper();
    private MockRestServiceServer flask;

    @BeforeEach
    void setup() {
        var builder = RestClient.builder().baseUrl("http://flask.test");
        flask = MockRestServiceServer.bindTo(builder).build();
        var bridge = new PoseAnalysisService(new PoseAiClient(builder.build()), true);
        org.mockito.Mockito.doAnswer(call -> bridge.analyze(call.getArgument(0))).when(service).analyze(any());
        org.mockito.Mockito.doAnswer(call -> bridge.exercises()).when(service).exercises();
    }

    private String body(String exercise, int frames) throws Exception {
        List<Object> list = new ArrayList<>();
        for (int i = 0; i < frames; i++) list.add(i == 2 ? null : Collections.nCopies(33, List.of(0.1, -0.4, 0.02, 0.9)));
        return mapper.writeValueAsString(Map.of("exercise", exercise, "fps", 15, "frames", list));
    }

    // 로그인한 사용자의 요청을 판정하고 결과(조건별 판정·정확도·안내)를 그대로 돌려준다
    @Test
    void authenticatedAnalysis() throws Exception {
        flask.expect(requestTo("http://flask.test/ai/pose/exercises")).andRespond(withSuccess(EXERCISES, MediaType.APPLICATION_JSON));
        flask.expect(requestTo("http://flask.test/ai/pose/analyze")).andRespond(withSuccess(OK, MediaType.APPLICATION_JSON));
        mvc.perform(post(URL).with(TestJwt.user(31L)).contentType(MediaType.APPLICATION_JSON).content(body("푸시업", 30)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("OK"))
                .andExpect(jsonPath("$.repCount").value(1))
                .andExpect(jsonPath("$.reps[0].conditions[1].correct").value(false))
                .andExpect(jsonPath("$.conditions[0].accuracyBasis").value("EXTERNAL"))
                .andExpect(jsonPath("$.conditions[1].accuracy").doesNotExist())
                .andExpect(jsonPath("$.modelVersion").value("pose-test"));
        flask.verify();
    }

    // 지원 운동 목록 API
    @Test
    void exerciseList() throws Exception {
        flask.expect(requestTo("http://flask.test/ai/pose/exercises")).andRespond(withSuccess(EXERCISES, MediaType.APPLICATION_JSON));
        mvc.perform(get("/api/v1/workout/pose-exercises").with(TestJwt.user(31L)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.exercises[0].name").value("푸시업"))
                .andExpect(jsonPath("$.exercises[0].conditions.length()").value(2));
    }

    // 로그인하지 않으면 401, AI 서비스 호출 없음
    @Test
    void requiresLogin() throws Exception {
        mvc.perform(post(URL).contentType(MediaType.APPLICATION_JSON).content(body("푸시업", 30)))
                .andExpect(status().isUnauthorized());
        mvc.perform(get("/api/v1/workout/pose-exercises")).andExpect(status().isUnauthorized());
        flask.verify();
    }

    // 형식 오류·지원하지 않는 운동은 공통 오류 응답(code)으로
    @Test
    void errorResponses() throws Exception {
        mvc.perform(post(URL).with(TestJwt.user(31L)).contentType(MediaType.APPLICATION_JSON)
                        .content("{\"exercise\":\"푸시업\",\"fps\":2,\"frames\":[null]}"))
                .andExpect(status().isBadRequest()).andExpect(jsonPath("$.code").value("WORKOUT_POSE_001"));
        flask.expect(requestTo("http://flask.test/ai/pose/exercises")).andRespond(withSuccess(EXERCISES, MediaType.APPLICATION_JSON));
        mvc.perform(post(URL).with(TestJwt.user(31L)).contentType(MediaType.APPLICATION_JSON).content(body("없는 운동", 30)))
                .andExpect(status().isBadRequest()).andExpect(jsonPath("$.code").value("WORKOUT_POSE_002"));
        flask.verify();
    }

    // 설정 기본값은 꺼짐이고, 꺼진 서비스는 AI 서비스를 부르지 않고 503
    @Test
    void flagIsOffByDefault() throws Exception {
        // 운영 기본값: 환경 변수가 없으면 꺼짐 (application.yml의 기본값을 직접 확인한다)
        String config = new ClassPathResource("application.yml").getContentAsString(StandardCharsets.UTF_8);
        org.assertj.core.api.Assertions.assertThat(config).contains("enabled: ${AI_POSE_ENABLED:false}");
        org.assertj.core.api.Assertions.assertThat(poseEnabled).isFalse();
        var off = new PoseAnalysisService(new PoseAiClient(RestClient.builder().baseUrl("http://flask.test").build()), poseEnabled);
        org.mockito.Mockito.doAnswer(call -> off.analyze(call.getArgument(0))).when(service).analyze(any());
        mvc.perform(post(URL).with(TestJwt.user(31L)).contentType(MediaType.APPLICATION_JSON).content(body("푸시업", 30)))
                .andExpect(status().isServiceUnavailable()).andExpect(jsonPath("$.code").value("WORKOUT_POSE_003"));
    }
}
