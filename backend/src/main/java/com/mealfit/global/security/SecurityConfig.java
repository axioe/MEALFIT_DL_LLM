package com.mealfit.global.security;

import com.mealfit.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

/**
 * 공개 API와 인증이 필요한 API를 구분하고 JWT 필터를 연결합니다.
 */
@Configuration
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtTokenProvider jwtTokenProvider;
    private final SecurityErrorHandler securityErrorHandler;
    private final UserRepository userRepository;
    // [소셜로그인] OAuth2 성공(쿠키 발급·계정 연동) 및 실패 핸들러
    private final OAuth2SuccessHandler oAuth2SuccessHandler;
    private final OAuth2FailureHandler oAuth2FailureHandler;

    @Bean
    public SecurityFilterChain securityFilterChain(
        HttpSecurity http
    ) throws Exception {

        JwtAuthenticationFilter jwtFilter =
            new JwtAuthenticationFilter(
                jwtTokenProvider,
                securityErrorHandler,
                userRepository
            );

        http
            // API 인증은 자동 전송되지 않는 Bearer 헤더를 사용합니다.
            // Refresh 쿠키를 쓰는 /refresh·/logout은 AuthController가 전용 헤더(X-Requested-With)와 Origin을 검사합니다.
            .csrf(AbstractHttpConfigurer::disable)

            // Spring 기본 로그인 화면과 HTTP Basic 인증을 사용하지 않습니다.
            .formLogin(AbstractHttpConfigurer::disable)
            .httpBasic(AbstractHttpConfigurer::disable)

            // 로그아웃은 별도 API에서 Refresh Token을 폐기합니다.
            .logout(AbstractHttpConfigurer::disable)

            // [소셜로그인] OAuth2 인가 state 저장을 위해 필요 시에만 세션을 사용하고, 일반 API는 JWT로 인증합니다.
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED)
            )

            // 인증 실패·권한 부족은 기존 ErrorResponse로 반환합니다.
            .exceptionHandling(exception -> exception
                .authenticationEntryPoint(securityErrorHandler)
                .accessDeniedHandler(securityErrorHandler)
            )

            .authorizeHttpRequests(authorize -> authorize
                .requestMatchers(
                    HttpMethod.POST,
                    "/api/v1/auth/signup",
                    "/api/v1/auth/login",
                    "/api/v1/auth/refresh",
                    "/api/v1/auth/logout",
                    // [이메일인증] 비로그인 상태에서 인증 확인·재발송 호출 허용
                    "/api/v1/auth/email-verification/confirm",
                    "/api/v1/auth/email-verification/resend"
                ).permitAll()

                // [소셜로그인] OAuth2 진입 및 콜백 경로 허용
                .requestMatchers(
                    "/oauth2/**",
                    "/login/oauth2/**"
                ).permitAll()

                // Swagger는 운영 프로필에서 별도로 비활성화됩니다.
                .requestMatchers(
                    "/swagger-ui.html",
                    "/swagger-ui/**",
                    "/v3/api-docs",
                    "/v3/api-docs/**"
                ).permitAll()

                .requestMatchers(
                    HttpMethod.GET,
                    "/actuator/health",
                    "/actuator/health/**"
                ).permitAll()

                .anyRequest().authenticated()
            )

            // [소셜로그인] Google·Naver·Kakao OAuth2 로그인 및 계정 연동 핸들러 연결
            .oauth2Login(oauth2 -> oauth2
                .successHandler(oAuth2SuccessHandler)
                .failureHandler(oAuth2FailureHandler)
            )

            .addFilterBefore(
                jwtFilter,
                UsernamePasswordAuthenticationFilter.class
            );

        return http.build();
    }
}
