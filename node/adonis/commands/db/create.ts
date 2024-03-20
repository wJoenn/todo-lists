import type { CommandOptions } from "@adonisjs/core/types/ace"
import path from "node:path"
import { execSync } from "node:child_process"
import { BaseCommand } from "@adonisjs/core/ace"

export default class DbCreate extends BaseCommand {
  static commandName = "db:create"
  static description = "Creates environment and test postgres database"

  static options: CommandOptions = {}

  async run() {
    const projectName = path.basename(process.cwd())
    const devDb = `${projectName}_development`
    const testDb = `${projectName}_test`

    try {
      execSync(`createdb ${devDb}; createdb ${testDb}`)
      this.logger.info(`database ${devDb} created`)
      this.logger.info(`database ${testDb} created`)
    } catch {}
  }
}
