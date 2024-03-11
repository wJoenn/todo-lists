import { z as zod } from "zod"
import { Prisma } from "@prisma/client"
import prisma from "~/libs/prisma.ts"

const TaskSchema = zod.object({
  title: zod.string().min(1)
}) satisfies zod.Schema<Prisma.TaskUncheckedCreateInput>

export default prisma.$extends({
  query: {
    task: {
      create: ({ args, query }) => {
        args.data = TaskSchema.parse(args.data)
        return query(args)
      },
      update: ({ args, query }) => {
        args.data = TaskSchema.partial().parse(args.data)
        return query(args)
      }
    }
  }
})
