import { afterEach } from "vitest"
import prisma from "~/libs/prisma.ts"

afterEach(async () => {
  await prisma.$reset()
})
