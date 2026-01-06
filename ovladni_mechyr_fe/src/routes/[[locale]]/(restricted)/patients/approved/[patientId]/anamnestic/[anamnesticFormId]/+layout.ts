import { localizeRoute } from '$lib/i18n';
import { route } from '$lib/ROUTES';
import * as m from '$paraglide/messages';

export async function load({ parent, params }) {
  const { breadcrumbs: parentBreadcrumbs } = await parent();

  const breadcrumbs: typeof parentBreadcrumbs = [
    ...parentBreadcrumbs,
    {
      name: m.anamnesticForm(),
      link: localizeRoute(
        route('/patients/approved/[patientId]/anamnestic/[anamnesticFormId]', {
          patientId: params.patientId,
          anamnesticFormId: params.anamnesticFormId,
        })
      ),
    },
  ];

  return {
    breadcrumbs,
  };
}
