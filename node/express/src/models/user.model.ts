import bcrypt from "bcrypt"
import { z as zod } from "zod"
import { Prisma } from "@prisma/client"
import { omit } from "../utils"
import { decode, encode, jti } from "~/libs/jwt.ts"
import prisma from "~/libs/prisma.ts"

type UserCreateArgs = Omit<Prisma.UserCreateArgs, "data"> & {
  data: Prisma.UserCreateInput & {
    password_confirmation?: string
  }
}

class User {
  constructor(private user: Prisma.UserGetPayload<true>) {}
  get id(): number { return this.user.id }
  get createdAt(): Date { return this.user.createdAt }
  get updatedAt(): Date { return this.user.updatedAt }
  get email(): string { return this.user.email }
  get password(): string { return this.user.password }
  get jti(): string { return this.user.jti }
  get jwt(): string { return encode(this.jti) }

  toJSON() {
    return omit(this.user, "jti", "password")
  }

  async editJTI() {
    const user = await prisma.user.update({
      where: { id: this.id },
      data: { jti: jti() }
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
      byJWT: async (bearer: string): Promise<User | undefined> => {
        const jti = decode(bearer)
        if (!jti) { return }

        const user = await prisma.user.findUnique({ where: { jti } })
        if (user) { return new User(user) }
      },

      create: async <A extends UserCreateArgs>(args: A): Promise<User> => {
        args.data = UserSchema.parse(args.data)
        const argsWithHashedPassword = await hashArgsPassword(args)

        try {
          const user = await prisma.user.create(argsWithHashedPassword) as Prisma.UserGetPayload<A>
          return new User(user)
        } catch (error) {
          throw prismaError(error)
        }
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
      return Object.assign(new Error(), {
        issues: [{ path: ["email"], message: "Email has already been taken" }]
      })
    }
  }

  return error
}
