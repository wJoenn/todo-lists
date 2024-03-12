import type { Request, Response } from "express"
import { z as zod } from "zod"
import { Prisma } from "@prisma/client"
import prisma from "src/models/task.model"

export const index = async (_: Request, res: Response) => {
  const tasks = await prisma.task.findMany()
  return res.status(200).json(tasks)
}

export const create = async (req: Request, res: Response) => {
  const { task: data } = req.body as { task: Prisma.TaskUncheckedCreateInput }

  try {
    const task = await prisma.task.create({ data })
    return res.status(201).json(task)
  } catch (error) {
    return _handleError(error, res)
  }
}

export const destroy = async (req: Request, res: Response) => {
  try {
    await prisma.task.delete({ where: { id: +req.params.id } })
    return res.status(200).send()
  } catch (error) {
    return _handleError(error, res)
  }
}

export const complete = async (req: Request, res: Response) => {
  try {
    const task = await prisma.task.update({ data: { completed: true }, where: { id: +req.params.id } })
    return res.status(200).json(task)
  } catch (error) {
    return _handleError(error, res)
  }
}

const _handleError = (error: unknown, res: Response) => {
  if (error instanceof zod.ZodError) {
    return res.status(422).json({ errors: error.issues.map(issue => issue.message) })
  }

  if (error instanceof Prisma.PrismaClientKnownRequestError) {
    if (error.code === "P2025") {
      // "An operation failed because it depends on one or more records that were required but not found."
      return res.status(422).send()
    }
  }

  throw error
}
