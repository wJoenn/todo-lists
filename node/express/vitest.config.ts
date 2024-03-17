import path from "path"
import { execSync } from "child_process"
import dotenv from "dotenv"
import { defineConfig } from "vitest/config"

process.env.PORT = "0"
dotenv.config({ path: path.resolve(__dirname, ".env.test") })

execSync("pnpm db:migrate", { stdio: "inherit" })

export default defineConfig({
  resolve: {
    alias: {
      "~": path.resolve(__dirname),
      "src": path.resolve(__dirname, "/src")
    }
  },
  test: {
    fileParallelism: false,
    globals: true,
    pool: "forks",
    reporters: "verbose",
    retry: 2,
    setupFiles: "./spec/vitest-helper.ts"
  }
})
