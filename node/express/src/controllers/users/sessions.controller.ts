import type { RequestHandler } from "express"
import bcrypt from "bcrypt"
import prisma from "src/models/user.model.ts"

export const create: RequestHandler = async (req, res) => {
  const { user: { email, password } } = req.body as { user: { email?: string, password?: string } }

  if (email && password) {
    const user = await prisma.user.findUnique({ where: { email } })
    if (user && await bcrypt.compare(password, user.password)) {
      return res.status(200).set("Authorization", user.jwt).json(user.toJSON())
    }
  }

  return res.status(401).json({ errors: { user: "Invalid Email or Password" } })
}

export const destroy: RequestHandler = async (req, res) => {
  await req.currentUser.editJTI()
  res.status(200).send()
}
