import type { Request, Response } from "express"
import type { ZodError } from "zod"
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
    return res.status(422).json((error as ZodError).issues.map(issue => issue.message))
  }
}

export const destroy = async (req: Request, res: Response) => {
  try {
    await prisma.task.delete({ where: { id: +req.params.id } })
    return res.status(200).send()
  } catch (error) {
    return res.status(422).send()
  }
}

export const complete = async (req: Request, res: Response) => {
  try {
    const task = await prisma.task.update({ data: { completed: true }, where: { id: +req.params.id } })
    return res.status(200).json(task)
  } catch (error) {
    return res.status(422).json((error as ZodError).issues)
  }
}
