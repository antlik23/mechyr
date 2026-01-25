import type { UnionToTuple } from 'type-fest';
import type { SelectData } from '../form/types';
import type { UserProstate } from './types';
import * as m from '$paraglide/messages';

export const PROSTATES = [
  'with_prostate',
  'without_prostate',
] as const satisfies UnionToTuple<UserProstate>;

const prostateNames: Record<UserProstate, () => string> = {
  with_prostate: m.withProstate,
  without_prostate: m.withoutProstate,
} as const;

export function getProstatesList(): SelectData[] {
  return PROSTATES.map((prostate) => ({
    value: prostate,
    label: getTranslatedProstate(prostate),
  }));
}

export function getTranslatedProstate(prostate: UserProstate) {
  return prostateNames[prostate]?.() ?? prostate;
}

export function getHasProstatesList(): SelectData[] {
  const prostateLabels: Record<UserProstate, () => string> = {
    with_prostate: m.yes,
    without_prostate: m.no,
  } as const;

  return PROSTATES.map((prostate) => ({
    value: prostate,
    label: prostateLabels[prostate](),
  }));
}
