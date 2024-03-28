import type { ZodError } from "zod"
import bcrypt from "bcrypt"
import prismaTask from "src/models/task.model.ts"
import prismaUser from "src/models/user.model.ts"

describe("User", () => {
  const email = "user@example.com"
  const password = "password"

  const createUser = async () => await prismaUser.user.create({ data: { email, password } })

  describe("associations", () => {
    it("has many Task", async () => {
      const userId = (await createUser()).id
      await prismaTask.task.create({ data: { title: "My task", userId } })
      const user = await prismaUser.user.findUnique({ include: { tasks: true }, where: { id: userId } })

      expect(user).toBeDefined()
      user?.tasks?.forEach(task => {
        expect("id" in task).toBeTruthy()
      })
    })
  })

  describe("validations", () => {
    it("creates a new User with proper params", async () => {
      const user = await createUser()
      expect(user.id).toBeDefined()
    })

    it("validates the presence of the email", async () => {
      const query = prismaUser.user.create({ data: { email: "", password } })
      await expect(query).rejects.toThrowError()

      try {
        await query
      } catch (err) {
        const { issues } = err as ZodError
        expect(issues).toHaveLength(1)
        expect(issues.map(issue => issue.message)).toStrictEqual(["Email can't be blank"])
      }
    })

    it("validates the format of the email", async () => {
      const query = prismaUser.user.create({ data: { email: "wrong@example", password } })
      await expect(query).rejects.toThrowError()

      try {
        await query
      } catch (err) {
        const { issues } = err as ZodError
        expect(issues).toHaveLength(1)
        expect(issues.map(issue => issue.message)).toStrictEqual(["Email is invalid"])
      }
    })

    it("validates the uniqueness of the email", async () => {
      await createUser()

      const query = prismaUser.user.create({ data: { email, password } })
      await expect(query).rejects.toThrowError()

      try {
        await query
      } catch (err) {
        const { issues } = err as ZodError
        expect(issues).toHaveLength(1)
        expect(issues.map(issue => issue.message)).toStrictEqual(["Email has already been taken"])
      }
    })

    it("validates the presence of the password", async () => {
      const query = prismaUser.user.create({ data: { email, password: "" } })
      await expect(query).rejects.toThrowError()

      try {
        await query
      } catch (err) {
        const { issues } = err as ZodError
        expect(issues).toHaveLength(1)
        expect(issues.map(issue => issue.message)).toStrictEqual(["Password can't be blank"])
      }
    })

    it("validates the similarity of the password_confirmation and the password", async () => {
      const query = prismaUser.user.create({ data: { email, password, password_confirmation: "wrong" } })
      await expect(query).rejects.toThrowError()

      try {
        await query
      } catch (err) {
        const { issues } = err as ZodError
        expect(issues).toHaveLength(1)
        expect(issues.map(issue => issue.message)).toStrictEqual(["Password confirmation doesn't match Password"])
      }
    })
  })

  describe("byJWT", () => {
    it("returns the user when called with the User jti", async () => {
      const user = await createUser()
      const foundUser = await prismaUser.user.byJWT(user.jwt)

      expect(foundUser).toBeDefined()
    })

    it("returns undefined when called with an incorrect jti", async () => {
      const foundUser = await prismaUser.user.byJWT("")
      expect(foundUser).toBeUndefined()
    })
  })

  describe("editJTI", () => {
    it("edits the User jti", async () => {
      const user = await createUser()
      const oldJTI = user.jti
      await user.editJTI()

      expect(oldJTI).not.toBe(user.jti)
    })
  })

  describe("jwt", () => {
    it("returns a Bearer User token", async () => {
      const user = await createUser()
      expect(user.jwt).toMatch(/^Bearer \w+/)
    })
  })

  describe("password", () => {
    it("returns the User password as a hash string", async () => {
      const user = await createUser()
      expect(user.password).not.toBe(password)
      await expect(bcrypt.compare(password, user.password)).resolves.toBe(true)
    })
  })

  describe("toJSON", () => {
    it("does not render the User's jti", async () => {
      const user = await createUser()
      expect("jti" in user.toJSON()).toBe(false)
    })

    it("does not render the User's password", async () => {
      const user = await createUser()
      expect("password" in user.toJSON()).toBe(false)
    })
  })
})
