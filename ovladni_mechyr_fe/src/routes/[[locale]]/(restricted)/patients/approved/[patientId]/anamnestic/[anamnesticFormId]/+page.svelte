<script lang="ts">
  import { createQuery } from '@tanstack/svelte-query';
  import { queries } from '$lib/api/queries';
  import * as Questionnaire from '$lib/components/questionnaire';

  export let data;
  $: ({ pageParams } = data);

  $: anamnesticQuery = createQuery(queries.anamnestic.detail(pageParams.anamnesticFormId));
</script>

<Questionnaire.Anamnestic.Pages.Detail
  breadcrumbs={data.breadcrumbs}
  formGender={$anamnesticQuery.data?.anamnestic_form.gender ?? 'male'}
  response={{
    data: $anamnesticQuery.data,
    isLoading: $anamnesticQuery.isLoading,
    isSuccess: $anamnesticQuery.isSuccess,
    isError: $anamnesticQuery.isError,
  }}
  userContext="doctor"
/>
