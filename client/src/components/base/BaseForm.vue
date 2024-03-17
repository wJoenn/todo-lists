<template>
  <form @submit.prevent="event => $emit('submit', event)">
    <span v-if="errors[record]" class="error">{{ errors[record] }}</span>

    <div v-for="input in inputs" :key="input.name" class="input" :style="inputStyle">
      <span v-if="errors[input.name]" class="error">{{ errors[input.name] }}</span>
      <input :type="input.type" :name="input.name" :placeholder="input.placeholder">
    </div>

    <button>{{ action }}</button>
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

  const alignItems = computed(() => props.direction === "row" ? "flex-end" : "center")
  const inputStyle = computed(() => {
    if (props.direction === "row") {
      return { "flex-grow": "1" }
    }

    return { width: "100%" }
  })
</script>

<style scoped lang="scss">
  form {
    align-items: v-bind(alignItems);
    display: flex;
    flex-direction: v-bind(direction);
    gap: 20px;

    button {
      align-self: flex-start;
      background-color: transparent;
      border: $border-dark;
      border-radius: 5px;
      cursor: pointer;
      color: $text-primary;
      padding: $padding;
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

      span {
        font-size: $size-sm;
      }
    }
  }
</style>
