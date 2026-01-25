export function filterUndefinedObjectValues(item: Record<string, unknown>) {
  return Object.fromEntries(Object.entries(item).filter(([, value]) => value !== undefined));
}

export function setObjectValue<TObject>(
  object: TObject,
  key: keyof TObject,
  value: TObject[keyof TObject]
) {
  object[key] = value;
}
