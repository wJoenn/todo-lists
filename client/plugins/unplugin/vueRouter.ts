import VueRouter from "unplugin-vue-router/vite"
import { getPascalCaseRouteName } from "unplugin-vue-router"
import { rootDir } from "."

const unpluginVueRouter = () => VueRouter({
  dts: `${rootDir}/.vue/typed-router.d.ts`,
  getRouteName: routeNode => getPascalCaseRouteName(routeNode)
})

export default unpluginVueRouter
