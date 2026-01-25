import { localizeRoute } from '$lib/i18n';
import { route } from '$lib/ROUTES';
import * as m from '$paraglide/messages';

export async function load({ parent, params }) {
  const { breadcrumbs: parentBreadcrumbs } = await parent();

  const breadcrumbs: typeof parentBreadcrumbs = [
    ...parentBreadcrumbs,
    {
      name: m.followUpVisitAfterMonths({ monthsAmount: 3 }),
      link: localizeRoute(
        route('/patients/approved/[patientId]/second-appointment/[secondAppointmentId]', {
          patientId: params.patientId,
          secondAppointmentId: params.secondAppointmentId,
        })
      ),
    },
  ];

  return {
    breadcrumbs,
  };
}
