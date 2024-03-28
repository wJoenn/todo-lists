import jwt from "jsonwebtoken"
import { decode, encode, jti } from "~/libs/jwt.ts"

describe("jwt", () => {
  const jwtid = jti()
  const bearer = encode(jwtid)

  describe("decode", () => {
    it("decodes as Json Web Token into a jti", () => {
      expect(decode(bearer)).toBe(jwtid)
    })

    it("returns undefined when an error is triggered", () => {
      expect(decode(`${bearer.slice(0, bearer.length - 1)}a`)).toBeUndefined()
      expect(decode("not a bearer token")).toBeUndefined()
    })
  })

  describe("encode", () => {
    it("encodes a jti into a Json Web Token", () => {
      expect(bearer).toMatch(/^Bearer \w+/)
    })

    it("addq an expiration date of 30 days", () => {
      const token = bearer.replace(/^Bearer /, "")
      const payload = jwt.verify(token, process.env.JWT_SECRET_KEY) as jwt.JwtPayload

      const payloadDate = new Date((payload.exp ?? 0) * 1000).toDateString()
      const dateIn30Days = new Date(new Date().setDate(new Date().getDate() + 30)).toDateString()
      expect(payloadDate).toBe(dateIn30Days)
    })
  })

  describe("jti", () => {
    it("creates random Json Web Token ids", () => {
      const jtis = Array.from(Array(100))
        .map(() => jti())
        .filter((jwtId, index, array) => array.indexOf(jwtId) === index)

      expect(jtis).toHaveLength(100)
    })
  })
})
