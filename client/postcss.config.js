import autoprefixer from "autoprefixer"
import purgecss from "@fullhuman/postcss-purgecss"

export default {
  plugins: [
    autoprefixer,
    purgecss({
      content: ["./**/*.vue", "./index.html"],
      safelist: [/^a$/]
    })
  ]
}
