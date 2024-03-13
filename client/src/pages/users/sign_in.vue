<template>
  <h1>Sign in</h1>

  <form @submit.prevent="handleSubmit">
    <span v-if="errors.user" class="error">{{ errors.user }}</span>

    <div>
      <input name="email" type="text" placeholder="Email...">
      <span v-if="errors.email" class="error">{{ errors.email }}</span>
    </div>

    <div>
      <input name="password" type="password" placeholder="Password...">
      <span v-if="errors.password" class="error">{{ errors.password }}</span>
    </div>

    <input type="submit">
  </form>

  <RouterLink to="/users/sign_up">Sign up</RouterLink>
</template>

<script setup lang="ts">
  import type { UserErrors } from "~/types"

  const router = useRouter()
  const sessionStore = useSessionStore()

  const errors = ref<UserErrors>({})

  const handleSubmit = async (event: Event) => {
    errors.value = {}
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
