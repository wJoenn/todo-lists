import bcrypt from "bcrypt"
import { z as zod } from "zod"
import { Prisma } from "@prisma/client"
import { omit } from "../utils"
import prisma from "~/libs/prisma.ts"

type UserCreateArgs = Omit<Prisma.UserCreateArgs, "data"> & {
  data: Prisma.UserCreateInput & {
    password_confirmation?: string
  }
}

const _hashed_args = async <A extends UserCreateArgs>(args: A) => {
  const { select, data } = args

  const salt = await bcrypt.genSalt()
  data.password = await bcrypt.hash(data.password, salt)

  return {
    select: select as A["select"],
    data
  }
}

const _prismaError = (error: unknown) => {
  if (error instanceof Prisma.PrismaClientKnownRequestError) {
    if (error.code === "P2002") {
      return Object.assign(new Error(), {
        issues: [{ path: ["email"], message: "Email has already been taken" }]
      })
    }
  }

  return error
}

const _toJSON = (user: Prisma.UserUncheckedUpdateInput) => omit(user, "password")

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
      create: async <A extends UserCreateArgs>(args: A) => {
        args.data = UserSchema.parse(args.data)
        const hashed_args = await _hashed_args(args)

        try {
          const user = await prisma.user.create(hashed_args) as Prisma.UserGetPayload<A>
          return { ...user, toJSON: _toJSON(user) }
        } catch (error) { throw _prismaError(error) }
      }
    }
  },
  result: {
    user: {
      toJSON: {
        compute: _toJSON
      }
    }
  }
})
