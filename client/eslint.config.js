import fs from "fs"
import { vue } from "eslint-config-joenn"
import componentsConfig from "./.vue/eslint.components.config.js"

const autoImportConfig = JSON.parse(fs.readFileSync("./.vue/.eslintrc-auto-import.json"))

export default [
  ...vue,
  componentsConfig,
  { languageOptions: autoImportConfig },
  {
    files: ["**/*.ts"],
    ignores: ["src"],
    rules: {
      "import/extensions": "off"
    }
  }
]
