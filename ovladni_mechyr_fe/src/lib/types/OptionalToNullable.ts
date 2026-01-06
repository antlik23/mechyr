export type OptionalToNullable<TObject> = {
  [Key in keyof TObject]-?: undefined extends TObject[Key]
    ? NonNullable<TObject[Key]> | null
    : TObject[Key];
};
