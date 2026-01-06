import { localizeRoute } from '$lib/i18n.js';
import { redirect } from '@sveltejs/kit';
import { route } from '$lib/ROUTES';
import { persistedUser } from '$lib/components/user/data';
import { get } from 'svelte/store';
import { availableLanguageTags, type AvailableLanguageTag } from '$paraglide/runtime';
import { goto } from '$app/navigation';
import { toast } from 'svelte-sonner';
import { assert, type Equals } from 'tsafe';
import * as m from '$paraglide/messages';

/** Happens before page loads. */
export function handleServerRedirect(url: URL) {
  const currentPathname = url.pathname.endsWith('/') ? url.pathname.slice(0, -1) : url.pathname;

  const startsWithSomeLanguageTag = availableLanguageTags.some((availableLanguageTag) =>
    currentPathname.startsWith(`/${availableLanguageTag}`)
  );

  if (!startsWithSomeLanguageTag) {
    redirect(307, `${localizeRoute(url.pathname)}${url.search}`);
  }
}

/**  Happens after page loads.*/
export function handleClientRedirect(url: URL) {
  const userData = get(persistedUser);
  const currentPathname = url.pathname.endsWith('/') ? url.pathname.slice(0, -1) : url.pathname;

  for (const availableLanguageTag of availableLanguageTags) {
    if (currentPathname === `/${availableLanguageTag}/login`) {
      if (userData?.user.id) {
        redirectAfterLogin(availableLanguageTag);
      }
    }
  }
}

export async function redirectAfterLogin(targetLanguageTag?: AvailableLanguageTag) {
  const userData = get(persistedUser);

  for (const role of userData?.user.roles ?? []) {
    switch (role) {
      case 'admin':
        return goto(localizeRoute(route('/doctors'), targetLanguageTag));

      case 'patient':
        return goto(localizeRoute(route('/dashboard'), targetLanguageTag));

      case 'doctor':
        return goto(localizeRoute(route('/patients/approved'), targetLanguageTag));

      default:
        assert<Equals<typeof role, never>>();
    }
  }

  console.error('Missing roles!');
  throw new Error(m.unexpectedError());
}

export async function redirectAfterSessionExpired() {
  await goto(localizeRoute(route('/login')));
  toast.info(m.sessionExpired());
}
