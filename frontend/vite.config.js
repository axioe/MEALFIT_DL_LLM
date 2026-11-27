import { copyFileSync, createReadStream, mkdirSync } from 'node:fs'
import { join } from 'node:path'
import { fileURLToPath, URL } from 'node:url'
import tailwindcss from '@tailwindcss/vite'
import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'

// [자세판별] 브라우저에서 쓰는 WASM 파일을 외부 CDN 없이 같은 서버에서 준다.
// - /mediapipe/wasm/: MediaPipe 관절 추출
// - /ffmpeg/: 브라우저가 직접 재생하지 못하는 영상(HEVC 등)을 기기 안에서 풀 때만 내려받는 ffmpeg.wasm 코어
// 개발 서버는 node_modules에서 바로 주고, 빌드는 dist에 복사한다 (git에는 넣지 않음).
const POSE_WASM_ASSETS = [
  {
    route: '/mediapipe/wasm',
    dir: fileURLToPath(new URL('./node_modules/@mediapipe/tasks-vision/wasm', import.meta.url)),
    files: { 'vision_wasm_internal.js': 'text/javascript', 'vision_wasm_internal.wasm': 'application/wasm' },
  },
  {
    route: '/ffmpeg',
    dir: fileURLToPath(new URL('./node_modules/@ffmpeg/core/dist/esm', import.meta.url)),
    files: { 'ffmpeg-core.js': 'text/javascript', 'ffmpeg-core.wasm': 'application/wasm' },
  },
]

function poseWasmAssets() {
  return {
    name: 'mealfit-pose-wasm',
    configureServer(server) {
      for (const asset of POSE_WASM_ASSETS) {
        server.middlewares.use(asset.route, (req, res, next) => {
          const name = (req.url ?? '').split('?')[0].replace(/^\//, '')
          const type = asset.files[name]
          if (!type) return next()
          res.setHeader('Content-Type', type)
          createReadStream(join(asset.dir, name)).pipe(res)
        })
      }
    },
    writeBundle(options) {
      for (const asset of POSE_WASM_ASSETS) {
        const target = join(options.dir, ...asset.route.split('/').filter(Boolean))
        mkdirSync(target, { recursive: true })
        for (const name of Object.keys(asset.files)) copyFileSync(join(asset.dir, name), join(target, name))
      }
    },
  }
}

// https://vite.dev/config/
export default defineConfig({
  plugins: [react(), tailwindcss(), poseWasmAssets()],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url)),
    },
  },
  // ffmpeg.wasm은 자체 Worker를 상대 경로로 띄우므로 개발 서버의 사전 번들링에서 뺀다
  optimizeDeps: {
    exclude: ['@ffmpeg/ffmpeg'],
  },
  server: {
    port: 5173,
    // 브라우저는 /api만 호출하고, 개발 서버가 Spring(8080)으로 넘긴다 → CORS 신경 쓸 필요 없음
    proxy: {
      '/api': {
        target: process.env.VITE_API_PROXY_TARGET ?? 'http://localhost:8080',
        changeOrigin: true,
      },
      // [소셜로그인] OAuth2 인가 시작 및 콜백 경로를 백엔드(8080)로 프록시합니다.
      '/oauth2': {
        target: process.env.VITE_API_PROXY_TARGET ?? 'http://localhost:8080',
        changeOrigin: true,
      },
      '/login/oauth2': {
        target: process.env.VITE_API_PROXY_TARGET ?? 'http://localhost:8080',
        changeOrigin: true,
      },
    },
  },
})
