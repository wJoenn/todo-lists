<template>
  <h1>To Do List manager app</h1>

  <form @submit.prevent="handleSubmit">
    <input type="text" name="title" placeholder="Got a new task to do ?">
    <input type="submit" value="Add to list">
  </form>

  <ul>
    <li v-for="(task, index) in sortedTasks" :key="task.id">
      <p>{{ task.title }}</p>
      <p>Task is {{ task.completed ? '' : 'not ' }}completed</p>
      <button @click="completeTask(task.id, index)">Complete</button>
      <button @click="deleteTask(task.id, index)">Delete</button>
    </li>
  </ul>

  <RouterLink to="/users/sign_out">Sign out</RouterLink>
</template>

<script setup lang="ts">
  type Task = {
    id: number
    title: string
    completed: boolean
  }

  const sessionStore = useSessionStore()

  const errors = ref<string[]>([])
  const tasks = ref<Task[]>([])

  const sortedTasks = computed(() => tasks.value.sort((a, b) => b.id - a.id))

  const completeTask = async (id: number, index: number) => {
    await axios.patch(`${import.meta.env.VITE_API_URL}/tasks/${id}/complete`, null, {
      headers: sessionStore.authorizationHeader
    })

    const task = tasks.value[index]
    task.completed = true
  }

  const deleteTask = async (id: number, index: number) => {
    await axios.delete(`${import.meta.env.VITE_API_URL}/tasks/${id}`, {
      headers: sessionStore.authorizationHeader
    })

    tasks.value.splice(index, 1)
  }

  const handleSubmit = async (event: Event) => {
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
