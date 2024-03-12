import type { Prisma } from "@prisma/client"
import supertest from "supertest"
import { beforeEach } from "vitest"
import app from "src/app.ts"
import prisma from "src/models/task.model"

describe("TasksController", () => {
  let response: supertest.Response
  const request = supertest(app)
  const title = "My task"

  const createTask = async () => await prisma.task.create({ data: { title } })

  describe("GET /tasks", () => {
    beforeEach(async () => {
      await createTask()
      response = await request.get("/tasks")
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

  describe("POST /tasks", () => {
    describe("with proper params", () => {
      beforeEach(async () => {
        response = await request.post("/tasks").send({ task: { title } })
      })

      it("return a JSON type response", () => {
        expect(response.type).toBe("application/json")
      })

      it("creates an instance of Task", async () => {
        await expect(prisma.task.count()).resolves.toBe(1)
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
        response = await request.post("/tasks").send({ task: { title: null } })
      })

      it("return a JSON type response", () => {
        expect(response.type).toBe("application/json")
      })

      it("does not create an instance of Task", async () => {
        await expect(prisma.task.count()).resolves.toBe(0)
      })

      it("returns a list error messages", () => {
        console.log(response.body)
        expect(response.body).toStrictEqual({ errors: ["Title can't be blank"] })
      })

      it("returns a created HTTP status", () => {
        expect(response.status).toBe(422)
      })
    })
  })

  describe("DELETE /tasks/:id", () => {
    beforeEach(async () => {
      const task = await createTask()
      response = await request.delete(`/tasks/${task.id}`)
    })

    it("destroys the instance of Task", async () => {
      await expect(prisma.task.count()).resolves.toBe(0)
    })

    it("returns a ok http status", () => {
      expect(response.status).toBe(200)
    })
  })

  describe("PATCH /tasks/:id/complete", () => {
    let task: Prisma.TaskGetPayload<true>

    beforeEach(async () => {
      task = await createTask()
      response = await request.patch(`/tasks/${task.id}/complete`)
    })

    it("returns a JSON type response", () => {
      expect(response.type).toBe("application/json")
    })

    it("returns the instance of Task", () => {
      expect(response.body).toMatchObject({ id: task.id })
    })

    it("marks the Task as completed", async () => {
      await expect(prisma.task.findUnique({ where: { id: task.id } })).resolves.toMatchObject({ completed: true })
    })

    it("returns a ok http status", () => {
      expect(response.status).toBe(200)
    })
  })
})
