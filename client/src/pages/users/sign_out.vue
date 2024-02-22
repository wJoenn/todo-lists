<script setup lang="ts">
  const router = useRouter()
  const sessionStore = useSessionStore()

  sessionStore.signOut()
  router.push("/")
</script>
