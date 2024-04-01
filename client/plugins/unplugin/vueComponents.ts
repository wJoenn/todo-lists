import fs from "fs"
import path from "path"
import Components from "unplugin-vue-components/vite"
import { rootDir } from "."

const VUE_COMPONENTS = [
  "KeepAlive",
  "RouterLink",
  "RouterView",
  "Suspense",
  "Teleport",
  "Transition",
  "TransitionGroup"
]

const getComponents = (componentsDir = `${rootDir}/src/components/`): string[] => fs
  .readdirSync(componentsDir)
  .flatMap(file => {
    const filePath = `${componentsDir}${file}`
    if (path.extname(filePath) === ".ts") { return [] }

    const stat = fs.statSync(filePath)
    return stat.isDirectory() ? getComponents(`${filePath}/`) : [file.replace(".vue", "")]
  })
  .sort()

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
    VUE_COMPONENTS.concat(getComponents()).map(component => `        "${component}"`).join(",\n"),
    "      ]",
    "    }]",
    "  }",
    "}",
    ""
  ].join("\n")

  fs.writeFileSync(`${rootDir}/.vue/eslint.components.config.js`, eslintConfig)
}

const watchComponents = () => {
  fs.watch(`${rootDir}/src/components`, { recursive: true }, () => {
    createEslintComponentsFile()
  })
}

const unpluginVueComponents = () => {
  createEslintComponentsFile()
  watchComponents()

  return Components({
    dirs: ["src/components"],
    dts: `${rootDir}/.vue/components.d.ts`
  })
}

export default unpluginVueComponents
