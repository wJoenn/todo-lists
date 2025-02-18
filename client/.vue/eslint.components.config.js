/* eslint-disable */
import vue from "eslint-plugin-vue"

export default {
  plugins: { vue },
  rules: {
    "vue/component-name-in-template-casing": ["error", "PascalCase", {
      globals: [
        "BaseButton",
        "BaseContainer",
        "BaseForm",
        "KeepAlive",
        "RouterLink",
        "RouterView",
        "Suspense",
        "TaskTable",
        "Teleport",
        "Transition",
        "TransitionGroup"
      ]
    }]
  }
}
