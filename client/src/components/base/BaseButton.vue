<template>
  <button class="base-button">
    <slot />
  </button>
</template>

<style lang="scss">
  .base-button {
    align-items: center;
    background-color: transparent;
    border: $border-dark;
    border-radius: 5px;
    cursor: pointer;
    color: $text-primary;
    display: flex;
    padding: $padding;
    transition: background-color 0.3s ease;

    &:disabled {
      color: $text-secondary;
      cursor: default;
      background-color: $background-ternary;

      &:hover {
        background-color: $background-ternary;
      }
    }

    &:hover {
      background-color: $background-primary;
    }

    svg {
      height: 15px;
      width: 15px;
    }
  }
</style>
