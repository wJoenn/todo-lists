import App from "./App.vue"
import "./assets/stylesheets/application.scss"

const app = createApp(App)
const pinia = createPinia()
const router = createRouter({
  history: createWebHistory()
})

app
  .use(pinia)
  .use(router)
  .mount("#app")
