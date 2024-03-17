import type { User } from "src/models/user.model.ts"

declare global{
  namespace Express {
    interface Request {
      currentUser: User
    }
  }
}
