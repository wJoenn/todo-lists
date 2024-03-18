<template>
  <div class="container">
    <slot />
  </div>
</template>

<script setup lang="ts">
  const props = withDefaults(defineProps<{
    size?: "sm" | "lg"
  }>(), {
    size: "lg"
  })

  const width = computed(() => {
    switch (props.size) {
    case "sm": return "500px"
    default: return "1200px"
    }
  })
</script>

<style scoped lang="scss">
  .container {
    display: flex;
    flex-direction: column;
    gap: 20px;
    margin: 0 auto;
    width: Min(v-bind(width), 95%);
  }
</style>
