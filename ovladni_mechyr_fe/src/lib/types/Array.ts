export type IsInArray<
  TArray extends readonly unknown[],
  TArrayItem,
> = TArrayItem extends TArray[number] ? true : false;

export type IsUnique<TArray extends readonly unknown[]> = TArray extends readonly [
  infer TArrayItem,
  ...infer TRest,
]
  ? IsInArray<TRest, TArrayItem> extends true
    ? [never, 'Encountered value with duplicates:', TArrayItem]
    : IsUnique<TRest>
  : true;
