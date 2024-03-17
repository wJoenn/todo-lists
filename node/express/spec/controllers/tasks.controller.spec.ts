import type { Prisma } from "@prisma/client"
import type { User } from "src/models/user.model.ts"
import supertest from "supertest"
import { beforeEach } from "vitest"
import app from "src/app.ts"
import prismaTask from "src/models/task.model.ts"
import prismaUser from "src/models/user.model.ts"

describe("TasksController", () => {
  let response: supertest.Response
  const request = supertest(app)
  const title = "My task"
  let user: User

  const createTask = async () => await prismaTask.task.create({ data: { title, userId: user.id } })
  const createUser = async () => await prismaUser.user.create({
    data: { email: "user@example.com", password: "password" }
  })

  describe("GET /tasks", () => {
    beforeEach(async () => {
      user = await createUser()
      await createTask()
      response = await request.get("/tasks")
    })

    describe("when a User is authenticated", () => {
      beforeEach(async () => {
        response = await request.get("/tasks").set("Authorization", user.jwt)
      })

      it("returns a JSON type response", () => {
        expect(response.type).toBe("application/json")
      })

      it("returns a list of Task", () => {
        expect(response.body).toMatchObject([{ id: 1, title }])
      })

      it("returns a ok HTTP status", () => {
        expect(response.status).toBe(200)
      })
    })

    describe("when a User is not authenticated", () => {
      beforeEach(async () => {
        response = await request.get("/tasks")
      })

      it("returns a unauthorized HTTP status", () => {
        expect(response.status).toBe(401)
      })
    })
  })

  describe("POST /tasks", () => {
    describe("when a User is authenticated", () => {
      beforeEach(async () => {
        user = await createUser()
      })

      describe("with proper params", () => {
        beforeEach(async () => {
          response = await request.post("/tasks").set("Authorization", user.jwt).send({ task: { title } })
        })

        it("return a JSON type response", () => {
          expect(response.type).toBe("application/json")
        })

        it("creates an instance of Task", async () => {
          await expect(prismaTask.task.count()).resolves.toBe(1)
        })

        it("returns the new instance of Task", () => {
          expect(response.body).toMatchObject({ title })
        })

        it("returns a created HTTP status", () => {
          expect(response.status).toBe(201)
        })
      })

      describe("without proper params", () => {
        beforeEach(async () => {
          response = await request.post("/tasks").set("Authorization", user.jwt).send({ task: { title: null } })
        })

        it("return a JSON type response", () => {
          expect(response.type).toBe("application/json")
        })

        it("does not create an instance of Task", async () => {
          await expect(prismaTask.task.count()).resolves.toBe(0)
        })

        it("returns a list error messages", () => {
          expect(response.body).toStrictEqual({ errors: { title: "Title can't be blank" } })
        })

        it("returns a unprocessable_entity HTTP status", () => {
          expect(response.status).toBe(422)
        })
      })
    })

    describe("when a User is not authenticated", () => {
      beforeEach(async () => {
        response = await request.post("/tasks").send({ task: { title } })
      })

      it("returns a unauthorized HTTP status", () => {
        expect(response.status).toBe(401)
      })
    })
  })

  describe("DELETE /tasks/:id", () => {
    let task: Prisma.TaskGetPayload<true>

    beforeEach(async () => {
      user = await createUser()
      task = await createTask()
    })

    describe("when a User is authenticated", () => {
      describe("when the Task is found", () => {
        beforeEach(async () => {
          response = await request.delete(`/tasks/${task.id}`).set("Authorization", user.jwt)
        })

        it("destroys the instance of Task", async () => {
          await expect(prismaTask.task.count()).resolves.toBe(0)
        })

        it("returns a ok http status", () => {
          expect(response.status).toBe(200)
        })
      })

      describe("when the Task is not found", () => {
        beforeEach(async () => {
          response = await request.delete(`/tasks/${task.id + 1}`).set("Authorization", user.jwt)
        })

        it("return a JSON type response", () => {
          expect(response.type).toBe("application/json")
        })

        it("returns a list error messages", () => {
          expect(response.body).toStrictEqual({ errors: { task: "Task must exist" } })
        })

        it("returns a not_found HTTP status", () => {
          expect(response.status).toBe(404)
        })
      })
    })

    describe("when a User is not authenticated", () => {
      beforeEach(async () => {
        response = await request.delete(`/tasks/${task.id}`)
      })

      it("returns a unauthorized HTTP status", () => {
        expect(response.status).toBe(401)
      })
    })
  })

  describe("PATCH /tasks/:id/complete", () => {
    let task: Prisma.TaskGetPayload<true>

    beforeEach(async () => {
      user = await createUser()
      task = await createTask()
    })

    describe("when a User is authenticated", () => {
      describe("when the Task is found", () => {
        beforeEach(async () => {
          response = await request.patch(`/tasks/${task.id}/complete`).set("Authorization", user.jwt)
        })

        it("returns a JSON type response", () => {
          expect(response.type).toBe("application/json")
        })

        it("returns the instance of Task", () => {
          expect(response.body).toMatchObject({ id: task.id })
        })

        it("marks the Task as completed", async () => {
          await expect(prismaTask.task.findUnique({ where: { id: task.id } }))
            .resolves
            .toMatchObject({ completed: true })
        })

        it("returns a ok http status", () => {
          expect(response.status).toBe(200)
        })
      })

      describe("when the Task is not found", () => {
        beforeEach(async () => {
          response = await request.delete(`/tasks/${task.id + 1}`).set("Authorization", user.jwt)
        })

        it("return a JSON type response", () => {
          expect(response.type).toBe("application/json")
        })

        it("returns a list error messages", () => {
          expect(response.body).toStrictEqual({ errors: { task: "Task must exist" } })
        })

        it("returns a not_found HTTP status", () => {
          expect(response.status).toBe(404)
        })
      })
    })

    describe("when a User is not authenticated", () => {
      beforeEach(async () => {
        response = await request.patch(`/tasks/${task.id}/complete`)
      })

      it("returns a unauthorized HTTP status", () => {
        expect(response.status).toBe(401)
      })
    })
  })
})
