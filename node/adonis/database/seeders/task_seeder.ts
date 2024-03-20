import { BaseSeeder } from "@adonisjs/lucid/seeders"
import Task from "#models/task"

export default class extends BaseSeeder {
  async run() {
    await Task.create({ title: "My task" })
  }
}
