import type { Request, Response } from "express"
import { z as zod } from "zod"
import { Prisma } from "@prisma/client"
import prisma from "src/models/user.model.ts"

export const show = (req: Request, res: Response) => {
  return res.status(200).json(req.currentUser.toJSON())
}

export const create = async (req: Request, res: Response) => {
  const { user: data } = req.body as { user: Prisma.UserUncheckedCreateInput }

  try {
    const user = await prisma.user.create({ data })
    return res.status(201).set("Authorization", user.jwt).json(user.toJSON())
  } catch (error) {
    return _handleError(error, res)
  }
}

const _handleError = (error: unknown, res: Response) => {
  if (error instanceof zod.ZodError) {
    return res.status(422).json({
      errors: Object.fromEntries(error.issues.map(issue => [issue.path[0], issue.message]))
    })
  }

  throw error
}
