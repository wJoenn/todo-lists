import express from "express"
import * as TasksController from "src/controllers/tasks.controller.ts"
import * as UsersRegistrationsController from "src/controllers/users/registrations.controller.ts"
import * as UsersSessionsController from "src/controllers/users/sessions.controller.ts"
import authenticateUser from "~/middleware/authenticateUser.middleware.ts"

const app = express()
app.use(express.json())
app.all("*", authenticateUser)

app.get("/", (_, res) => { res.status(200).json("Hello world") })

app.get("/tasks", TasksController.index)
app.post("/tasks", TasksController.create)
app.delete("/tasks/:id", TasksController.destroy)
app.patch("/tasks/:id/complete", TasksController.complete)

app.get("/current_user", UsersRegistrationsController.show)
app.post("/users", UsersRegistrationsController.create)
app.post("/users/sign_in", UsersSessionsController.create)
app.delete("/users/sign_out", UsersSessionsController.destroy)

export default app

const port = process.env.PORT ?? 3000
app.listen(port, () => {
  console.log(`Server opened at http://localhost:${port}`)
})
