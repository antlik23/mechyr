<script lang="ts">
  import { createQuery } from '@tanstack/svelte-query';
  import { queries } from '$lib/api/queries';
  import * as Patient from '$lib/components/patient';

  export let data;
  $: ({ pageParams } = data);

  $: detailQuery = createQuery(queries.users.detail(pageParams.patientId));

  $: diariesQuery = createQuery(queries.users.detail(pageParams.patientId)._ctx.diaries);

  $: latestDiaryId = $diariesQuery.data?.voiding_diaries.at(0)?.id;
  $: latestDiaryQuery = createQuery({
    ...queries.voidingDiaries.detail(Number(latestDiaryId)),
    enabled: Boolean(latestDiaryId),
  });

  $: questionnairesQuery = createQuery(queries.users.detail(pageParams.patientId)._ctx.forms);
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
    data: $latestDiaryQuery.data,
    isLoading: $latestDiaryQuery.isLoading,
    isSuccess: $latestDiaryQuery.isSuccess,
    isError: $latestDiaryQuery.isError,
  }}
  questionnairesResponse={{
    data: $questionnairesQuery.data,
    isLoading: $questionnairesQuery.isLoading,
    isSuccess: $questionnairesQuery.isSuccess,
    isError: $questionnairesQuery.isError,
  }}
  voidingDiariesResponse={{
    data: $diariesQuery.data,
    isLoading: $diariesQuery.isLoading,
    isSuccess: $diariesQuery.isSuccess,
    isError: $diariesQuery.isError,
  }}
/>
