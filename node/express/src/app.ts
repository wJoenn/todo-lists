import express from "express"
import * as TasksController from "src/controllers/tasks.controller.ts"

const app = express()
app.use(express.json())

app.get("/", (_, res) => { res.status(200).json("Hello world") })

app.get("/tasks", TasksController.index)
app.post("/tasks", TasksController.create)
app.delete("/tasks/:id", TasksController.destroy)
app.patch("/tasks/:id/complete", TasksController.complete)

export default app

app.listen(3000, () => {
  console.log("Server opened at http://localhost:3000")
})
