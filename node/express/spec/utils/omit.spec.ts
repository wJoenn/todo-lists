import { omit } from "src/utils"

describe("omit", () => {
  it("returns a record excluding a given list of keys", () => {
    const record = { foo: 1, bar: 2, baz: 3 }
    const omitted = omit(record, "bar", "baz")

    expect(omitted).toStrictEqual({ foo: 1 })
  })
})
