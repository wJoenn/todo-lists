<template>
  <div>Hello World</div>
  <p>You need to log in first</p>

  <RouterLink to="/users/sign_out">Sign out</RouterLink>
</template>

<script setup lang="ts">
  const router = useRouter()
  const sessionStore = useSessionStore()

  onBeforeMount(() => {
    if (!sessionStore.isLoggedIn) {
      router.push("/users/sign_in")
    }
  })
</script>
