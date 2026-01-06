import { localizeRoute } from '$lib/i18n';
import { route } from '$lib/ROUTES';
import * as m from '$paraglide/messages';

export async function load({ parent, params }) {
  const { breadcrumbs: parentBreadcrumbs } = await parent();

  const breadcrumbs: typeof parentBreadcrumbs = [
    ...parentBreadcrumbs,
    {
      name: m.oabV8Form(),
      link: localizeRoute(
        route('/patients/approved/[patientId]/oab/[oabFormId]', {
          patientId: params.patientId,
          oabFormId: params.oabFormId,
        })
      ),
    },
  ];

  return {
    breadcrumbs,
  };
}
