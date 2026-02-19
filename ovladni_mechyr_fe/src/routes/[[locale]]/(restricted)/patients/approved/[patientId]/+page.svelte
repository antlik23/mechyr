<script lang="ts">
  import { createQuery } from '@tanstack/svelte-query';
  import { queries } from '$lib/api/queries';
  import * as Patient from '$lib/components/patient';
  import { writable } from 'svelte/store';

  export let data;
  $: ({ pageParams } = data);

  $: detailQuery = createQuery(queries.users.detail(pageParams.patientId));

  $: diariesQuery = createQuery(queries.users.detail(pageParams.patientId)._ctx.diaries);

  // Default to latest (first) diary
  $: latestDiaryId = $diariesQuery.data?.voiding_diaries.at(0)?.id;

  // Selected diary state - initialized to latest diary
  const selectedDiaryId = writable<number | undefined>(undefined);
  $: if (latestDiaryId !== undefined && $selectedDiaryId === undefined) {
    $selectedDiaryId = latestDiaryId;
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
