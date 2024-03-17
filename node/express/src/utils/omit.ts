export const omit = <T extends Record<string, unknown>, K extends (keyof T)[]>(record: T, ...keys: K) => (
  Object.fromEntries(Object.entries(record).filter(([key, _]) => !keys.includes(key))) as Omit<T, K[number]>
)
