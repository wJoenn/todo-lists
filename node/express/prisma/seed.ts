import fs from "fs"
import path from "path"
import prismaTask from "src/models/task.model.ts"
import prismaUser from "src/models/user.model.ts"

const user = await prismaUser.user.create({ data: { email: "wJoenn@example.com", password: "password" } })

const file = fs.readFileSync(path.resolve(__dirname, "./static/tasks.csv"), "utf-8")
const rows = file.trim().split("\n").map(row => row.split(",")) as [string, string][]

for (const row of rows) {
  const [title, completed] = row
  const data = { title, completed: completed === "true" }
  await prismaTask.task.create({ data: { ...data, userId: user.id } })
}
