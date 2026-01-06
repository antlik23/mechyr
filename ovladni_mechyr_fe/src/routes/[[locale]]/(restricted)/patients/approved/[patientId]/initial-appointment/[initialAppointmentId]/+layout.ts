import { localizeRoute } from '$lib/i18n';
import { route } from '$lib/ROUTES';
import * as m from '$paraglide/messages';

export async function load({ parent, params }) {
  const { breadcrumbs: parentBreadcrumbs } = await parent();

  const breadcrumbs: typeof parentBreadcrumbs = [
    ...parentBreadcrumbs,
    {
      name: m.remotePatientDiagnostics(),
      link: localizeRoute(
        route('/patients/approved/[patientId]/initial-appointment/[initialAppointmentId]', {
          patientId: params.patientId,
          initialAppointmentId: params.initialAppointmentId,
        })
      ),
    },
  ];

  return {
    breadcrumbs,
  };
}
