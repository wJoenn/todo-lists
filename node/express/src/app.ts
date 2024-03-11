import type { ZodError } from "zod"

import express from "express"
import { Prisma } from "@prisma/client"
import prisma from "src/models/task.model"

const app = express()
app.use(express.json())

app.get("/", (_, res) => { res.status(200).json("Hello world") })

app.get("/tasks", async (_, res) => {
  const tasks = await prisma.task.findMany()
  return res.status(200).json(tasks)
})

app.post("/tasks", async (req, res) => {
  const { task: data } = req.body as { task: Prisma.TaskUncheckedCreateInput }

  try {
    const task = await prisma.task.create({ data })
    return res.status(201).json(task)
  } catch (error) {
    return res.status(422).json((error as ZodError).issues)
  }
})

app.delete("/tasks/:id", async (req, res) => {
  try {
    await prisma.task.delete({ where: { id: +req.params.id } })
    return res.status(200).send()
  } catch (error) {
    return res.status(422).send()
  }
})

app.patch("/tasks/:id/complete", async (req, res) => {
  try {
    const task = await prisma.task.update({ data: { completed: true }, where: { id: +req.params.id } })
    return res.status(200).json(task)
  } catch (error) {
    return res.status(422).json((error as ZodError).issues)
  }
})

app.listen(3000, () => {
  console.log("Server opened at http://localhost:3000")
})
