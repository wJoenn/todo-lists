import { defineConfig } from "vitest/config"

export default defineConfig({
  test: {
    globals: true,
    pool: "forks",
    reporters: "verbose",
    retry: 2
  }
})
