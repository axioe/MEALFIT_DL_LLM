package com.mealfit.global.security;

import static org.assertj.core.api.Assertions.assertThat;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Properties;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.config.YamlPropertiesFactoryBean;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.core.io.ClassPathResource;
import org.springframework.test.context.ActiveProfiles;

/** nginx 뒤에서 HTTPS로 접속하면 소셜 로그인 콜백 주소도 https로 만들어지는지 실제 Tomcat으로 확인한다. */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT,
        properties = "server.forward-headers-strategy=native")
@ActiveProfiles("test")
class ForwardedHttpsTest {

    @LocalServerPort
    private int port;

    private String callbackScheme(String forwardedProto) throws Exception {
        HttpRequest.Builder request = HttpRequest.newBuilder(
                URI.create("http://127.0.0.1:" + port + "/oauth2/authorization/kakao"));
        if (forwardedProto != null) {
            request.header("X-Forwarded-Proto", forwardedProto).header("X-Forwarded-For", "203.0.113.10");
        }
        HttpResponse<Void> response = HttpClient.newHttpClient()
                .send(request.GET().build(), HttpResponse.BodyHandlers.discarding());
        assertThat(response.statusCode()).isEqualTo(302);
        String location = response.headers().firstValue("Location").orElseThrow();
        return location.replaceAll(".*redirect_uri=([a-z]+):.*", "$1");
    }

    @Test
    void 프록시가_https를_알리면_콜백도_https() throws Exception {
        assertThat(callbackScheme("https")).isEqualTo("https");
    }

    @Test
    void http_접속이면_콜백도_http() throws Exception {
        assertThat(callbackScheme(null)).isEqualTo("http");
    }

    @Test
    void 운영_설정에_프록시_헤더_처리가_켜져_있다() {
        YamlPropertiesFactoryBean yaml = new YamlPropertiesFactoryBean();
        yaml.setResources(new ClassPathResource("application-prod.yml"));
        Properties properties = yaml.getObject();
        assertThat(properties).containsEntry("server.forward-headers-strategy", "native");
    }
}
