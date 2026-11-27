import { SOCIAL_PROVIDER } from '@/lib/enums'
import { SOCIAL_PROVIDERS } from '@/models/socialAuth'

const buttonColors = {
  [SOCIAL_PROVIDER.GOOGLE]: 'bg-white hover:bg-gray-50 text-gray-800 border-gray-300',
  [SOCIAL_PROVIDER.NAVER]: 'bg-[#03C75A] hover:bg-[#02b351] text-white border-transparent',
  [SOCIAL_PROVIDER.KAKAO]: 'bg-[#FEE500] hover:bg-[#f2da00] text-[#191919] border-transparent',
}

/** [소셜로그인] Google·Naver·Kakao 공식 브랜드 심볼 SVG 아이콘 */
function SocialProviderIcon({ providerId }) {
  if (providerId === SOCIAL_PROVIDER.GOOGLE) {
    return (
      <svg className="w-4 h-4 shrink-0" viewBox="0 0 24 24" aria-hidden="true">
        <path fill="#4285F4" d="M23.49 12.27c0-.79-.07-1.55-.2-2.27H12v4.3h6.44a5.51 5.51 0 0 1-2.39 3.61v3h3.87c2.26-2.08 3.57-5.15 3.57-8.64Z" />
        <path fill="#34A853" d="M12 24c3.24 0 5.95-1.07 7.93-2.91l-3.87-3c-1.07.72-2.44 1.15-4.06 1.15-3.12 0-5.77-2.11-6.72-4.95H1.28v3.1A12 12 0 0 0 12 24Z" />
        <path fill="#FBBC05" d="M5.28 14.29A7.2 7.2 0 0 1 4.9 12c0-.8.14-1.57.38-2.29v-3.1H1.28A12 12 0 0 0 0 12c0 1.94.46 3.77 1.28 5.39l4-3.1Z" />
        <path fill="#EA4335" d="M12 4.76c1.76 0 3.34.61 4.58 1.8l3.44-3.44C17.95 1.19 15.24 0 12 0A12 12 0 0 0 1.28 6.61l4 3.1c.95-2.84 3.6-4.95 6.72-4.95Z" />
      </svg>
    );
  }
  if (providerId === SOCIAL_PROVIDER.NAVER) {
    return (
      <svg className="w-3.5 h-3.5 shrink-0" viewBox="0 0 20 20" aria-hidden="true">
        <path fill="#FFFFFF" d="M13.56 10.7 6.17 0H0v20h6.44V9.3L13.83 20H20V0h-6.44v10.7Z" />
      </svg>
    );
  }
  if (providerId === SOCIAL_PROVIDER.KAKAO) {
    return (
      <svg className="w-4 h-4 shrink-0" viewBox="0 0 24 24" aria-hidden="true">
        <path fill="#191919" d="M12 3C6.48 3 2 6.58 2 11c0 2.83 1.86 5.32 4.66 6.73-.15.54-.96 3.47-.99 3.7 0 0-.02.17.09.23.11.06.24.01.24.01.32-.04 3.72-2.43 4.31-2.85.55.08 1.11.12 1.69.12 5.52 0 10-3.58 10-8s-4.48-8-10-8Z" />
      </svg>
    );
  }
  return null;
}

export function SocialAuthOptions({ onContinue, emailLabel, disabled = false }) {
  return (
    <>
      <div className="mb-5 space-y-2" inert={disabled}>
        {SOCIAL_PROVIDERS.map((provider) => (
          <a
            key={provider.id}
            href={provider.authPath}
            onClick={onContinue}
            className={`flex min-h-[42px] w-full items-center justify-center gap-2 rounded-xl border px-4 py-2.5 text-xs font-bold shadow-xs transition-colors ${buttonColors[provider.id]}`}
          >
            <SocialProviderIcon providerId={provider.id} />
            <span>{provider.buttonText}</span>
          </a>
        ))}
      </div>
      <div className="mb-5 flex items-center gap-4 py-2">
        <span aria-hidden="true" className="grow border-t border-gray-200" />
        <span className="text-xs font-semibold text-gray-400">{emailLabel}</span>
        <span aria-hidden="true" className="grow border-t border-gray-200" />
      </div>
    </>
  )
}
