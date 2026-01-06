<script lang="ts">
  import { createQuery } from '@tanstack/svelte-query';
  import { queries } from '$lib/api/queries';
  import * as Questionnaire from '$lib/components/questionnaire';

  export let data;
  $: ({ pageParams } = data);

  $: ipssQuery = createQuery(queries.ipss.detail(pageParams.ipssFormId));
</script>

<Questionnaire.Ipss.Pages.Detail
  breadcrumbs={data.breadcrumbs}
  response={{
    data: $ipssQuery.data,
    isLoading: $ipssQuery.isLoading,
    isSuccess: $ipssQuery.isSuccess,
    isError: $ipssQuery.isError,
  }}
  userContext="doctor"
/>
