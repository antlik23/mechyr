import type { SelectData } from '../form/types';
import type { UserGenderWithOther } from './types';
import type { IsUnique } from '$lib/types/Array';
import { assert, type Equals } from 'tsafe';
import * as m from '$paraglide/messages';

export const GENDERS = ['male', 'female', 'other'] as const satisfies UserGenderWithOther[];
assert<Equals<(typeof GENDERS)[number], UserGenderWithOther>>();
assert<Equals<IsUnique<typeof GENDERS>, true>>();

const genderNames: Record<UserGenderWithOther, () => string> = {
  female: m.woman,
  male: m.man,
  other: m.other,
} as const;

export function getGendersList(): SelectData[] {
  return GENDERS.map((gender) => ({
    value: gender,
    label: getTranslatedGender(gender),
  }));
}

export function getTranslatedGender(gender: UserGenderWithOther) {
  return genderNames[gender]?.() ?? gender;
}
