import type { ZodError } from "zod"
import bcrypt from "bcrypt"
import prisma from "src/models/user.model.ts"

describe("User", () => {
  const email = "user@example.com"
  const password = "password"

  describe("validations", () => {
    it("creates a new User with proper params", async () => {
      const user = await prisma.user.create({ data: { email, password } })
      expect(user.id).toBeDefined()
    })

    it("validates the presence of the email", async () => {
      const query = prisma.user.create({ data: { email: "", password } })
      await expect(query).rejects.toThrowError()

      try {
        await query
      } catch (err) {
        const issues = (err as ZodError).issues
        expect(issues).toHaveLength(1)
        expect(issues.map(issue => issue.message)).toStrictEqual(["Email can't be blank"])
      }
    })

    it("validates the format of the email", async () => {
      const query = prisma.user.create({ data: { email: "wrong@example", password } })
      await expect(query).rejects.toThrowError()

      try {
        await query
      } catch (err) {
        const issues = (err as ZodError).issues
        expect(issues).toHaveLength(1)
        expect(issues.map(issue => issue.message)).toStrictEqual(["Email is invalid"])
      }
    })

    it("validates the uniqueness of the email", async () => {
      await prisma.user.create({ data: { email, password } })

      const query = prisma.user.create({ data: { email, password } })
      await expect(query).rejects.toThrowError()

      try {
        await query
      } catch (err) {
        const issues = (err as ZodError).issues
        expect(issues).toHaveLength(1)
        expect(issues.map(issue => issue.message)).toStrictEqual(["Email has already been taken"])
      }
    })

    it("validates the presence of the password", async () => {
      const query = prisma.user.create({ data: { email, password: "" } })
      await expect(query).rejects.toThrowError()

      try {
        await query
      } catch (err) {
        const issues = (err as ZodError).issues
        expect(issues).toHaveLength(1)
        expect(issues.map(issue => issue.message)).toStrictEqual(["Password can't be blank"])
      }
    })

    it("validates the similarity of the password_confirmation and the password", async () => {
      const query = prisma.user.create({ data: { email, password, password_confirmation: "wrong" } })
      await expect(query).rejects.toThrowError()

      try {
        await query
      } catch (err) {
        const issues = (err as ZodError).issues
        expect(issues).toHaveLength(1)
        expect(issues.map(issue => issue.message)).toStrictEqual(["Password confirmation doesn't match Password"])
      }
    })
  })

  describe("password", () => {
    it("returns the User password as a hash string", async () => {
      const user = await prisma.user.create({ data: { email, password } })
      expect(user.password).not.toBe(password)
      await expect(bcrypt.compare(password, user.password)).resolves.toBe(true)
    })
  })

  describe("toJSON", () => {
    it("does not render the User's password", async () => {
      const user = await prisma.user.create({ data: { email, password } })
      expect("password" in user.toJSON).toBe(false)
    })
  })
})
