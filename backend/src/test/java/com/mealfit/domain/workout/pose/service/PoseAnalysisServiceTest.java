package com.mealfit.domain.workout.pose.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.content;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.method;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.requestTo;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withException;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withStatus;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withSuccess;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mealfit.domain.workout.pose.client.PoseAiClient;
import com.mealfit.domain.workout.pose.dto.PoseAnalysisRequest;
import com.mealfit.global.exception.BusinessException;
import com.mealfit.global.exception.ErrorCode;
import java.net.SocketTimeoutException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.atomic.AtomicLong;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.test.web.client.ExpectedCount;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.web.client.RestClient;

/** AI 서비스 HTTP 응답만 대체해 검증·지원 운동 확인·오류 변환·응답 검증을 확인한다 (실제 AI 호출 없음). */
class PoseAnalysisServiceTest {
    static final String EXERCISES = """
            {"modelVersion":"pose-test","exercises":[
              {"name":"푸시업","conditions":["척추의 중립","고개 젖힘/숙임 여부"]},
              {"name":"플랭크","conditions":["몸통과 엉덩이의 정렬 유지"]}]}""";
    static final String OK = """
            {"exercise":"푸시업","status":"OK","retakeCode":null,"modelVersion":"pose-test","repCount":2,
             "reps":[{"index":1,"startFrame":0,"endFrame":20,"conditions":[
                        {"name":"척추의 중립","probability":0.83,"correct":true},{"name":"고개 젖힘/숙임 여부","probability":0.21,"correct":false}]},
                     {"index":2,"startFrame":20,"endFrame":41,"conditions":[
                        {"name":"척추의 중립","probability":0.79,"correct":true},{"name":"고개 젖힘/숙임 여부","probability":0.11,"correct":false}]}],
             "conditions":[{"name":"척추의 중립","correctReps":2,"totalReps":2,"accuracy":0.762,"accuracyBasis":"EXTERNAL","feedback":"척추의 중립: 잘 지켜졌어요."},
                           {"name":"고개 젖힘/숙임 여부","correctReps":0,"totalReps":2,"accuracy":0.809,"accuracyBasis":"EXTERNAL","feedback":"고개 젖힘/숙임 여부: 모든 반복에서 확인이 필요해요."}],
             "notice":"판정은 참고용이며 의학적 진단이 아니에요."}""";
    static final String RETAKE = """
            {"exercise":"푸시업","status":"RETAKE","retakeCode":"POSE_NO_PERSON","modelVersion":"pose-test","repCount":0,
             "reps":[],"conditions":[],"notice":"판정은 참고용이며 의학적 진단이 아니에요."}""";

    private final ObjectMapper mapper = new ObjectMapper();
    private MockRestServiceServer flask;
    private PoseAnalysisService service;
    private final AtomicLong now = new AtomicLong(0);

    @BeforeEach
    void setup() {
        var builder = RestClient.builder().baseUrl("http://flask.test");
        flask = MockRestServiceServer.bindTo(builder).build();
        service = new PoseAnalysisService(new PoseAiClient(builder.build()), true, now::get);
    }

    static List<List<Double>> frame() {
        return new ArrayList<>(Collections.nCopies(33, List.of(0.1, -0.4, 0.02, 0.9)));
    }

    static PoseAnalysisRequest request(String exercise, double fps, int n) {
        List<List<List<Double>>> frames = new ArrayList<>();
        for (int i = 0; i < n; i++) frames.add(i == 3 ? null : frame());  // 사람 미검출 프레임 포함
        return new PoseAnalysisRequest(exercise, fps, frames);
    }

    private void expectExercises() {
        flask.expect(requestTo("http://flask.test/ai/pose/exercises")).andExpect(method(HttpMethod.GET))
                .andRespond(withSuccess(EXERCISES, MediaType.APPLICATION_JSON));
    }

    private static ErrorCode code(Runnable call) {
        try {
            call.run();
        } catch (BusinessException e) {
            return e.getErrorCode();
        }
        throw new AssertionError("BusinessException 이 나야 한다");
    }

    // 정상: 지원 운동 확인 후 판정 결과를 그대로 전달, AI 요청 본문에는 운동·fps·좌표만
    @Test
    void analyzeSuccess() throws Exception {
        expectExercises();
        flask.expect(requestTo("http://flask.test/ai/pose/analyze")).andExpect(method(HttpMethod.POST))
                .andExpect(content().json("{\"exercise\":\"푸시업\",\"fps\":15.0}"))
                .andExpect(request -> assertThat(request.getBody().toString()).doesNotContain("userId"))
                .andRespond(withSuccess(OK, MediaType.APPLICATION_JSON));
        var result = service.analyze(request("푸시업", 15, 45));
        assertThat(result.status()).isEqualTo("OK");
        assertThat(result.repCount()).isEqualTo(2);
        assertThat(result.conditions()).extracting("accuracyBasis").containsOnly("EXTERNAL");
        assertThat(result.reps().get(0).conditions().get(1).correct()).isFalse();
        flask.verify();
    }

