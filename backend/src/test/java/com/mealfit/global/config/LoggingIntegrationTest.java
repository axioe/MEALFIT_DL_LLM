package com.mealfit.global.config;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import ch.qos.logback.classic.Level;
import ch.qos.logback.classic.LoggerContext;
import ch.qos.logback.classic.spi.LoggingEvent;
import ch.qos.logback.core.ConsoleAppender;
import ch.qos.logback.core.encoder.LayoutWrappingEncoder;
import com.mealfit.global.web.RequestIdFilter;
import java.util.Map;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

/** 실제 애플리케이션 설정(logback-spring.xml)에서 요청 식별자와 로그 가림이 동작하는지 확인한다. */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class LoggingIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void 인증_실패_응답에도_요청_식별자가_있다() throws Exception {
        mockMvc.perform(get("/api/v1/me").header(RequestIdFilter.HEADER, "test-request-0001"))
                .andExpect(status().isUnauthorized())
                .andExpect(header().string(RequestIdFilter.HEADER, "test-request-0001"));
    }

    @Test
    @SuppressWarnings("unchecked")
    void 로그에_요청_식별자를_남기고_메시지와_예외의_민감한_값을_가린다() {
        LoggerContext context = (LoggerContext) LoggerFactory.getILoggerFactory();
        ch.qos.logback.classic.Logger logger = context.getLogger("sample");
        var appender = (ConsoleAppender<ch.qos.logback.classic.spi.ILoggingEvent>)
                context.getLogger(Logger.ROOT_LOGGER_NAME).getAppender("CONSOLE");
        var layout = ((LayoutWrappingEncoder<ch.qos.logback.classic.spi.ILoggingEvent>) appender.getEncoder()).getLayout();
        LoggingEvent event = new LoggingEvent("sample", logger, Level.WARN,
                "link /verify-email?token=secretvalue", new IllegalStateException("dup user@example.com"), null);
        event.setMDCPropertyMap(Map.of(RequestIdFilter.MDC_KEY, "test-request-0002"));

        assertThat(layout.doLayout(event))
                .contains("[test-request-0002]", "token=***", "u***@example.com")
                .doesNotContain("secretvalue", "user@example.com");
    }
}
