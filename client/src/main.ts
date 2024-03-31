import type { Component } from "vue"

import App from "./App.vue"
import router from "~/router/index.ts"
import "./assets/stylesheets/application.scss"

const app = createApp(App as Component)
const pinia = createPinia()
const sessionStore = useSessionStore(pinia)

app.use(pinia)

try {
  await sessionStore.signInWithToken()
  app.use(router).mount("#app")
} catch {}
