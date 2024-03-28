import { omit } from "src/utils"

describe("omit", () => {
  it("returns a record excluding a given list of keys", () => {
    const record = { bar: 2, baz: 3, foo: 1 }
    const omitted = omit(record, "bar", "baz")

    expect(omitted).toStrictEqual({ foo: 1 })
  })
})
