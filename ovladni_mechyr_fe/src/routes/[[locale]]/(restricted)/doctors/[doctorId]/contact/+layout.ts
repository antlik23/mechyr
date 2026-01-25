import { localizeRoute } from '$lib/i18n';
import { route } from '$lib/ROUTES';
import * as m from '$paraglide/messages';

export async function load({ parent, params }) {
  const { breadcrumbs: parentBreadcrumbs } = await parent();

  const breadcrumbs: typeof parentBreadcrumbs = [
    ...parentBreadcrumbs,
    {
      name: m.contactADoctor(),
      link: localizeRoute(route('/doctors/[doctorId]/contact', { doctorId: params.doctorId })),
    },
  ];

  return {
    breadcrumbs,
  };
}
