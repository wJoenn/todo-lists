<template>
  <form
    :style="{ alignItems: direction === 'row' ? 'flex-end' : 'center', flexDirection: direction }"
    @submit.prevent="event => $emit('submit', event)">
    <span v-if="errors[record]" class="error">{{ errors[record] }}</span>

    <div v-for="input in inputs" :key="input.name" class="input" :style="inputStyle">
      <span v-if="errors[input.name]" class="error">{{ errors[input.name] }}</span>
      <input :type="input.type" :name="input.name" :placeholder="input.placeholder">
    </div>

    <BaseButton :style="{ alignSelf: direction === 'row' ? 'flex-end' : 'flex-start' }">{{ action }}</BaseButton>
  </form>
</template>

<script setup lang="ts">
  defineEmits<{
    (event: "submit", payload: Event): void
  }>()

  const props = withDefaults(defineProps<{
    errors: Record<string, string>
    inputs: { name: string, type: "text" | "password", placeholder?: string }[]
    record: string
    action?: string
    direction?: "column" | "row"
  }>(), {
    action: "Submit",
    direction: "column"
  })

  const inputStyle = computed(() => {
    if (props.direction === "row") {
      return { "flex-grow": "1" }
    }

    return { width: "100%" }
  })
</script>

<style scoped lang="scss">
  form {
    display: flex;
    gap: 20px;

    .error {
      color: $text-negative;
      font-size: $size-sm;
    }

    .input {
      display: flex;
      flex-direction: column;
      gap: 5px;

      input {
        background-color: transparent;
        border: $border-dark;
        border-radius: 5px;
        color: $text-primary;
        padding: $padding;
        transition: border 0.3s ease;

        &:focus {
          border-color: $nuxt-green-light;
          outline: none;
        }
      }
    }
  }
</style>
