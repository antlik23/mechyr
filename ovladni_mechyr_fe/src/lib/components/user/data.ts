import { goto } from '$app/navigation';
import { route } from '$lib/ROUTES';
import { localizeRoute } from '$lib/i18n';
import * as m from '$paraglide/messages';
import { persisted } from 'svelte-persisted-store';
import { toast } from 'svelte-sonner';
import { derived } from 'svelte/store';
import type { CurrentUserData, User } from './types';

export const persistedUser = persisted<User>('user-data', null);

export const currentUser = derived(persistedUser, (userData) => {
  if (!userData) return {} as CurrentUserData;

  const { user } = userData;

  const isAdmin = user.roles.includes('admin');
  const isDoctor = user.roles.includes('doctor');
  const isPatient = user.roles.includes('patient');

  const role = isAdmin ? 'admin' : isDoctor ? 'doctor' : 'patient';

  return {
    ...user,
    gender: user.gender ?? 'male',
    isAdmin,
    isDoctor,
    isPatient,
    role,
  } satisfies CurrentUserData;
});

export function updateUser(userData: User) {
  persistedUser.set(userData);
}

export async function logout() {
  updateUser(null);

  // Has to be dynamically imported due to issues with dev server.
  const { queryClient } = await import('$lib/api/queries');
  queryClient.removeQueries();

  await goto(localizeRoute(route('/login')));

  toast.success(m.successfulLogout());
}
