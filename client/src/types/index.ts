export type User = {
  id: number
  email: string
  password?: never
  password_confirmation?: never
}

export type UserErrors = Partial<{ [key in keyof Omit<User, "id">]: string }> & { user?: string }

export type Task = {
  id: number
  title: string
  completed: boolean
}

export type TaskErrors = Partial<{ [key in keyof Omit<Task, "id">]: string }> & { task?: string }
