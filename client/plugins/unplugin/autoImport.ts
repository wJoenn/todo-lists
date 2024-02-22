import AutoImport from "unplugin-auto-import/vite"
import { VueRouterAutoImports } from "unplugin-vue-router"
import { rootDir } from "."

const unpluginAutoImport = () => (
  AutoImport({
    dirs: [`${rootDir}/src/stores`],
    dts: `${rootDir}/.vue/auto-import.d.ts`,
    eslintrc: {
      enabled: true,
      filepath: `${rootDir}/.vue/.eslintrc-auto-import.json`
    },
    imports: [
      "pinia",
      "vue",
      VueRouterAutoImports,
      {
        "axios": [["default", "axios"]],
        "vue-router/auto": ["createRouter", "createWebHistory"]
      }
    ]
  })
)

export default unpluginAutoImport
