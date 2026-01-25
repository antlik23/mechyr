<script lang="ts">
  import { createQuery } from '@tanstack/svelte-query';
  import { queries } from '$lib/api/queries';
  import * as Questionnaire from '$lib/components/questionnaire';

  export let data;
  $: ({ pageParams } = data);

  $: iciqQuery = createQuery(queries.iciq.detail(pageParams.iciqFormId));
</script>

<Questionnaire.Iciq.Pages.Detail
  breadcrumbs={data.breadcrumbs}
  response={{
    data: $iciqQuery.data,
    isLoading: $iciqQuery.isLoading,
    isSuccess: $iciqQuery.isSuccess,
    isError: $iciqQuery.isError,
  }}
  userContext="doctor"
/>
