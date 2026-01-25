<script lang="ts">
  import { createQuery } from '@tanstack/svelte-query';
  import { queries } from '$lib/api/queries/index.js';
  import * as Questionnaire from '$lib/components/questionnaire';

  export let data;

  const ipssQuery = createQuery(queries.ipss.list());
</script>

<Questionnaire.Ipss.Pages.Detail
  continueLink={data.continueLink}
  response={{
    data: $ipssQuery.data,
    isLoading: $ipssQuery.isLoading,
    isSuccess: $ipssQuery.isSuccess,
    isError: $ipssQuery.isError,
  }}
/>
