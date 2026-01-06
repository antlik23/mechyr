import type { UserRole } from './types';
import type { IsUnique } from '$lib/types/Array';
import { assert, type Equals } from 'tsafe';
import * as m from '$paraglide/messages';

export const USER_ROLES = ['doctor', 'patient', 'admin'] as const satisfies UserRole[];
assert<Equals<(typeof USER_ROLES)[number], UserRole>>();
assert<Equals<IsUnique<typeof USER_ROLES>, true>>();

const roleNames: Record<UserRole, () => string> = {
  admin: m.admin,
  patient: m.patient,
  doctor: m.doctor,
} as const;

export function getUserRoleList() {
  return USER_ROLES.map((userRole) => ({
    value: userRole,
    label: getTranslatedRoleName(userRole),
  }));
}

export function getTranslatedRoleName(role: UserRole) {
  return roleNames[role]?.() ?? role;
}

export function getTranslatedRoles(roles: UserRole[], sort = true) {
  const translatedRoles = roles.map((role) => getTranslatedRoleName(role));

  if (sort) {
    translatedRoles.sort();
  }

  return translatedRoles.join(', ');
}
