import { get } from 'svelte/store';
import { redirect } from '@sveltejs/kit';
import { localizeRoute } from '$lib/i18n';
import { route } from '$lib/ROUTES';
import { persistedUser } from '$lib/components/user/data';

export async function load() {
  const userData = get(persistedUser);

  if (!userData) {
    redirect(307, localizeRoute(route('/login')));
  }
}