    // 재촬영 안내는 오류가 아니라 결과로 전달
    @Test
    void retakeIsPassedThrough() {
        expectExercises();
        flask.expect(requestTo("http://flask.test/ai/pose/analyze")).andRespond(withSuccess(RETAKE, MediaType.APPLICATION_JSON));
        var result = service.analyze(request("푸시업", 15, 20));
        assertThat(result.status()).isEqualTo("RETAKE");
        assertThat(result.retakeCode()).isEqualTo("POSE_NO_PERSON");
    }

    // 지원하지 않는 운동은 AI 판정 요청을 보내지 않고 바로 거절
    @Test
    void unsupportedExerciseIsRejectedWithoutAnalyze() {
        expectExercises();
        assertThat(code(() -> service.analyze(request("없는 운동", 15, 20)))).isEqualTo(ErrorCode.WORKOUT_POSE_UNSUPPORTED_EXERCISE);
        flask.verify();  // analyze 요청 없음
    }

    // 지원 운동 목록은 10분 동안 다시 받지 않고, 지나면 새로 받는다
    @Test
    void exerciseListIsCachedForTenMinutes() {
        flask.expect(ExpectedCount.twice(), requestTo("http://flask.test/ai/pose/exercises"))
                .andRespond(withSuccess(EXERCISES, MediaType.APPLICATION_JSON));
        service.exercises();
        now.addAndGet(PoseAnalysisService.EXERCISE_CACHE_NANOS - 1);
        assertThat(service.exercises().exercises()).hasSize(2);
        now.addAndGet(2);
        assertThat(service.exercises().modelVersion()).isEqualTo("pose-test");
        flask.verify();
    }

    // 형식 오류는 AI 서비스로 보내지 않고 400 WORKOUT_POSE_001
    @Test
    void invalidRequestsAreRejectedLocally() {
        List<PoseAnalysisRequest> bad = new ArrayList<>();
        bad.add(null);
        bad.add(new PoseAnalysisRequest("", 15.0, request("푸시업", 15, 20).frames()));
        bad.add(new PoseAnalysisRequest("가".repeat(51), 15.0, request("푸시업", 15, 20).frames()));
        bad.add(request("푸시업", 4, 20));
        bad.add(request("푸시업", 31, 20));
        bad.add(new PoseAnalysisRequest("푸시업", null, request("푸시업", 15, 20).frames()));
        bad.add(new PoseAnalysisRequest("푸시업", Double.NaN, request("푸시업", 15, 20).frames()));
        bad.add(new PoseAnalysisRequest("푸시업", 15.0, List.of()));
        bad.add(new PoseAnalysisRequest("푸시업", 15.0, null));
        bad.add(request("푸시업", 30, 901));  // 900프레임 초과
        bad.add(request("푸시업", 5, 305));   // 61초
        var shortFrame = request("푸시업", 15, 20);
        shortFrame.frames().set(0, frame().subList(0, 32));
        bad.add(shortFrame);
        for (List<Double> point : List.of(List.of(0.1, 0.2, 0.3), List.of(0.1, 0.2, 0.3, 1.5), List.of(11.0, 0.2, 0.3, 0.9),
                List.of(Double.POSITIVE_INFINITY, 0.2, 0.3, 0.9), java.util.Arrays.asList(0.1, null, 0.3, 0.9))) {
            var r = request("푸시업", 15, 20);
            var f = frame();
            f.set(5, point);
            r.frames().set(0, f);
            bad.add(r);
        }
        for (PoseAnalysisRequest r : bad) {
            assertThat(code(() -> service.analyze(r))).as(String.valueOf(r == null ? null : r.fps()))
                    .isEqualTo(ErrorCode.WORKOUT_POSE_INVALID_INPUT);
        }
        flask.verify();  // AI 서비스 호출 없음
    }

    // 900프레임(30fps·30초)과 60초(15fps·900프레임) 경계는 허용
    @Test
    void boundaryRequestsAreAccepted() {
        expectExercises();
        flask.expect(ExpectedCount.twice(), requestTo("http://flask.test/ai/pose/analyze")).andRespond(withSuccess(OK, MediaType.APPLICATION_JSON));
        assertThat(service.analyze(request("푸시업", 30, 900)).status()).isEqualTo("OK");
        assertThat(service.analyze(request("푸시업", 15, 900)).status()).isEqualTo("OK");
    }

