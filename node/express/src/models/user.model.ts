import bcrypt from "bcrypt"
import { z as zod } from "zod"
import { Prisma } from "@prisma/client"
import { omit } from "../utils/index.ts"
import { decode, encode, jti } from "~/libs/jwt.ts"
import prisma from "~/libs/prisma.ts"

type UserCreateArgs = Omit<Prisma.UserCreateArgs, "data"> & {
  data: Prisma.UserCreateInput & {
    password_confirmation?: string
  }
}

export class User {
  constructor(private readonly user: Prisma.UserGetPayload<true | { include: { tasks: true } }>) {}
  get id(): number { return this.user.id }
  get createdAt(): Date { return this.user.createdAt }
  get updatedAt(): Date { return this.user.updatedAt }
  get email(): string { return this.user.email }
  get password(): string { return this.user.password }
  get jti(): string { return this.user.jti }
  get jwt(): string { return encode(this.jti) }
  get tasks(): Prisma.TaskGetPayload<true>[] | undefined {
    if ("tasks" in this.user) {
      return this.user.tasks
    }
  }

  toJSON() {
    return omit(this.user, "jti", "password")
  }

  async editJTI() {
    const user = await prisma.user.update({
      data: { jti: jti() },
      where: { id: this.id }
    })

    Object.assign(this, { user })
  }
}

const UserSchema = zod
  .object({
    email: zod
      .string({ invalid_type_error: "Email can't be blank" })
      .min(1, { message: "Email can't be blank" })
      .regex(/[^@\s]+@[^@\s]+\.[a-z]{2,}|^$/, { message: "Email is invalid" }),
    password: zod
      .string({ invalid_type_error: "Password can't be blank" })
      .min(1, { message: "Password can't be blank" }),
    password_confirmation: zod.string().optional()
  })
  .refine(({ password, password_confirmation }) => {
    if (!password_confirmation) { return true }
    return password === password_confirmation
  }, {
    message: "Password confirmation doesn't match Password",
    path: ["password_confirmation"]
  }) satisfies zod.Schema<UserCreateArgs["data"]>

export default prisma.$extends({
  model: {
    user: {
      byJWT: async (bearer: string) => {
        const jwtId = decode(bearer)
        if (!jwtId) { return }

        const user = await prisma.user.findUnique({ where: { jti: jwtId } })
        if (user) { return new User(user) }
      },

      create: async <A extends UserCreateArgs>(args: A) => {
        args.data = UserSchema.parse(args.data)
        delete args.data.password_confirmation
        const argsWithHashedPassword = await hashArgsPassword(args)

        try {
          const user = await prisma.user.create(argsWithHashedPassword)
          return new User(user)
        } catch (error) {
          throw prismaError(error)
        }
      },

      findFirst: async <A extends Parameters<typeof prisma.user.findFirst>[0]>(args?: A) => {
        const user = await prisma.user.findFirst(args)
        if (user) { return new User(user) }
      },

      findUnique: async <A extends Parameters<typeof prisma.user.findUnique>[0]>(args: A) => {
        const user = await prisma.user.findUnique(args)
        if (user) { return new User(user) }
      }
    }
  }
})

const hashArgsPassword = async <A extends UserCreateArgs>(args: A): Promise<UserCreateArgs> => {
  const salt = await bcrypt.genSalt()
  args.data.password = await bcrypt.hash(args.data.password, salt)

  return args
}

const prismaError = (error: unknown): unknown => {
  if (error instanceof Prisma.PrismaClientKnownRequestError) {
    if (error.code === "P2002") {
      return new zod.ZodError([
        { code: "custom", message: "Email has already been taken", path: ["email"] }
      ])
    }
  }

  return error
}
