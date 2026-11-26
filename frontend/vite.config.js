import { copyFileSync, createReadStream, mkdirSync } from 'node:fs'
import { join } from 'node:path'
import { fileURLToPath, URL } from 'node:url'
import tailwindcss from '@tailwindcss/vite'
import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'

// [자세판별] MediaPipe WASM을 외부 CDN 없이 같은 서버(/mediapipe/wasm/)에서 준다.
// 개발 서버는 node_modules에서 바로 주고, 빌드는 dist에 복사한다 (git에는 넣지 않음).
const MEDIAPIPE_WASM_DIR = fileURLToPath(new URL('./node_modules/@mediapipe/tasks-vision/wasm', import.meta.url))
const MEDIAPIPE_WASM_FILES = { 'vision_wasm_internal.js': 'text/javascript', 'vision_wasm_internal.wasm': 'application/wasm' }

function mediapipeWasm() {
  return {
    name: 'mealfit-mediapipe-wasm',
    configureServer(server) {
      server.middlewares.use('/mediapipe/wasm', (req, res, next) => {
        const name = (req.url ?? '').split('?')[0].replace(/^\//, '')
        const type = MEDIAPIPE_WASM_FILES[name]
        if (!type) return next()
        res.setHeader('Content-Type', type)
        createReadStream(join(MEDIAPIPE_WASM_DIR, name)).pipe(res)
      })
    },
    writeBundle(options) {
      const target = join(options.dir, 'mediapipe', 'wasm')
      mkdirSync(target, { recursive: true })
      for (const name of Object.keys(MEDIAPIPE_WASM_FILES)) copyFileSync(join(MEDIAPIPE_WASM_DIR, name), join(target, name))
    },
  }
}

// https://vite.dev/config/
export default defineConfig({
  plugins: [react(), tailwindcss(), mediapipeWasm()],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url)),
    },
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
