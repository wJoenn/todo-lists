type User = {
  email: string
  password: string
}

export const useSessionStore = defineStore("SessionStore", () => {
  const user = ref<User>()

  const isLoggedIn = computed(() => !!user.value)

  const signIn = (data: FormData) => {
    const userData: Partial<User> = {}
    data.forEach((value, key) => { userData[key as keyof User] = value as string })
    user.value = userData as User
  }

  const signOut = () => {
    user.value = undefined
  }

  const signUp = (data: FormData) => {
    const userData: Partial<User> = {}
    data.forEach((value, key) => { userData[key as keyof User] = value as string })
    user.value = userData as User
  }

  return { user, isLoggedIn, signIn, signOut, signUp }
})
