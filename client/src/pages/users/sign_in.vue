<template>
  <h1>Sign in</h1>

  <form @submit.prevent="handleSubmit">
    <input name="email" type="text" placeholder="Email...">
    <input name="password" type="password" placeholder="Password...">
    <input type="submit">
  </form>

  <ul>
    <li>1</li>
    <li>2</li>
  </ul>

  <p>Dont have an account yet?</p>
  <RouterLink to="/users/sign_up">Sign up</RouterLink>
</template>

<script setup lang="ts">
  const router = useRouter()
  const sessionStore = useSessionStore()

  const handleSubmit = async (event: Event) => {
    const form = event.target as HTMLFormElement
    const formData = new FormData(form)

    await sessionStore.signIn(formData)
    router.push("/")
  }
</script>
