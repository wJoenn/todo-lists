import { vue } from "eslint-config-joenn"
import componentsConfig from "./.vue/eslint.components.config.js"

export default [
  ...vue,
  componentsConfig,
  {
    files: ["**/*.ts"],
    ignores: ["src"],
    rules: {
      "import/extensions": "off"
    }
  }
]
