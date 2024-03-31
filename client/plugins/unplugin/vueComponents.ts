import fs from "fs"
import Components from "unplugin-vue-components/vite"
import { rootDir } from "."

const unpluginVueComponents = () => {
  createEslintComponentsFile()

  return Components({
    dirs: ["src/components"],
    dts: `${rootDir}/.vue/components.d.ts`
  })
}

const createEslintComponentsFile = () => {
  const eslintConfig = [
    "/* eslint-disable */",
    'import vue from "eslint-plugin-vue"',
    "",
    "export default {",
    "  plugins: { vue },",
    "  rules: {",
    '    "vue/component-name-in-template-casing": ["error", "PascalCase", {',
    "      globals: [",
    getComponents().map(component => `        "${component}"`).join(",\n"),
    "      ]",
    "    }]",
    "  }",
    "}",
    ""
  ].join("\n")

  fs.writeFileSync(`${rootDir}/.vue/eslint.components.config.js`, eslintConfig)
}

const getComponents = (componentsDir = `${rootDir}/src/components/`): string[] => {
  const components = fs.readdirSync(componentsDir)

  return components
    .flatMap(file => {
      const filePath = `${componentsDir}${file}`
      const stat = fs.statSync(filePath)

      return stat.isDirectory() ? getComponents(`${filePath}/`) : [file.replace(".vue", "")]
    })
    .sort()
}

export default unpluginVueComponents
