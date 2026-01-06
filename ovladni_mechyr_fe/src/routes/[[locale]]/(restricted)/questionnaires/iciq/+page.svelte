<script lang="ts">
  import { createQuery } from '@tanstack/svelte-query';
  import { queries } from '$lib/api/queries';
  import * as Questionnaire from '$lib/components/questionnaire';

  export let data;

  const iciqQuery = createQuery(queries.iciq.list());
</script>

<Questionnaire.Iciq.Pages.Detail
  continueLink={data.continueLink}
  response={{
    data: $iciqQuery.data,
    isLoading: $iciqQuery.isLoading,
    isSuccess: $iciqQuery.isSuccess,
    isError: $iciqQuery.isError,
  }}
/>
