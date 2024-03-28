import supertest from "supertest"
import { beforeEach } from "vitest"
import app from "src/app.ts"
import prisma, { type User } from "src/models/user.model.ts"

describe("UsersRegistrationsController", () => {
  let response: supertest.Response
  const request = supertest(app)
  const email = "user@example.com"
  const password = "password"

  const createUser = async () => await prisma.user.create({ data: { email, password } })

  describe("GET /current_user", () => {
    describe("when a User is authenticated", () => {
      let user: User

      beforeEach(async () => {
        user = await createUser()
        response = await request.get("/current_user").set("Authorization", user.jwt)
      })

      it("returns a JSON object", () => {
        expect(response.type).toBe("application/json")
      })

      it("returns the instance of User", () => {
        expect(response.body).toMatchObject({ id: user.id })
      })

      it("returns a ok HTTP status", () => {
        expect(response.status).toBe(200)
      })
    })

    describe("when a User is not authenticated", () => {
      it("returns a unauthorized HTTP status", async () => {
        response = await request.get("/current_user")
        expect(response.status).toBe(401)
      })
    })
  })

  describe("POST /users", () => {
    describe("with proper params", () => {
      beforeEach(async () => {
        response = await request.post("/users").send({ user: { email, password } })
      })

      it("returns a JSON object", () => {
        expect(response.type).toBe("application/json")
      })

      it("creates an instance of User", async () => {
        await expect(prisma.user.count()).resolves.toBe(1)
      })

      it("returns the new instance of User", () => {
        expect(response.body).toMatchObject({ email })
      })

      it("returns a created HTTP status", () => {
        expect(response.status).toBe(201)
      })

      it("returns a Authorization header", async () => {
        const user = await prisma.user.findFirst()
        expect(response.headers.authorization).toBeDefined()
        expect(response.headers.authorization).toBe(user?.jwt)
      })
    })

    describe("without proper params", () => {
      beforeEach(async () => {
        response = await request.post("/users").send({ user: { email: null, password: null } })
      })

      it("returns a JSON object", () => {
        expect(response.type).toBe("application/json")
      })

      it("does not create an instance of User", async () => {
        await expect(prisma.user.count()).resolves.toBe(0)
      })

      it("returns a list of error messages", () => {
        expect(response.body).toStrictEqual({
          errors: { email: "Email can't be blank", password: "Password can't be blank" }
        })
      })

      it("returns a unprocessable_entity HTTP status", () => {
        expect(response.status).toBe(422)
      })
    })
  })
})
