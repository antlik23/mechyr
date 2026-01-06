<script lang="ts">
  import { createQuery } from '@tanstack/svelte-query';
  import { queries } from '$lib/api/queries';
  import { currentUser } from '$lib/components/user/data';
  import * as Questionnaire from '$lib/components/questionnaire';

  const anamnesticQuery = createQuery(queries.anamnestic.list());
  const iciqQuery = createQuery(queries.iciq.list());
  const ipssQuery = createQuery(queries.ipss.list());
</script>

<Questionnaire.Anamnestic.Pages.Detail
  formGender={$currentUser.gender}
  iciqResponse={{
    data: $iciqQuery.data,
    isLoading: $iciqQuery.isLoading,
    isSuccess: $iciqQuery.isSuccess,
    isError: $iciqQuery.isError,
  }}
  ipssResponse={{
    data: $ipssQuery.data,
    isLoading: $ipssQuery.isLoading,
    isSuccess: $ipssQuery.isSuccess,
    isError: $ipssQuery.isError,
  }}
  response={{
    data: $anamnesticQuery.data,
    isLoading: $anamnesticQuery.isLoading,
    isSuccess: $anamnesticQuery.isSuccess,
    isError: $anamnesticQuery.isError,
  }}
/>
