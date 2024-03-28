import type { RequestHandler } from "express"
import prisma from "src/models/user.model.ts"

const whitelist = [
  JSON.stringify({ method: "POST", path: "/users" }),
  JSON.stringify({ method: "POST", path: "/users/sign_in" })
]

const authenticateUser: RequestHandler = async (req, res, next) => {
  const { method, path } = req
  if (whitelist.includes(JSON.stringify({ method, path }))) {
    next()
    return
  }

  const jwt = req.headers.authorization

  if (jwt) {
    const user = await prisma.user.byJWT(jwt)

    if (user) {
      req.currentUser = user
      return
    }
  }

  return res.status(401).send()
}

export default authenticateUser
