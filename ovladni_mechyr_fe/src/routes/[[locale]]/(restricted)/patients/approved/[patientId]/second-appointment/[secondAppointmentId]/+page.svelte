<script lang="ts">
  import { queries } from '$lib/api/queries/index.js';
  import { LoadingIndicator } from '$lib/components/loading';
  import * as Patient from '$lib/components/patient';
  import { createQuery } from '@tanstack/svelte-query';

  export let data;
  $: ({ pageParams } = data);

  $: detailQuery = createQuery(queries.secondAppointments.detail(pageParams.secondAppointmentId));
  $: userQuery = createQuery(queries.users.detail(pageParams.patientId));
  $: firstAppointmentQuery = createQuery({
    ...queries.firstAppointments.detail(Number($userQuery.data?.user.appointment_first_id)),
    enabled: Boolean($userQuery.data?.user.appointment_first_id),
  });
</script>

{#if $userQuery.isLoading}
  <LoadingIndicator />
{:else if $userQuery.isSuccess && $userQuery.data}
  <Patient.Pages.DetailSecondAppointment
    breadcrumbs={data.breadcrumbs}
    context="edit"
    firstAppointmentResponse={{
      data: $firstAppointmentQuery.data,
      isLoading: $firstAppointmentQuery.isLoading,
      isSuccess: $firstAppointmentQuery.isSuccess,
      isError: $firstAppointmentQuery.isError,
    }}
    patientId={pageParams.patientId}
    response={{
      data: $detailQuery.data,
      isLoading: $detailQuery.isLoading,
      isSuccess: $detailQuery.isSuccess,
      isError: $detailQuery.isError,
    }}
  />
{/if}
