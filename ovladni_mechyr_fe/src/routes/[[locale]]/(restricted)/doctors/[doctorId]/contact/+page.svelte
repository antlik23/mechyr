<script lang="ts">
  import { createQuery } from '@tanstack/svelte-query';
  import { queries } from '$lib/api/queries';
  import * as Doctor from '$lib/components/doctor';

  export let data;
  $: ({ pageParams } = data);

  $: detailQuery = createQuery(queries.doctors.detail(pageParams.doctorId));
  $: voidingDiariesQuery = createQuery(queries.voidingDiaries.list());

  $: hasCompletedDiary =
    $voidingDiariesQuery.data?.voiding_diaries?.some((diary) => diary.completed) || false;
</script>

<Doctor.Pages.DetailContact
  breadcrumbs={data.breadcrumbs}
  {hasCompletedDiary}
  response={{
    data: $detailQuery.data,
    isLoading: $detailQuery.isLoading,
    isSuccess: $detailQuery.isSuccess,
    isError: $detailQuery.isError,
  }}
/>
