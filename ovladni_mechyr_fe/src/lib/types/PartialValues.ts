export type PartialValues<TObject> = {
  [Key in keyof TObject & keyof never]-?: TObject[Key] | undefined;
};
