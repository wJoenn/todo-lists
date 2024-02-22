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
  const eslintrc = {
    rules: {
      "vue/component-name-in-template-casing": ["error", "PascalCase", {
        globals: getComponents()
      }]
    }
  }

  fs.writeFileSync(`${rootDir}/.vue/.eslintrc-components.json`, JSON.stringify(eslintrc, null, 2))
}

const getComponents = (componentsDir = `${rootDir}/src/components/`): string[] => {
  let components : string[] = []
  fs.readdir(componentsDir, null, (_, files) => {
    if (files) {
      components = files
    }
  })

  return components
    .flatMap(file => {
      const filePath = `${componentsDir}${file}`
      const stat = fs.statSync(filePath)

      return stat.isDirectory() ? getComponents(filePath) : [file.replace(".vue", "")]
    })
    .sort()
}

export default unpluginVueComponents
