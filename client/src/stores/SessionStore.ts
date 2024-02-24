import type { AxiosResponse } from "axios"

type User = {
  email: string
  password: string
}

export const useSessionStore = defineStore("SessionStore", () => {
  const user = ref<User>()
  const bearerToken = ref<string>()

  const authorizationHeader = computed(() => ({ Authorization: bearerToken.value }))
  const isLoggedIn = computed(() => !!bearerToken.value)

  const signIn = (formData: FormData) => _postRequest("/users/sign_in", formData)

  const signInWithToken = async () => {
    bearerToken.value = localStorage.bearerToken

    if (bearerToken.value) {
      try {
        const response = await axios.get(`${import.meta.env.VITE_API_URL}/current_user`, {
          headers: authorizationHeader.value
        })

        user.value = response.data.user
      } catch (error) {
        console.log(error)
      }
    }
  }

  const signOut = async () => {
    try {
      axios.delete(`${import.meta.env.VITE_API_URL}/users/sign_out`, {
        headers: authorizationHeader.value
      })

      user.value = undefined
      bearerToken.value = undefined
      localStorage.removeItem("bearerToken")
    } catch (error) {
      console.log(error)
    }
  }

  const signUp = (formData: FormData) => _postRequest("/users", formData)

  const _postRequest = async (endPoint: string, formData: FormData) => {
    try {
      const params = { user: Object.fromEntries(formData) }
      const response = await axios.post(`${import.meta.env.VITE_API_URL}${endPoint}`, params, {
        headers: { "Content-Type": "application/json" }
      })

      user.value = response.data.user
      bearerToken.value = response.headers.authorization
      localStorage.bearerToken = bearerToken.value
    } catch (error: any) {
      console.log(error.response.data.errors)
    }
  }

  return { user, isLoggedIn, signIn, signInWithToken, signOut, signUp }
})
