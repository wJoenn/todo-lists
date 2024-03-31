<template>
  <div id="sign-in">
    <BaseContainer size="sm">
      <h1>Sign up</h1>

      <BaseForm
        action="Sign in"
        :errors
        :inputs
        record="user"
        @submit="handleSubmit"
      />

      <RouterLink to="/users/sign_in">Sign in</RouterLink>
    </BaseContainer>
  </div>
</template>

<script setup lang="ts">
  import type { UserErrors } from "~/types"

  const inputs = [
    { name: "email", placeholder: "Email...", type: "text" as const },
    { name: "password", placeholder: "Password...", type: "password" as const },
    { name: "password_confirmation", placeholder: "Password confirmation...", type: "password" as const }
  ]

  const router = useRouter()
  const sessionStore = useSessionStore()

  const errors = ref<UserErrors>({})

  const handleSubmit = async (event: Event) => {
    errors.value = {}
    const form = event.target as HTMLFormElement
    const formData = new FormData(form)

    const response = await sessionStore.signUp(formData)
    if (sessionStore.isLoggedIn) {
      await router.push("/")
    } else {
      errors.value = response ?? {}
    }
  }
</script>

<style scoped lang="scss">
  #sign-up {
    display: flex;
    flex-direction: column;
    gap: 20px;
  }
</style>
