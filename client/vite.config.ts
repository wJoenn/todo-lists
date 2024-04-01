import fs from "fs"
import path from "path"
import vue from "@vitejs/plugin-vue"
import { defineConfig } from "vite"
import { unpluginAutoImport, unpluginVueComponents, unpluginVueRouter } from "./plugins/unplugin"

fs.mkdir(".vue", () => null)

export default defineConfig({
  css: {
    preprocessorOptions: {
      scss: {
        additionalData: "@import './src/assets/stylesheets/config/_variables.scss';"
      }
    }
  },
  plugins: [
    unpluginAutoImport(),
    unpluginVueComponents(),
    unpluginVueRouter(),
    vue()
  ],
  resolve: {
    alias: {
      "~": path.resolve(__dirname, "src")
    }
  }
})
