import type { RequestHandler } from "express"
import prisma from "src/models/user.model.ts"

const whitelist = [
  JSON.stringify({ path: "/users", method: "POST" }),
  JSON.stringify({ path: "/users/sign_in", method: "POST" })
]

const authenticateUser: RequestHandler = async (req, res, next) => {
  const { path, method } = req
  if (whitelist.includes(JSON.stringify({ path, method }))) { return next() }

  const jwt = req.headers.authorization

  if (jwt) {
    const user = await prisma.user.byJWT(jwt)

    if (user) {
      req.currentUser = user
      return next()
    }
  }

  return res.status(401).send()
}

export default authenticateUser
