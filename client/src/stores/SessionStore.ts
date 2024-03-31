import type { User, UserErrors } from "~/types"

export const useSessionStore = defineStore("SessionStore", () => {
  const user = ref<User>()
  const _bearerToken = ref<string>()

  const authorizationHeader = computed(() => ({
    "Authorization": _bearerToken.value,
    "Content-Type": "application/json"
  }))

  const isLoggedIn = computed(() => !!_bearerToken.value)

  const signIn = (formData: FormData) => _postRequest("/users/sign_in", formData)

  const signInWithToken = async () => {
    _bearerToken.value = localStorage.bearerToken as string | undefined

    if (_bearerToken.value) {
      try {
        const response = await axios.get<User>(`${import.meta.env.VITE_API_URL}/current_user`, {
          headers: authorizationHeader.value
        })

        user.value = response.data
      } catch {
        _resetState()
      }
    }
  }

  const signOut = async () => {
    await axios.delete(`${import.meta.env.VITE_API_URL}/users/sign_out`, {
      headers: authorizationHeader.value
    })

    _resetState()
  }

  const signUp = (formData: FormData) => _postRequest("/users", formData)

  const _postRequest = async (endPoint: string, formData: FormData) => {
    try {
      const params = { user: Object.fromEntries(formData) }
      const response = await axios.post<User>(`${import.meta.env.VITE_API_URL}${endPoint}`, params, {
        headers: { "Content-Type": "application/json" }
      })

      user.value = response.data
      _bearerToken.value = response.headers.authorization as string
      localStorage.bearerToken = _bearerToken.value
    } catch (error: unknown) {
      if (axios.isAxiosError(error)) {
        return (error.response?.data as { errors: UserErrors } | undefined)?.errors
      }

      throw error
    }
  }

  const _resetState = () => {
    user.value = undefined
    _bearerToken.value = undefined
    localStorage.removeItem("bearerToken")
  }

  return { authorizationHeader, isLoggedIn, signIn, signInWithToken, signOut, signUp, user }
})
