import type { PluginOption } from "vite"

import AutoImport from "unplugin-auto-import/vite"
import { VueRouterAutoImports } from "unplugin-vue-router"
import { rootDir } from "."

const unpluginAutoImport = () => AutoImport({
  dirs: [`${rootDir}/src/stores`, `${rootDir}/src/utils`],
  dts: `${rootDir}/.vue/auto-import.d.ts`,
  imports: [
    "pinia",
    "vue",
    VueRouterAutoImports,
    {
      "axios": [["default", "axios"]],
      "vue-router/auto": ["createRouter", "createWebHistory"]
    }
  ]
}) as PluginOption

export default unpluginAutoImport
