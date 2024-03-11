// Add seed here
import { PrismaClient } from "@prisma/client"

const prisma = new PrismaClient()

await prisma.task.create({
  data: {
    title: "My task"
  }
})
