<script lang="ts">
  import { onMount, tick } from 'svelte';
  import { createQuery, useQueryClient } from '@tanstack/svelte-query';
  import { queries } from '$lib/api/queries';
  import * as Patient from '$lib/components/patient';
  import { writable } from 'svelte/store';

  export let data;
  $: ({ pageParams } = data);

  const queryClient = useQueryClient();

  $: detailQuery = createQuery(queries.users.detail(pageParams.patientId));

  $: diariesQuery = createQuery(queries.users.detail(pageParams.patientId)._ctx.diaries);

  // Default to latest (first) diary
  $: latestDiaryId = $diariesQuery.data?.voiding_diaries.at(0)?.id;

  // Prefetch all diary details to prevent layout shifts when clicking
  $: if ($diariesQuery.data?.voiding_diaries) {
    $diariesQuery.data.voiding_diaries.forEach((diary) => {
      queryClient.prefetchQuery(queries.voidingDiaries.detail(diary.id));
    });
  }

  // Selected diary state - initialized to latest diary
  const selectedDiaryId = writable<number | undefined>(undefined);

  // Initialize selected diary after mount to prevent auto-scroll issues
  onMount(async () => {
    await tick(); // Wait for DOM to fully render
    if (latestDiaryId !== undefined) {
      $selectedDiaryId = latestDiaryId;
    }
  });

  // Update selected diary when latest changes (e.g., new diary added)
  let previousLatestDiaryId: number | undefined = undefined;
  $: if (latestDiaryId !== undefined && latestDiaryId !== previousLatestDiaryId) {
    previousLatestDiaryId = latestDiaryId;
    if ($selectedDiaryId === undefined) {
      $selectedDiaryId = latestDiaryId;
    }
  }

  // Query for the selected diary
  $: selectedDiaryQuery = createQuery({
    ...queries.voidingDiaries.detail(Number($selectedDiaryId)),
    enabled: Boolean($selectedDiaryId),
  });

  $: questionnairesQuery = createQuery(queries.users.detail(pageParams.patientId)._ctx.forms);

  // Handler for diary selection
  function handleDiarySelect(diaryId: number) {
    $selectedDiaryId = diaryId;
  }
</script>

<Patient.Pages.Detail
  breadcrumbs={data.breadcrumbs}
  detailResponse={{
    data: $detailQuery.data,
    isLoading: $detailQuery.isLoading,
    isSuccess: $detailQuery.isSuccess,
    isError: $detailQuery.isError,
  }}
  latestVoidingDiaryResponse={{
    data: $selectedDiaryQuery.data,
    isLoading: $selectedDiaryQuery.isLoading,
    isSuccess: $selectedDiaryQuery.isSuccess,
    isError: $selectedDiaryQuery.isError,
  }}
  onDiarySelect={handleDiarySelect}
  questionnairesResponse={{
    data: $questionnairesQuery.data,
    isLoading: $questionnairesQuery.isLoading,
    isSuccess: $questionnairesQuery.isSuccess,
    isError: $questionnairesQuery.isError,
  }}
  {selectedDiaryId}
  voidingDiariesResponse={{
    data: $diariesQuery.data,
    isLoading: $diariesQuery.isLoading,
    isSuccess: $diariesQuery.isSuccess,
    isError: $diariesQuery.isError,
  }}
/>
