export function compareNullableValues(leftValue: string | null, rightValue: string | null) {
  return Number(leftValue === null) - Number(rightValue === null);
}
