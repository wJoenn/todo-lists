import { Prisma, PrismaClient } from "@prisma/client"

const prisma = new PrismaClient().$extends({
  client: {
    $reset: async () => {
      const tables = Prisma.dmmf.datamodel.models.map(model => model.name).filter(table => table)

      await prisma.$transaction(
        tables.map(table => prisma.$executeRawUnsafe(`TRUNCATE "${table}" RESTART IDENTITY CASCADE;`))
      )
    }
  }
})

export default prisma
