import { localizeRoute } from '$lib/i18n';
import { route } from '$lib/ROUTES';
import * as m from '$paraglide/messages';

export async function load({ parent, params }) {
  const { breadcrumbs: parentBreadcrumbs } = await parent();

  const breadcrumbs: typeof parentBreadcrumbs = [
    ...parentBreadcrumbs,
    {
      name: m.voidingDiary(),
      link: localizeRoute(
        route('/patients/approved/[patientId]/voiding-diary/[diaryId]/records', {
          patientId: params.patientId,
          diaryId: params.diaryId,
        })
      ),
    },
    {
      name: m.editation(),
      link: localizeRoute(
        route('/patients/approved/[patientId]/voiding-diary/[diaryId]/edit', {
          patientId: params.patientId,
          diaryId: params.diaryId,
        })
      ),
    },
  ];

  return {
    breadcrumbs,
  };
}
