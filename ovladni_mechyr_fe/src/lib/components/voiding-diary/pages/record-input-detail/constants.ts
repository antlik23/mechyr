import type { RequestBodyJSON } from 'openapi-typescript-helpers';
import type { UpdatedPaths } from '$lib/api/api';
import type { IsUnique } from '$lib/types/Array';
import { assert, type Equals } from 'tsafe';

export type BeverageType = NonNullable<
  RequestBodyJSON<
    UpdatedPaths['/api/v1/voiding_diaries/{voiding_diary_id}/voiding_records']['post']
  >['voiding_record']['beverage_type']
>;

export const BEVERAGE_TYPE = [
  'clear_water',
  'fizzy_water',
  'mineral_water',
  'hot_beverage',
  'sweet_drink',
  'citrus_drink',
  'alcohol',
  'other',
] as const satisfies BeverageType[];
assert<Equals<(typeof BEVERAGE_TYPE)[number], BeverageType>>();
assert<Equals<IsUnique<typeof BEVERAGE_TYPE>, true>>();

// TODO: move to paraglide messages
const beverageTypeNames: Record<BeverageType, () => string> = {
  clear_water: () => 'Voda čistá',
  fizzy_water: () => 'Voda sycená',
  mineral_water: () => 'Voda minerální',
  hot_beverage: () => 'Káva a čaj',
  sweet_drink: () => 'Energetické nápoje a kola',
  citrus_drink: () => 'Citrusové nápoje',
  alcohol: () => 'Alkohol',
  other: () => 'Ostatní',
} as const;

export function getBeverageTypeList() {
  return BEVERAGE_TYPE.map((beverageType) => ({
    value: beverageType,
    label: getTranslatedBeverageTypeName(beverageType),
  }));
}

export function getTranslatedBeverageTypeName(beverageType: BeverageType) {
  return beverageTypeNames[beverageType]?.() ?? beverageType;
}
