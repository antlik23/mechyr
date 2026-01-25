<script lang="ts">
  import { createQuery } from '@tanstack/svelte-query';
  import { queries } from '$lib/api/queries/index.js';
  import * as VoidingDiary from '$lib/components/voiding-diary';

  export let data;
  $: ({ pageParams } = data);

  $: detailQuery = createQuery(
    queries.voidingDiaries.detail(pageParams.diaryId)._ctx.recordDetail(pageParams.recordId)
  );
  $: diaryQuery = createQuery(queries.voidingDiaries.detail(pageParams.diaryId));
</script>

<VoidingDiary.Pages.RecordInputDetail
  breadcrumbs={data.breadcrumbs}
  context="edit"
  diaryId={pageParams.diaryId}
  patientId={pageParams.patientId}
  response={{
    data: $detailQuery.data,
    isLoading: $detailQuery.isLoading,
    isSuccess: $detailQuery.isSuccess,
    isError: $detailQuery.isError,
  }}
  userContext="doctor"
  voidingDiaryResponse={{
    data: $diaryQuery.data,
    isLoading: $diaryQuery.isLoading,
    isSuccess: $diaryQuery.isSuccess,
    isError: $diaryQuery.isError,
  }}
/>
