import type { QuestionnaireBreadcrumbsData } from '$lib/components/questionnaire/ui-wrappers/breadcrumbs.svelte';
import { get } from 'svelte/store';
import { queries } from '$lib/api/queries';
import { queryClient } from '$lib/api/queries';
import { currentUser } from '$lib/components/user/data.js';
import { localizeRoute } from '$lib/i18n';
import { route } from '$lib/ROUTES';
import * as m from '$paraglide/messages';

export async function load({ url }) {
  const { gender } = get(currentUser);

  const breadcrumbs: QuestionnaireBreadcrumbsData[] = [
    { link: localizeRoute(route('/questionnaires')), name: m.oabV8Form(), isLink: true },
    { link: localizeRoute(route('/questionnaires/iciq')), name: m.iciqForm(), isLink: false },
  ];

  if (gender === 'male') {
    breadcrumbs.push({
      link: localizeRoute(route('/questionnaires/ipss')),
      name: m.ipssForm(),
      isLink: false,
    });
  }

  const currentBreadcrumbIndex = breadcrumbs.findIndex(({ link }) => link === url.pathname);
  const lastBreadcrumbContinueLink = localizeRoute(route('/anamnestic'));
  const continueLink =
    breadcrumbs.at(currentBreadcrumbIndex + 1)?.link ??
    (currentBreadcrumbIndex >= 0 ? lastBreadcrumbContinueLink : undefined);

  queryClient.prefetchQuery(queries.oab.list());
  queryClient.prefetchQuery(queries.iciq.list());

  return {
    breadcrumbs,
    continueLink,
  };
}
