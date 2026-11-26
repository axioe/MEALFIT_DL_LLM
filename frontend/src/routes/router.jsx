import { RequireAuth } from '@/routes/RequireAuth';
import { createBrowserRouter, Navigate } from 'react-router-dom';
import { AppLayout } from '@/components/layout/AppLayout';
const page = (load, name) => async () => ({ Component: (await load())[name] });
export const router = createBrowserRouter([
    { children: [
            { path: '/login', lazy: page(() => import('@/pages/LoginPage'), 'LoginPage') },
            { path: '/signup', lazy: page(() => import('@/pages/SignupPage'), 'SignupPage') },
            // [이메일인증] 메일 링크 검증용 공개 라우트
            { path: '/verify-email', lazy: page(() => import('@/pages/VerifyEmailPage'), 'VerifyEmailPage') },
        ] },
    // 공개 로그인 화면을 제외한 모든 업무 화면은 서버 인증 후 표시합니다.
    { element: <RequireAuth />, children: [
        { element: <AppLayout />, children: [
            { path: '/', element: <Navigate to="/dashboard" replace/> },
            { path: '/dashboard', lazy: page(() => import('@/pages/DashboardPage'), 'DashboardPage') },
            { path: '/recommend', lazy: page(() => import('@/pages/RecommendPage'), 'RecommendPage') },
            { path: '/recipes/:id', lazy: page(() => import('@/pages/RecipeDetailPage'), 'RecipeDetailPage') },
            { path: '/fridge', lazy: page(() => import('@/pages/FridgePage'), 'FridgePage') },
            { path: '/shopping', lazy: page(() => import('@/pages/ShoppingPage'), 'ShoppingPage') },
            { path: '/workout', lazy: page(() => import('@/pages/WorkoutPage'), 'WorkoutPage') },
            { path: '/calendar', lazy: page(() => import('@/pages/CalendarPage'), 'CalendarPage') },
            { path: '/weight', lazy: page(() => import('@/pages/WeightPage'), 'WeightPage') },
            { path: '/mypage', lazy: page(() => import('@/pages/MyPage'), 'MyPage') },
            // [자세판별] 개발 서버 전용: 운동 화면 연결 전 자세 분석 패널 확인
            ...(import.meta.env.DEV ? [{ path: '/dev/pose', lazy: page(() => import('@/pages/PoseDevPage'), 'PoseDevPage') }] : []),
        ] },
    ] },
    { path: '*', element: <Navigate to="/dashboard" replace/> },
]);
