import { localizeRoute } from '$lib/i18n';
import { route } from '$lib/ROUTES';
import * as m from '$paraglide/messages';

export async function load({ parent, params }) {
  const { breadcrumbs: parentBreadcrumbs } = await parent();

  const breadcrumbs: typeof parentBreadcrumbs = [
    ...parentBreadcrumbs,
    {
      name: m.personalVisitDiagnostics(),
      link: localizeRoute(
        route('/patients/approved/[patientId]/first-appointment/[firstAppointmentId]', {
          patientId: params.patientId,
          firstAppointmentId: params.firstAppointmentId,
        })
      ),
    },
  ];

  return {
    breadcrumbs,
  };
}
