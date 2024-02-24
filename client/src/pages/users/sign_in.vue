<template>
  <h1>Sign in</h1>

  <form @submit.prevent="handleSubmit">
    <input name="email" type="text" placeholder="Email...">
    <input name="password" type="password" placeholder="Password...">
    <input type="submit">
  </form>

  <p v-for="(error, index) in errors" :key="index" class="error">{{ error }}</p>

  <RouterLink to="/users/sign_up">Sign up</RouterLink>
</template>

<script setup lang="ts">
  const router = useRouter()
  const sessionStore = useSessionStore()

  const errors = ref<string[]>([])

  const handleSubmit = async (event: Event) => {
    errors.value = []
    const form = event.target as HTMLFormElement
    const formData = new FormData(form)

    const response = await sessionStore.signIn(formData)
    if (sessionStore.isLoggedIn) {
      router.push("/")
    } else {
      errors.value = response
    }
  }
</script>

<style scoped lang="scss">
  .error {
    color: $text-negative;
  }
</style>
