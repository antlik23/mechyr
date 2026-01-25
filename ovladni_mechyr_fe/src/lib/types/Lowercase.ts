export type IsLowerCase<T extends PropertyKey> = T extends string
  ? T extends Lowercase<T>
    ? true
    : false
  : false;

export type PickLowercaseCaseKeys<T> = {
  [K in keyof T]: IsLowerCase<K> extends true ? K : never;
}[keyof T];
