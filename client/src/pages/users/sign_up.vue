<template>
  <div id="sign-in">
    <BaseContainer size="sm">
      <h1>Sign up</h1>

      <BaseForm
        action="Sign in"
        record="user"
        :errors="errors"
        :inputs="inputs"
        @submit="handleSubmit" />

      <RouterLink to="/users/sign_in">Sign in</RouterLink>
    </BaseContainer>
  </div>
</template>

<script setup lang="ts">
  import type { UserErrors } from "~/types"

  const inputs = [
    { name: "email", type: "text" as const, placeholder: "Email..." },
    { name: "password", type: "password" as const, placeholder: "Password..." },
    { name: "password_confirmation", type: "password" as const, placeholder: "Password confirmation..." }
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
      router.push("/")
    } else {
      errors.value = response
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
