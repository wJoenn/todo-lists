export const omit = <T extends Record<string, unknown>, K extends (keyof T)[]>(record: T, ...keys: K) => {
  const dup: Record<string, unknown> = {}

  Object.entries(record).forEach(([key, value]) => {
    if (!keys.includes(key)) { dup[key] = value }
  })

  return dup as Omit<T, K[number]>
}
