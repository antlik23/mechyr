<script lang="ts">
  import { createQuery } from '@tanstack/svelte-query';
  import { queries } from '$lib/api/queries';
  import * as Questionnaire from '$lib/components/questionnaire';

  export let data;
  $: ({ pageParams } = data);

  $: oabQuery = createQuery(queries.oab.detail(pageParams.oabFormId));
</script>

<Questionnaire.Oab.Pages.Detail
  breadcrumbs={data.breadcrumbs}
  formGender={$oabQuery.data?.oab_form.gender ?? 'male'}
  response={{
    data: $oabQuery.data,
    isLoading: $oabQuery.isLoading,
    isSuccess: $oabQuery.isSuccess,
    isError: $oabQuery.isError,
  }}
  userContext="doctor"
/>
