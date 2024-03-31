import type { NavigationGuardNext, RouteLocationNormalized } from "vue-router/auto"
import type { RouteLocationAsString, RouteNamedMap } from "unplugin-vue-router/types"

const verifyAuthentification = (to: RouteLocationNormalized, next: NavigationGuardNext) => {
  const sessionStore = useSessionStore()

  // @ts-expect-error
  const whiteList: RouteLocationAsString<RouteNamedMap>[] = [
    "/users/sign_in",
    "/users/sign_up"
  ]

  if (sessionStore.isLoggedIn && whiteList.includes(to.path)) {
    next("/")
    return
  }
  if (!sessionStore.isLoggedIn && !whiteList.includes(to.path)) {
    next("/users/sign_in")
    return
  }

  next()
}

const router = createRouter({
  history: createWebHistory()
})

router.beforeEach((to, _from, next) => {
  verifyAuthentification(to, next)
})

export default router
