import App from "./App.vue"
import router from "~/router"
import "./assets/stylesheets/application.scss"

const app = createApp(App)
const pinia = createPinia()
const sessionStore = useSessionStore(pinia)

app.use(pinia)
sessionStore
  .signInWithToken()
  .then(() => {
    app
      .use(router)
      .mount("#app")
  })
