<script lang="ts">
  import { queries, queryClient } from '$lib/api/queries';
  import { currentUser } from '$lib/components/user/data';
  import * as VoidingDiary from '$lib/components/voiding-diary';
  import { createQuery } from '@tanstack/svelte-query';
  import { onMount, type ComponentEvents } from 'svelte';
  import { assert, type Equals } from 'tsafe';
  import type { IsAny } from 'type-fest';

  export let data;
  $: ({ pageParams } = data);

  $: voidingDiaryRecordsQuery = createQuery({
    ...queries.voidingDiaries
      .detail(pageParams.diaryId)
      ._ctx.records(data.voidingDiaryRecordsFilters),
    placeholderData: previousData,
  });

  $: diaryQuery = createQuery(queries.voidingDiaries.detail(pageParams.diaryId));

  let previousData: Awaited<
    ReturnType<
      ReturnType<ReturnType<typeof queries.voidingDiaries.detail>['_ctx']['records']>['queryFn']
    >
  >;
  $: if ($voidingDiaryRecordsQuery?.isSuccess) {
    previousData = $voidingDiaryRecordsQuery.data;
  }

  onMount(() => {
    if (!$voidingDiaryRecordsQuery.isSuccess || !$voidingDiaryRecordsQuery.data) return;

    previousData = queryClient.getQueryData(
      queries.voidingDiaries
        .detail(pageParams.diaryId)
        ._ctx.records(data.voidingDiaryRecordsFilters).queryKey
    );
  });

  function handlePagination({
    detail: { page },
  }: ComponentEvents<VoidingDiary.Pages.List>['pagination']) {
    assert<Equals<IsAny<typeof page>, false>>();

    data.voidingDiaryRecordsFilters.page_param = page;
  }
</script>

<VoidingDiary.Pages.RecordList
  breadcrumbs={data.breadcrumbs}
  diaryId={pageParams.diaryId}
  patientId={pageParams.patientId}
  response={{
    data: $voidingDiaryRecordsQuery.data,
    isLoading: $voidingDiaryRecordsQuery.isLoading,
    isSuccess: $voidingDiaryRecordsQuery.isSuccess,
    isError: $voidingDiaryRecordsQuery.isError,
  }}
  userContext={$currentUser.role}
  voidingDiaryResponse={{
    data: $diaryQuery.data,
    isLoading: $diaryQuery.isLoading,
    isSuccess: $diaryQuery.isSuccess,
    isError: $diaryQuery.isError,
  }}
  on:pagination={handlePagination}
/>
