import type { ComponentProps } from 'svelte';
import type Breadcrumbs from '$lib/components/ui-wrappers/Breadcrumbs.svelte';
import { localizeRoute } from '$lib/i18n';
import { route } from '$lib/ROUTES';
import * as m from '$paraglide/messages';

export function load() {
  const breadcrumbs: ComponentProps<Breadcrumbs>['breadcrumbs'] = [
    {
      name: m.patientsList(),
      link: localizeRoute(route('/patients/approved')),
    },
  ];

  return { breadcrumbs };
}
