package com.mealfit.global.config;

import ch.qos.logback.classic.PatternLayout;
import ch.qos.logback.classic.spi.ILoggingEvent;
import com.mealfit.global.common.LogMasker;

/** 메시지와 예외 스택까지 포함한 한 건의 로그 전체에서 민감한 값을 가린다 (logback-spring.xml에서 사용). */
public class MaskingPatternLayout extends PatternLayout {

    @Override
    public String doLayout(ILoggingEvent event) {
        return LogMasker.mask(super.doLayout(event));
    }
}
