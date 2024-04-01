/* eslint-disable */
import vue from "eslint-plugin-vue"

export default {
  plugins: { vue },
  rules: {
    "vue/component-name-in-template-casing": ["error", "PascalCase", {
      globals: [
        "KeepAlive",
        "RouterLink",
        "RouterView",
        "Suspense",
        "Teleport",
        "Transition",
        "TransitionGroup",
        "BaseButton",
        "BaseContainer",
        "BaseForm",
        "TaskTable"
      ]
    }]
  }
}
