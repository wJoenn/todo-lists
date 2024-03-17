<template>
  <div id="root">
    <div class="container">
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

        <form @submit.prevent="handleSubmit">
          <span v-if="errors.task" class="error">{{ errors.task }}</span>

          <div class="input">
            <span v-if="errors.title" class="error">{{ errors.title }}</span>
            <input type="text" name="title" placeholder="Got a new task to do ?">
          </div>

          <button>Add to list</button>
        </form>

        <table>
          <thead>
            <tr>
              <th>#</th>
              <th>Title</th>
              <th>Status</th>
              <th />
            </tr>
          </thead>

          <tbody>
            <tr v-for="(task, index) in sortedTasks" :key="task.id">
              <td class="id">{{ task.id }}</td>
              <td class="title">{{ task.title }}</td>
              <td class="status">
                <p>
                  <Icon
                    :icon="task.completed ? 'icon-park-outline:check-one' : 'fa:circle-thin'"
                    @click="completeTask(task.id, index)" />

                  <span>{{ task.completed ? 'Done' : 'Todo' }}</span>
                </p>
              </td>
              <td class="delete"><Icon icon="fa6-solid:delete-left" @click="deleteTask(task.id)" /></td>
            </tr>
          </tbody>
        </table>

        <div class="footer">
          <p>{{ tasks.filter(task => task.completed).length }} of {{ tasks.length }} task(s) completed.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
  import type { Task, TaskErrors } from "~/types"
  import { Icon } from "@iconify/vue"

  const sessionStore = useSessionStore()
  const { user } = toRefs(sessionStore)

  const errors = ref<TaskErrors>({})
  const tasks = ref<Task[]>([])

  const sortedTasks = computed(() => [...tasks.value].sort((a, b) => b.id - a.id))

  const completeTask = async (id: number, index: number) => {
    await axios.patch(`${import.meta.env.VITE_API_URL}/tasks/${id}/complete`, null, {
      headers: sessionStore.authorizationHeader
    })

    const task = sortedTasks.value[index]
    task.completed = true
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

  onBeforeMount(async () => {
    const response = await axios.get<Task[]>(`${import.meta.env.VITE_API_URL}/tasks`, {
      headers: sessionStore.authorizationHeader
    })

    tasks.value = response.data
  })
</script>

<style scoped lang="scss">
  #root {
    .container {
      display: flex;
      flex-direction: column;
      gap: 20px;
      margin: 0 auto;
      width: Min(1200px, 95%);

      > a {
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
        padding: 20px;

        form {
          align-items: flex-end;
          display: flex;
          gap: 20px;
          width: 50%;

          button {
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
            flex-grow: 1;
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

        table {
          border: $border-dark;
          border-spacing: 0;
          border-collapse: separate;
          border-radius: 5px;

          tr {
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

        .footer {
          color: $text-secondary;
          font-size: $size-md;
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
  }
</style>
