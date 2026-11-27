import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'
import tailwindcss from '@tailwindcss/vite'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react(), tailwindcss()],
  server: {
    // Evita CORS en desarrollo: el navegador llama a /websocket en el mismo origen
    // y Vite reenvía la petición a la API de FastAPI.
    proxy: {
      '/websocket': {
        target: 'http://localhost:8000',
        changeOrigin: true,
      },
    },
  },
})
