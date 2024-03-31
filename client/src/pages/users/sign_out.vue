<script setup lang="ts">
  const router = useRouter()
  const sessionStore = useSessionStore()

  onBeforeMount(async () => {
    await sessionStore.signOut()
    await router.push("/")
  })
</script>
