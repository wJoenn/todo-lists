import crypto from "crypto"
import jwt from "jsonwebtoken"

export const decode = (bearerToken: string): string | undefined => {
  const token = bearerToken.replace(/^Bearer /, "")

  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET_KEY) as jwt.JwtPayload
    return payload.jti
  } catch {
    return undefined
  }
}

export const encode = (jti: string): string => {
  const options: jwt.SignOptions = { expiresIn: "30 days", jwtid: jti }
  const token = jwt.sign({}, process.env.JWT_SECRET_KEY, options)

  return `Bearer ${token}`
}

export const jti = () => crypto.randomUUID()
