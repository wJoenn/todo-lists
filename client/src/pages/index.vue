<template>
  <div id="root">
    <BaseContainer>
      <RouterLink to="/users/sign_out">Sign out</RouterLink>

      <div class="frame">
        <div class="header">
          <div class="title">
            <h1>Welcome back</h1>
            <h3>Here's a list of your task for this month!</h3>
          </div>

          <div class="user">
            <p>{{ user?.email.replace(/@.+/, "") }}</p>
            <div class="avatar" />
          </div>
        </div>

        <BaseForm
          action="Add a new task"
          direction="row"
          record="task"
          :errors="errors"
          :inputs="[{ name: 'title', type: 'text', placeholder: 'Got a new task to do ?' }]"
          :style="{ 'max-width': '50%' }"
          @submit="handleSubmit" />

        <TaskTable :page="page" :tasks="tasks" @complete="completeTask" @delete="deleteTask" />

        <div class="footer">
          <p>{{ tasks.filter(task => task.completed).length }} of {{ tasks.length }} task(s) completed.</p>

          <div v-if="tasks.length > 10">
            <BaseButton :disabled="page === 1" @click="page--"><Icon icon="mdi:chevron-left" /></BaseButton>

            <BaseButton :disabled="tasks.length <= 10 * page" @click="page++">
              <Icon icon="mdi:chevron-right" />
            </BaseButton>
          </div>
        </div>
      </div>
    </BaseContainer>
  </div>
</template>

<script setup lang="ts">
  import type { Task, TaskErrors } from "~/types"
  import { Icon } from "@iconify/vue"

  const sessionStore = useSessionStore()
  const { user } = toRefs(sessionStore)

  const errors = ref<TaskErrors>({})
  const page = ref(1)
  const tasks = ref<Task[]>([])

  const completeTask = async (id: number) => {
    await axios.patch(`${import.meta.env.VITE_API_URL}/tasks/${id}/complete`, null, {
      headers: sessionStore.authorizationHeader
    })

    const index = tasks.value.findIndex(task => task.id === id)
    tasks.value[index].completed = true
  }

  const deleteTask = async (id: number) => {
    await axios.delete(`${import.meta.env.VITE_API_URL}/tasks/${id}`, {
      headers: sessionStore.authorizationHeader
    })

    const index = tasks.value.findIndex(task => task.id === id)
    tasks.value.splice(index, 1)
  }

  const handleSubmit = async (event: Event) => {
    errors.value = {}
    const form = event.target as HTMLFormElement
    const formData = new FormData(form)
    const params = { task: Object.fromEntries(formData) }

    try {
      const response = await axios.post<Task>(`${import.meta.env.VITE_API_URL}/tasks`, params, {
        headers: sessionStore.authorizationHeader
      })

      tasks.value.push(response.data)
      form.reset()
    } catch (error: any) {
      errors.value = error.response.data.errors
    }
  }

  onMounted(async () => {
    const response = await axios.get<Task[]>(`${import.meta.env.VITE_API_URL}/tasks`, {
      headers: sessionStore.authorizationHeader
    })

    tasks.value = response.data
  })
</script>

<style scoped lang="scss">
  #root {
    a {
      font-size: $size-md;
      padding-right: 10px;
      text-align: right;
    }

    .frame {
      border: $border-dark;
      border-radius: 10px;
      display: flex;
      flex-direction: column;
      gap: 20px;
      padding: 35px;

      .footer {
        color: $text-secondary;
        display: flex;
        font-size: $size-md;
        justify-content: space-between;

        div {
          display: flex;
          gap: 10px;
        }
      }

      .header {
        align-items: flex-start;
        display: flex;
        justify-content: space-between;

        h1 {
          font-size: 1.5rem;
        }

        h3 {
          color: $text-secondary;
          font-size: $size;
          font-weight: 500;
        }

        .user {
          align-items: center;
          display: flex;
          gap: 10px;

          .avatar {
            background-image: linear-gradient(135deg, $nuxt-green-light, mediumpurple);
            border-radius: 50%;
            height: 35px;
            width: 35px;
          }
        }
      }
    }
  }
</style>
