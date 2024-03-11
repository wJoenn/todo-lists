import express from "express"
import prisma from "~/libs/prisma"

const app = express()

app.get("/", (_, res) => { res.status(200).json("Hello world") })

app.get("/tasks", async (_, res) => {
  const tasks = await prisma.task.findMany()
  return res.status(200).json(tasks)
})

app.listen(3000, () => {
  console.log("Server opened at http://localhost:3000")
})
