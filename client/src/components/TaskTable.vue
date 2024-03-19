<template>
  <div class="tasks-table">
    <div class="table">
      <table>
        <thead>
          <tr>
            <th>#</th>
            <th>Title</th>
            <th>Status</th>
            <th />
          </tr>
        </thead>

        <TransitionGroup tag="tbody" :name="transitionName">
          <tr v-for="task in paginatedTasks" :key="task.id">
            <td class="id">{{ task.id }}</td>
            <td class="title">{{ task.title }}</td>
            <td class="status">
              <p>
                <Icon
                  :icon="task.completed ? 'material-symbols:check-circle-outline' : 'material-symbols:circle-outline'"
                  @click="$emit('complete', task.id)" />

                <span>{{ task.completed ? 'Done' : 'Todo' }}</span>
              </p>
            </td>
            <td class="delete"><Icon icon="fa6-solid:delete-left" @click="$emit('delete', task.id)" /></td>
          </tr>
        </TransitionGroup>
      </table>
    </div>

    <div class="footer">
      <p>{{ tasks.filter(task => task.completed).length }} of {{ tasks.length }} task(s) completed.</p>

      <Transition name="slide-left">
        <div v-if="tasks.length > 10" class="pagination">
          <BaseButton :disabled="page === 1" @click="page--"><Icon icon="mdi:chevron-left" /></BaseButton>

          <BaseButton :disabled="tasks.length <= 10 * page" @click="page++">
            <Icon icon="mdi:chevron-right" />
          </BaseButton>
        </div>
      </Transition>
    </div>
  </div>
</template>

<script setup lang="ts">
  import type { Task } from "~/types"
  import { Icon } from "@iconify/vue"

  defineEmits<{
    (event: "complete", payload: number): void
    (event: "delete", payload: number): void
  }>()

  const props = defineProps<{
    tasks: Task[]
  }>()

  const page = ref(1)
  const tableTransition = ref("0")
  const transitionName = ref("disabled")

  const offset = computed(() => (page.value - 1) * 10)
  const sortedTasks = computed(() => [...props.tasks].sort((a, b) => b.id - a.id))
  const paginatedTasks = computed(() => sortedTasks.value.slice(0 + offset.value, 10 + offset.value))
  const tableHeight = computed(() => `${(paginatedTasks.value.length + 1) * 46}px`)

  watch(() => props.tasks, (_, oldValue) => {
    if (oldValue.length === 0) {
      setTimeout(() => {
        tableTransition.value = "0.3s"
        transitionName.value = "table-row"
      }, 100)
    }
  })

  onMounted(() => {

  })
</script>

<style scoped lang="scss">
  .tasks-table {
    display: flex;
    flex-direction: column;
    gap: 10px;

    .footer {
      align-items: center;
      color: $text-secondary;
      display: flex;
      font-size: $size-md;
      height: 35px;
      justify-content: space-between;
      padding-left: 5px;

      .pagination {
        display: flex;
        gap: 10px;
      }
    }

    .table {
      height: v-bind(tableHeight);
      transition: height v-bind(tableTransition) ease;
      border: $border-dark;
      border-radius: 5px;
      overflow: hidden;

      table {
        border-spacing: 0;

        tr {
          height: 46px;

          &:last-of-type {
            td {
              border: none;
            }
          }

          svg {
            cursor: pointer;
            height: 15px;
            width: 15px;
            transition: color 0.3s ease;

            &:hover {
              color: $nuxt-green-light;
            }
          }

          td, th {
            border-bottom: $border-dark;
            padding: $size-sm $size;
          }

          th {
            color: $text-secondary;
            font-size: $size-md;
            font-weight: 500;
            text-align: left;
          }

          .delete, .id {
            min-width: 65px;
          }

          .status {
            min-width: 200px;

            p {
              align-items: center;
              display: flex;
              gap: 10px;
            }
          }

          .title {
            overflow-wrap: break-word;
            width: 1000px;
          }
        }
      }
    }
  }

  .slide-left-leave-to,
  .slide-left-enter-from {
    opacity: 0;
    transform: translateX(30px);
  }

  .slide-left-enter-active,
  .slide-left-leave-active {
    transition: all 0.3s ease;
  }

  .table-row-leave-to,
  .table-row-enter-from {
    opacity: 0;
    transform: translateX(30px);
  }

  .table-row-leave-active {
    position: absolute;
    max-width: calc(Min(95%, 1200px) - 70px);
  }

  .table-row-move,
  .table-row-enter-active,
  .table-row-leave-active {
    transition: all 0.3s ease;
  }
</style>
