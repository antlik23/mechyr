import { localizeRoute } from '$lib/i18n';
import { route } from '$lib/ROUTES';
import * as m from '$paraglide/messages';

export async function load({ parent, params }) {
  const { breadcrumbs: parentBreadcrumbs } = await parent();

  const breadcrumbs: typeof parentBreadcrumbs = [
    ...parentBreadcrumbs,
    {
      name: m.income(),
      link: localizeRoute(
        route('/patients/approved/[patientId]/voiding-diary/[diaryId]/records/input/[recordId]', {
          patientId: params.patientId,
          diaryId: params.diaryId,
          recordId: params.recordId,
        })
      ),
    },
  ];

  return {
    breadcrumbs,
  };
}
