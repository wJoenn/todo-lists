import type { ZodError } from "zod"
import prisma from "src/models/task.model.ts"

describe("Task", () => {
  describe("validations", () => {
    it("creates a new Task with proper params", async () => {
      const task = await prisma.task.create({ data: { title: "My task" } })
      expect(task.id).toBeDefined()
    })

    it("validates the presence of the title", async () => {
      const query = prisma.task.create({ data: { title: "" } })
      await expect(query).rejects.toThrowError()

      try {
        await query
      } catch (err) {
        const issues = (err as ZodError).issues
        expect(issues).toHaveLength(1)
        expect(issues.map(issue => issue.message)).toStrictEqual(["Title can't be blank"])
      }
    })
  })
})