    // AI 서비스 오류는 내용을 노출하지 않고 WORKOUT_POSE_00x 로 바꾼다
    @Test
    void upstreamErrorsAreMapped() {
        record Case(org.springframework.test.web.client.ResponseCreator response, ErrorCode expected) { }
        var cases = List.of(
                new Case(withStatus(HttpStatus.BAD_REQUEST).contentType(MediaType.APPLICATION_JSON).body("{\"code\":\"POSE_002\"}"),
                        ErrorCode.WORKOUT_POSE_UNSUPPORTED_EXERCISE),
                new Case(withStatus(HttpStatus.BAD_REQUEST).contentType(MediaType.APPLICATION_JSON).body("{\"code\":\"POSE_001\"}"),
                        ErrorCode.WORKOUT_POSE_INVALID_INPUT),
                new Case(withStatus(HttpStatus.PAYLOAD_TOO_LARGE), ErrorCode.WORKOUT_POSE_INVALID_INPUT),
                new Case(withStatus(HttpStatus.SERVICE_UNAVAILABLE).body("{\"code\":\"POSE_003\"}"), ErrorCode.WORKOUT_POSE_UNAVAILABLE),
                new Case(withStatus(HttpStatus.INTERNAL_SERVER_ERROR).body("internal secret"), ErrorCode.WORKOUT_POSE_BAD_RESPONSE),
                new Case(withException(new SocketTimeoutException("read timed out")), ErrorCode.WORKOUT_POSE_TIMEOUT),
                new Case(withException(new java.net.ConnectException("refused")), ErrorCode.WORKOUT_POSE_UNAVAILABLE),
                new Case(withSuccess("not json", MediaType.APPLICATION_JSON), ErrorCode.WORKOUT_POSE_BAD_RESPONSE));
        for (Case c : cases) {
            setup();
            expectExercises();
            flask.expect(requestTo("http://flask.test/ai/pose/analyze")).andRespond(c.response());
            assertThat(code(() -> service.analyze(request("푸시업", 15, 20)))).isEqualTo(c.expected());
        }
    }

    // 지원 운동 목록을 못 받으면 판정도 할 수 없다 (503), 목록 형식이 이상하면 502
    @Test
    void exerciseListFailures() {
        flask.expect(requestTo("http://flask.test/ai/pose/exercises")).andRespond(withStatus(HttpStatus.SERVICE_UNAVAILABLE));
        assertThat(code(() -> service.analyze(request("푸시업", 15, 20)))).isEqualTo(ErrorCode.WORKOUT_POSE_UNAVAILABLE);
        setup();
        flask.expect(requestTo("http://flask.test/ai/pose/exercises"))
                .andRespond(withSuccess("{\"modelVersion\":\"x\",\"exercises\":[{\"name\":\"푸시업\",\"conditions\":[]}]}", MediaType.APPLICATION_JSON));
        assertThat(code(() -> service.exercises())).isEqualTo(ErrorCode.WORKOUT_POSE_BAD_RESPONSE);
    }

    // AI 결과가 서로 맞지 않으면 사용자에게 보내지 않는다 (502)
    @Test
    void inconsistentResponsesAreRejected() throws Exception {
        var base = mapper.readTree(OK);
        List<String> broken = new ArrayList<>();
        broken.add(OK.replace("\"repCount\":2", "\"repCount\":3"));
        broken.add(OK.replace("\"status\":\"OK\"", "\"status\":\"DONE\""));
        broken.add(OK.replace("\"probability\":0.83", "\"probability\":1.5"));
        broken.add(OK.replace("\"accuracy\":0.762", "\"accuracy\":2.0"));
        broken.add(OK.replace("\"modelVersion\":\"pose-test\"", "\"modelVersion\":\"\""));
        broken.add(OK.replace("\"exercise\":\"푸시업\"", "\"exercise\":\"플랭크\""));
        broken.add(OK.replace("\"correctReps\":2", "\"correctReps\":5"));
        broken.add(RETAKE.replace("\"retakeCode\":\"POSE_NO_PERSON\"", "\"retakeCode\":null"));
        assertThat(base.path("repCount").asInt()).isEqualTo(2);
        for (String body : broken) {
            setup();
            expectExercises();
            flask.expect(requestTo("http://flask.test/ai/pose/analyze")).andRespond(withSuccess(body, MediaType.APPLICATION_JSON));
            assertThat(code(() -> service.analyze(request("푸시업", 15, 20)))).as(body).isEqualTo(ErrorCode.WORKOUT_POSE_BAD_RESPONSE);
        }
    }

    // 기능 플래그가 꺼져 있으면 AI 서비스를 부르지 않고 503
    @Test
    void disabledFlag() {
        var disabled = new PoseAnalysisService(new PoseAiClient(RestClient.builder().baseUrl("http://flask.test").build()), false);
        assertThatThrownBy(() -> disabled.analyze(request("푸시업", 15, 20)))
                .isInstanceOf(BusinessException.class).extracting("errorCode").isEqualTo(ErrorCode.WORKOUT_POSE_UNAVAILABLE);
        assertThat(code(disabled::exercises)).isEqualTo(ErrorCode.WORKOUT_POSE_UNAVAILABLE);
    }
}
