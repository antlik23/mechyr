import { localizeRoute } from '$lib/i18n';
import { route } from '$lib/ROUTES';
import * as m from '$paraglide/messages';

export async function load({ parent, params }) {
  const { breadcrumbs: parentBreadcrumbs } = await parent();

  const breadcrumbs: typeof parentBreadcrumbs = [
    ...parentBreadcrumbs,
    {
      name: m.addIncome(),
      link: localizeRoute(
        route('/voiding-diary/list/[diaryId]/records/input/new', { diaryId: params.diaryId })
      ),
    },
  ];

  return {
    breadcrumbs,
  };
}
