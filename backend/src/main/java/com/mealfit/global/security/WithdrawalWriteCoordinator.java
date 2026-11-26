package com.mealfit.global.security;

import jakarta.servlet.ServletException;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.locks.ReentrantReadWriteLock;

/** 같은 회원의 진행 중인 API 쓰기가 끝난 뒤 탈퇴를 실행합니다. */
final class WithdrawalWriteCoordinator {
    private final Map<Long, Entry> locks = new HashMap<>();

    void run(Long userId, boolean withdrawal, RequestAction action) throws IOException, ServletException {
        Entry entry;
        synchronized (locks) {
            entry = locks.computeIfAbsent(userId, ignored -> new Entry());
            entry.references++;
        }
        var lock = withdrawal ? entry.lock.writeLock() : entry.lock.readLock();
        lock.lock();
        try {
            action.run();
        } finally {
            lock.unlock();
            synchronized (locks) {
                if (--entry.references == 0) {
                    locks.remove(userId);
                }
            }
        }
    }

    private static final class Entry {
        final ReentrantReadWriteLock lock = new ReentrantReadWriteLock(true);
        int references;
    }

    @FunctionalInterface
    interface RequestAction {
        void run() throws IOException, ServletException;
    }
}
