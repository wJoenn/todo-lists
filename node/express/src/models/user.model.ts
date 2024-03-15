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

const hashArgsPassword = async <A extends UserCreateArgs>(args: A): Promise<UserCreateArgs> => {
  const salt = await bcrypt.genSalt()
  args.data.password = await bcrypt.hash(args.data.password, salt)

  return args
}

const passwordConfirmationMatchesPassword = ({ password, password_confirmation }: UserCreateArgs["data"]): boolean => {
  if (!password_confirmation) { return true }
  return password === password_confirmation
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

const toJSON = (user: Prisma.UserUncheckedUpdateInput) => omit(user, "password")

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
  .refine(passwordConfirmationMatchesPassword, {
    message: "Password confirmation doesn't match Password",
    path: ["password_confirmation"]
  }) satisfies zod.Schema<UserCreateArgs["data"]>

export default prisma.$extends({
  model: {
    user: {
      create: async <A extends UserCreateArgs>(args: A) => {
        args.data = UserSchema.parse(args.data)
        const argsWithHashedPassword = await hashArgsPassword(args)

        try {
          const user = await prisma.user.create(argsWithHashedPassword) as Prisma.UserGetPayload<A>
          return { ...user, toJSON: toJSON(user) }
        } catch (error) {
          throw prismaError(error)
        }
      }
    }
  },
  result: {
    user: {
      toJSON: {
        compute: toJSON
      }
    }
  }
})
