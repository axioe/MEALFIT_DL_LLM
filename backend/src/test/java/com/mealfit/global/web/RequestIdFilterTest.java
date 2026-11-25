package com.mealfit.global.web;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import jakarta.servlet.ServletException;
import java.util.concurrent.atomic.AtomicReference;
import org.junit.jupiter.api.Test;
import org.slf4j.MDC;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;

class RequestIdFilterTest {

    private final RequestIdFilter filter = new RequestIdFilter();

    private String run(String received) throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest();
        if (received != null) {
            request.addHeader(RequestIdFilter.HEADER, received);
        }
        MockHttpServletResponse response = new MockHttpServletResponse();
        AtomicReference<String> logged = new AtomicReference<>();
        filter.doFilter(request, response, (req, res) -> logged.set(MDC.get(RequestIdFilter.MDC_KEY)));
        assertThat(logged.get()).isEqualTo(response.getHeader(RequestIdFilter.HEADER));
        assertThat(MDC.get(RequestIdFilter.MDC_KEY)).isNull();
        return logged.get();
    }

    @Test
    void 없으면_새로_만들고_로그와_응답이_같다() throws Exception {
        assertThat(run(null)).hasSize(36);
        assertThat(run(null)).isNotEqualTo(run(null));
    }

    @Test
    void 앞단이_준_올바른_값은_이어_쓴다() throws Exception {
        assertThat(run("0123456789abcdef0123456789abcdef")).isEqualTo("0123456789abcdef0123456789abcdef");
    }

    @Test
    void 줄바꿈이나_길이가_맞지_않는_값은_버린다() throws Exception {
        assertThat(run("abc\r\nfake log line")).hasSize(36);
        assertThat(run("a".repeat(65))).hasSize(36);
        assertThat(run("short")).hasSize(36);
    }

    @Test
    void 처리_중_예외가_나도_MDC를_비운다() {
        assertThatThrownBy(() -> filter.doFilter(new MockHttpServletRequest(), new MockHttpServletResponse(),
                (req, res) -> {
                    throw new ServletException("boom");
                })).isInstanceOf(ServletException.class);
        assertThat(MDC.get(RequestIdFilter.MDC_KEY)).isNull();
    }
}
