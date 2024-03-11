import path from "path"
import dotenv from "dotenv"
import { defineConfig } from "vitest/config"

dotenv.config({ path: path.resolve(__dirname, ".env.test") })

export default defineConfig({
  resolve: {
    alias: {
      "~": path.resolve(__dirname),
      "src": path.resolve(__dirname, "/src")
    }
  },
  test: {
    globals: true,
    pool: "forks",
    reporters: "verbose",
    retry: 2,
    setupFiles: "./spec/vitest-helper.ts"
  }
})
