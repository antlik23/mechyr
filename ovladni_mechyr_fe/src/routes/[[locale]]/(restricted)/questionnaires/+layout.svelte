<script lang="ts">
  import { page } from '$app/stores';
  import { createQuery } from '@tanstack/svelte-query';
  import { queries } from '$lib/api/queries';
  import { shouldContinueFromOabForm } from '$lib/components/questionnaire/oab/pages';
  import { shouldContinueFromIciqForm } from '$lib/components/questionnaire/iciq/pages';
  import * as Questionnaire from '$lib/components/questionnaire';

  export let data;

  const oabQuery = createQuery(queries.oab.list());
  const iciqQuery = createQuery(queries.iciq.list());

  $: if (data.continueLink) {
    for (let i = 0; i < data.breadcrumbs.length; i++) {
      const { name } = data.breadcrumbs[i];
      const nextBreadcrumb = data.breadcrumbs[i + 1];

      if (!nextBreadcrumb) continue;

      if (
        (name.toLowerCase().includes('oab') &&
          shouldContinueFromOabForm(Number($oabQuery.data?.oab_forms?.at(0)?.total_score))) ||
        (name.toLowerCase().includes('iciq') &&
          shouldContinueFromIciqForm(Number($iciqQuery.data?.iciq_forms?.at(0)?.total_score)))
      ) {
        data.breadcrumbs[i + 1].isLink = true;
      }
    }
  }
</script>

<Questionnaire.UiWrappers.Breadcrumbs
  breadcrumbs={data.breadcrumbs}
  currentUrlPathName={$page.url.pathname}
/>

<slot />
