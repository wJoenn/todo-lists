import path from "path"
import unpluginAutoImport from "./autoImport"
import unpluginVueComponents from "./vueComponents"
import unpluginVueRouter from "./vueRouter"

export const rootDir = path.resolve(__dirname, "../..")
export { unpluginAutoImport, unpluginVueComponents, unpluginVueRouter }
