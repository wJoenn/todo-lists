import type { CommandOptions } from "@adonisjs/core/types/ace"
import path from "node:path"
import { execSync } from "node:child_process"
import { BaseCommand } from "@adonisjs/core/ace"

export default class DbDrop extends BaseCommand {
  static commandName = "db:drop"
  static description = "Drops environment and test postgres database"

  static options: CommandOptions = {}

  async run() {
    const projectName = path.basename(process.cwd())
    const devDb = `${projectName}_development`
    const testDb = `${projectName}_test`

    try {
      execSync(`dropdb ${devDb}; dropdb ${testDb}`)
      this.logger.info(`database ${devDb} dropped`)
      this.logger.info(`database ${testDb} dropped`)
    } catch {}
  }
}
