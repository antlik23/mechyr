<script lang="ts">
  import { createQuery } from '@tanstack/svelte-query';
  import { queries } from '$lib/api/queries';
  import * as Entry from '$lib/components/entry';

  export let data;

  const oabQuery = createQuery(queries.oab.list());
  const iciqQuery = createQuery(queries.iciq.list());
  const ipssQuery = createQuery(queries.ipss.list());
  const anamnesticQuery = createQuery(queries.anamnestic.list());
  const voidingDiariesQuery = createQuery(queries.voidingDiaries.list(data.voidingDiariesFilters));
</script>

<Entry.Pages.List
  anamnesticResponse={{
    data: $anamnesticQuery.data,
    isLoading: $anamnesticQuery.isLoading,
    isSuccess: $anamnesticQuery.isSuccess,
    isError: $anamnesticQuery.isError,
  }}
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
  oabResponse={{
    data: $oabQuery.data,
    isLoading: $oabQuery.isLoading,
    isSuccess: $oabQuery.isSuccess,
    isError: $oabQuery.isError,
  }}
  voidingDiariesResponse={{
    data: $voidingDiariesQuery.data,
    isLoading: $voidingDiariesQuery.isLoading,
    isSuccess: $voidingDiariesQuery.isSuccess,
    isError: $voidingDiariesQuery.isError,
  }}
/>
