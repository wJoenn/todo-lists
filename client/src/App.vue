<template>
  <RouterView />
</template>

<script setup lang="ts">
  const sessionStore = useSessionStore()

  onBeforeMount(async () => {
    await sessionStore.signInWithToken()
  })
</script>
