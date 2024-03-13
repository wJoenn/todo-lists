export type User = {
  id: number
  email: string
  password?: never
  password_confirmation?: never
}

export type UserErrors = { user?: string } & Partial<{ [key in keyof Omit<User, "id">]: string }>

export type Task = {
  id: number
  title: string
  completed: boolean
}

export type TaskErrors = { task?: string } & Partial<{ [key in keyof Omit<Task, "id">]: string }>
