import { execSync } from "child_process"
import { afterEach, beforeAll } from "vitest"
import prisma from "~/libs/prisma.ts"

beforeAll(() => {
  execSync("pnpm db:migrate", { stdio: "inherit" })
})

afterEach(async () => {
  await prisma.$reset()
})
