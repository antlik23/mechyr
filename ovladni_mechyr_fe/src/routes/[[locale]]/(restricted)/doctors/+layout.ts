import type { ComponentProps } from 'svelte';
import type Breadcrumbs from '$lib/components/ui-wrappers/Breadcrumbs.svelte';
import { get } from 'svelte/store';
import { currentUser } from '$lib/components/user/data';
import { localizeRoute } from '$lib/i18n';
import { route } from '$lib/ROUTES';
import * as m from '$paraglide/messages';

export function load() {
  const currentUserData = get(currentUser);

  const breadcrumbs: ComponentProps<Breadcrumbs>['breadcrumbs'] = [
    {
      name: currentUserData.isAdmin ? m.doctorsList() : m.doctorSelection(),
      link: localizeRoute(route('/doctors')),
    },
  ];

  return { breadcrumbs };
}
