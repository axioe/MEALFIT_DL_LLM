import React, { useRef, useState } from "react";
import { Link, useLocation, useSearchParams } from "react-router-dom";
import { useResendEmailVerification } from "@/hooks/useAuth";
import { useLoginNavigation } from "@/hooks/useLoginNavigation";
import { getErrorCode, getErrorMessage } from "@/api/client";
import { getSocialErrorMessage } from "@/models/socialAuth";
import { AlertCircle, Lock, Mail } from "lucide-react";
import { BrandLogo } from "@/components/common/BrandLogo";
import { SocialAuthOptions } from "@/components/common/SocialAuthOptions";

export function LoginPage() {
  const location = useLocation();
  const [searchParams] = useSearchParams();
  const [email, setEmail] = useState(location.state?.email ?? "");
  const [password, setPassword] = useState("");
  const [resendNotice, setResendNotice] = useState("");
  const { login, submitLogin, startSocialLogin } = useLoginNavigation();
  const resend = useResendEmailVerification();
  const submitLock = useRef(false);

  // [소셜로그인] OAuth2 실패 또는 기존 이메일 중복 안내 쿼리(?oauthError=...) 표시
  const oauthErrorMessage = getSocialErrorMessage(searchParams.get("oauthError"));

  // 저장 중 상태와 서버 오류를 기존 화면 영역에 연결합니다.
  const isSubmitting = login.isPending;
  const error = login.isError
    ? getErrorMessage(login.error, "로그인하지 못했습니다.")
    : oauthErrorMessage;
  // [이메일인증] AUTH_006(미인증 계정) 오류일 때 재발송 버튼을 노출합니다.
  const isEmailNotVerified =
    login.isError && getErrorCode(login.error) === "AUTH_006";

  /** 입력을 전송하고 성공하면 로그인 정보를 저장한 뒤 이동합니다. */
  async function handleSubmit(event) {
    event.preventDefault();

    if (submitLock.current) return;
    submitLock.current = true;
    setResendNotice("");

    try {
      await submitLogin({ email, password });
    } catch {
      // useLogin이 보관한 오류를 위의 error 문구로 표시합니다.
    } finally {
      submitLock.current = false;
    }
  }

  /** [이메일인증] 미인증 로그인 실패 시 인증 메일을 다시 요청합니다. */
  async function handleResend() {
    const trimmed = email.trim();
    if (!trimmed || resend.isPending) return;
    setResendNotice("");
    try {
      await resend.mutateAsync(trimmed);
      setResendNotice("인증 메일을 다시 발송했습니다. 메일함을 확인해 주세요.");
    } catch (err) {
      setResendNotice(getErrorMessage(err, "인증 메일을 다시 보내지 못했습니다."));
    }
  }

  return (
    <div className="min-h-dvh bg-gradient-to-b from-emerald-50/50 via-gray-50 to-white flex items-center justify-center p-4">
      <div className="bg-white rounded-3xl p-6 sm:p-10 border border-gray-200 shadow-lg max-w-md w-full">
        {/* Brand */}
        <div className="text-center mb-8">
          <BrandLogo className="w-14 h-14 mx-auto mb-3" />
          <h1 className="text-2xl font-black text-gray-900 tracking-tight">
            MealFit{" "}
            <span className="text-emerald-600 text-base font-bold">밀핏</span>
          </h1>
          <p className="text-xs text-gray-500 mt-1">
            냉장고 재료를 활용한 AI 맞춤 식단 & 스마트 웰니스
          </p>
        </div>

        <SocialAuthOptions onContinue={startSocialLogin} emailLabel="또는 이메일 로그인" />

        {location.state?.withdrawn && (
          <p role="status" className="mb-4 rounded-xl border border-emerald-200 bg-emerald-50 p-3 text-sm text-emerald-800">
            회원 탈퇴가 완료되었습니다.
          </p>
        )}

        {location.state?.verified && (
          <p role="status" className="mb-4 rounded-xl border border-emerald-200 bg-emerald-50 p-3 text-xs text-emerald-800">
            이메일 인증이 완료되었습니다. 로그인해 주세요.
          </p>
        )}

        {error && (
          <div
            role="alert"
            className="mb-4 p-3 rounded-xl bg-rose-50 border border-rose-200 text-rose-800 text-xs space-y-2"
          >
            <div className="flex items-center gap-2">
              <AlertCircle className="w-4 h-4 text-rose-600 shrink-0" />
              <span>{error}</span>
            </div>
            {isEmailNotVerified && (
              <button
                type="button"
                onClick={handleResend}
                disabled={resend.isPending}
                className="w-full py-2 rounded-lg bg-white border border-rose-200 text-rose-700 font-bold hover:bg-rose-100/50 cursor-pointer disabled:opacity-50"
              >
                {resend.isPending ? "재발송 중..." : "인증 메일 다시 보내기"}
              </button>
            )}
          </div>
        )}

        {resendNotice && (
          <p role="status" className="mb-4 rounded-xl border border-emerald-200 bg-emerald-50 p-3 text-xs text-emerald-800">
            {resendNotice}
          </p>
        )}

        <form onSubmit={handleSubmit} className="space-y-4 text-xs">
          <div>
            <label
              htmlFor="login-email"
              className="font-bold text-gray-700 block mb-1"
            >
              이메일 주소
            </label>
            <div className="relative">
              <Mail className="w-4 h-4 text-gray-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
              <input
                id="login-email"
                type="email"
                autoComplete="username"
                disabled={isSubmitting}
                maxLength={254}
                required
                placeholder="name@example.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="w-full pl-10 pr-4 py-2.5 rounded-xl border border-gray-300 text-sm focus:outline-emerald-500"
              />
            </div>
          </div>

          <div>
            <label
              htmlFor="login-password"
              className="font-bold text-gray-700 block mb-1"
            >
              비밀번호
            </label>
            <div className="relative">
              <Lock className="w-4 h-4 text-gray-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
              <input
                id="login-password"
                type="password"
                autoComplete="current-password"
                disabled={isSubmitting}
                required
                placeholder="비밀번호 입력"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full pl-10 pr-4 py-2.5 rounded-xl border border-gray-300 text-sm focus:outline-emerald-500"
              />
            </div>
          </div>

          <button
            type="submit"
            className="w-full py-2.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-sm shadow-xs min-h-[44px] cursor-pointer disabled:opacity-50"
            disabled={isSubmitting}
          >
            {isSubmitting ? "로그인 중..." : "로그인"}
          </button>
        </form>

        <div className="text-center mt-6 pt-4 border-t border-gray-100 text-xs text-gray-500">
          아직 계정이 없으신가요?{" "}
          <Link
            to="/signup"
            state={{ from: location.state?.from }}
            className="text-emerald-700 font-bold hover:underline"
          >
            회원가입하기
          </Link>
          <div className="mt-3"><Link to="/dashboard" className="font-semibold text-gray-600 hover:underline">로그인 없이 둘러보기</Link></div>
        </div>
      </div>
    </div>
  );
}
