<script lang="ts">
  import { createQuery } from '@tanstack/svelte-query';
  import { queries } from '$lib/api/queries';
  import * as VoidingDiary from '$lib/components/voiding-diary';

  const query = createQuery(queries.voidingDiaries.latest);
  const anamnesticQuery = createQuery(queries.anamnestic.list());
</script>

<VoidingDiary.Pages.Overview
  anamnesticResponse={{
    data: $anamnesticQuery.data,
    isLoading: $anamnesticQuery.isLoading,
    isSuccess: $anamnesticQuery.isSuccess,
    isError: $anamnesticQuery.isError,
  }}
  response={{
    data: $query.data,
    isLoading: $query.isLoading,
    isSuccess: $query.isSuccess,
    isError: $query.isError,
  }}
/>
