<script lang="ts">
  import { createQuery } from '@tanstack/svelte-query';
  import { queries } from '$lib/api/queries';
  import * as VoidingDiary from '$lib/components/voiding-diary';

  export let data;

  const voidingDiariesQuery = createQuery(queries.voidingDiaries.list(data.voidingDiariesFilters));
  const latestVoidingDiaryQuery = createQuery(queries.voidingDiaries.latest);
</script>

<VoidingDiary.Pages.List
  breadcrumbs={data.breadcrumbs}
  latestVoidingDiaryResponse={{
    data: $latestVoidingDiaryQuery.data,
    isLoading: $latestVoidingDiaryQuery.isLoading,
    isSuccess: $latestVoidingDiaryQuery.isSuccess,
    isError: $latestVoidingDiaryQuery.isError,
  }}
  response={{
    data: $voidingDiariesQuery.data,
    isLoading: $voidingDiariesQuery.isLoading,
    isSuccess: $voidingDiariesQuery.isSuccess,
    isError: $voidingDiariesQuery.isError,
  }}
/>
