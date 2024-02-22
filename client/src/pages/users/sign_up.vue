<template>
  <div>Sign up</div>

  <form @submit.prevent="handleSubmit">
    <input name="email" type="text" placeholder="Email...">
    <input name="password" type="password" placeholder="Password...">
    <input name="password_confirmation" type="password" placeholder="Password confirmation...">
    <input type="submit">
  </form>

  <p>Already have an account?</p>
  <RouterLink to="/users/sign_in">Sign in</RouterLink>
</template>

<script setup lang="ts">
  const router = useRouter()
  const sessionStore = useSessionStore()

  const handleSubmit = (event: Event) => {
    const form = event.target as HTMLFormElement
    const formData = new FormData(form)
    sessionStore.signUp(formData)
    router.push("/")
  }
</script>
