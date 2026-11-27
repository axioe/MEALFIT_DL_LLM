import React, { useRef, useState } from "react";
import { Link, useLocation, useSearchParams } from "react-router-dom";
import { useResendEmailVerification } from "@/hooks/useAuth";
import { useLoginNavigation } from "@/hooks/useLoginNavigation";
import { getErrorCode, getErrorMessage } from "@/api/client";
import { getSocialErrorMessage, SOCIAL_PROVIDERS } from "@/models/socialAuth";
import { AlertCircle, Lock, Mail } from "lucide-react";
import { BrandLogo } from "@/components/common/BrandLogo";

/** [소셜로그인] Google·Naver·Kakao 공식 브랜드 심볼 SVG 아이콘 */
function SocialProviderIcon({ providerId }) {
  if (providerId === "google") {
    return (
      <svg className="w-4 h-4 shrink-0" viewBox="0 0 24 24" aria-hidden="true">
        <path fill="#4285F4" d="M23.49 12.27c0-.79-.07-1.55-.2-2.27H12v4.3h6.44a5.51 5.51 0 0 1-2.39 3.61v3h3.87c2.26-2.08 3.57-5.15 3.57-8.64Z" />
        <path fill="#34A853" d="M12 24c3.24 0 5.95-1.07 7.93-2.91l-3.87-3c-1.07.72-2.44 1.15-4.06 1.15-3.12 0-5.77-2.11-6.72-4.95H1.28v3.1A12 12 0 0 0 12 24Z" />
        <path fill="#FBBC05" d="M5.28 14.29A7.2 7.2 0 0 1 4.9 12c0-.8.14-1.57.38-2.29v-3.1H1.28A12 12 0 0 0 0 12c0 1.94.46 3.77 1.28 5.39l4-3.1Z" />
        <path fill="#EA4335" d="M12 4.76c1.76 0 3.34.61 4.58 1.8l3.44-3.44C17.95 1.19 15.24 0 12 0A12 12 0 0 0 1.28 6.61l4 3.1c.95-2.84 3.6-4.95 6.72-4.95Z" />
      </svg>
    );
  }
  if (providerId === "naver") {
    return (
      <svg className="w-3.5 h-3.5 shrink-0" viewBox="0 0 20 20" aria-hidden="true">
        <path fill="#FFFFFF" d="M13.56 10.7 6.17 0H0v20h6.44V9.3L13.83 20H20V0h-6.44v10.7Z" />
      </svg>
    );
  }
  if (providerId === "kakao") {
    return (
      <svg className="w-4 h-4 shrink-0" viewBox="0 0 24 24" aria-hidden="true">
        <path fill="#191919" d="M12 3C6.48 3 2 6.58 2 11c0 2.83 1.86 5.32 4.66 6.73-.15.54-.96 3.47-.99 3.7 0 0-.02.17.09.23.11.06.24.01.24.01.32-.04 3.72-2.43 4.31-2.85.55.08 1.11.12 1.69.12 5.52 0 10-3.58 10-8s-4.48-8-10-8Z" />
      </svg>
    );
  }
  return null;
}

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
    <div className="min-h-screen bg-gradient-to-b from-emerald-50/50 via-gray-50 to-white flex items-center justify-center p-4">
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

        {/* [소셜로그인] Google·Naver·Kakao 간편 로그인 버튼 */}
        <div className="space-y-2 mb-5">
          {SOCIAL_PROVIDERS.map((provider) => {
            const styleByProvider = {
              google: "bg-white hover:bg-gray-50 text-gray-800 border border-gray-300",
              naver: "bg-[#03C75A] hover:bg-[#02b351] text-white border border-transparent",
              kakao: "bg-[#FEE500] hover:bg-[#f2da00] text-[#191919] border border-transparent",
            }[provider.id];

            return (
              <a
                key={provider.id}
                href={provider.authPath}
                onClick={startSocialLogin}
                className={`w-full py-2.5 px-4 rounded-xl text-xs font-bold flex items-center justify-center gap-2 shadow-xs transition-colors min-h-[42px] ${styleByProvider}`}
              >
                <SocialProviderIcon providerId={provider.id} />
                <span>{provider.buttonText}</span>
              </a>
            );
          })}
        </div>

        <div className="relative flex py-2 items-center mb-5">
          <div className="flex-grow border-t border-gray-200"></div>
          <span className="flex-shrink mx-4 text-gray-400 text-xs font-semibold">
            또는 이메일 로그인
          </span>
          <div className="flex-grow border-t border-gray-200"></div>
        </div>

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
