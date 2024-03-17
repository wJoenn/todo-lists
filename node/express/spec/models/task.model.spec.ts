import type { ZodError } from "zod"
import { Prisma } from "@prisma/client"
import prismaTask from "src/models/task.model.ts"
import prismaUser from "src/models/user.model.ts"

describe("Task", () => {
  describe("associations", () => {
    it("belongs to a User", async () => {
      const user = await prismaUser.user.create({ data: { email: "user@example.com", password: "password" } })
      const task = await prismaTask.task.create({
        data: { title: "My task", userId: user.id },
        include: {
          user: true
        }
      })
      expect(task.user).toMatchObject({ id: user.id, email: user.email })
    })
  })

  describe("validations", () => {
    it("creates a new Task with proper params", async () => {
      const user = await prismaUser.user.create({ data: { email: "user@example.com", password: "password" } })
      const task = await prismaTask.task.create({ data: { title: "My task", userId: user.id } })
      expect(task.id).toBeDefined()
    })

    it("validates the presence of the title", async () => {
      const user = await prismaUser.user.create({ data: { email: "user@example.com", password: "password" } })
      const query = prismaTask.task.create({ data: { title: "", userId: user.id } })
      await expect(query).rejects.toThrowError()

      try {
        await query
      } catch (err) {
        const issues = (err as ZodError).issues
        expect(issues).toHaveLength(1)
        expect(issues.map(issue => issue.message)).toStrictEqual(["Title can't be blank"])
      }
    })

    it("validates the presence of the User", async () => {
      const query = prismaTask.task.create({ data: { title: "My task", userId: 0 } })
      await expect(query).rejects.toThrowError()

      try {
        await query
      } catch (err) {
        expect(err).toBeInstanceOf(Prisma.PrismaClientKnownRequestError)
        expect((err as Prisma.PrismaClientKnownRequestError).code).toBe("P2003")
      }
    })
  })
})
