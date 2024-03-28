import supertest from "supertest"
import { beforeEach } from "vitest"
import app from "src/app.ts"
import prisma, { type User } from "src/models/user.model.ts"

describe("UsersSessionsControler", () => {
  let response: supertest.Response
  const request = supertest(app)
  const email = "user@example.com"
  const password = "password"
  let user: User

  const createUser = async () => await prisma.user.create({ data: { email, password } })

  beforeEach(async () => {
    user = await createUser()
  })

  describe("POST /users/sign_in", () => {
    describe("with proper params", () => {
      beforeEach(async () => {
        response = await request.post("/users/sign_in").send({ user: { email, password } })
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

      it("returns a Authorization header", () => {
        expect(response.headers.authorization).toBeDefined()
        expect(response.headers.authorization).toBe(user.jwt)
      })
    })

    describe("without proper params", () => {
      beforeEach(async () => {
        response = await request.post("/users/sign_in").send({ user: { email: null, password: null } })
      })

      it("returns a JSON object", () => {
        expect(response.type).toBe("application/json")
      })

      it("returns a list of error messages", () => {
        expect(response.body).toStrictEqual({ errors: { user: "Invalid Email or Password" } })
      })

      it("returns a unauthoriazed HTTP status", () => {
        expect(response.status).toBe(401)
      })
    })
  })

  describe("DELETE  /users/sign_out", () => {
    describe("when a User is authenticated", () => {
      beforeEach(async () => {
        response = await request.delete("/users/sign_out").set("Authorization", user.jwt)
      })

      it("signs the User out", async () => {
        response = await request.get("/current_user").set("Authorization", user.jwt)
        expect(response.status).toBe(401)
      })

      it("returns a ok HTTP status", () => {
        expect(response.status).toBe(200)
      })
    })

    describe("when a User is not authenticated", () => {
      beforeEach(async () => {
        response = await request.delete("/users/sign_out")
      })

      it("returns a unauthorized HTTP status", () => {
        expect(response.status).toBe(401)
      })
    })
  })
})
