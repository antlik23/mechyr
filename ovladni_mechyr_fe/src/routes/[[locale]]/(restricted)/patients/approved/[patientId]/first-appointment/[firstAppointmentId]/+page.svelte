<script lang="ts">
  import { queries } from '$lib/api/queries/index.js';
  import { LoadingIndicator } from '$lib/components/loading';
  import * as Patient from '$lib/components/patient';
  import { createQuery } from '@tanstack/svelte-query';

  export let data;
  $: ({ pageParams } = data);

  $: detailQuery = createQuery(queries.firstAppointments.detail(pageParams.firstAppointmentId));
  $: userQuery = createQuery(queries.users.detail(pageParams.patientId));
  $: initialAppointmentQuery = createQuery({
    ...queries.initialAppointments.detail(Number($userQuery.data?.user.appointment_initial_id)),
    enabled: Boolean($userQuery.data?.user.appointment_initial_id),
  });
</script>

{#if $userQuery.isLoading}
  <LoadingIndicator />
{:else if $userQuery.isSuccess && $userQuery.data && $userQuery.data.user.gender}
  <Patient.Pages.DetailFirstAppointment
    breadcrumbs={data.breadcrumbs}
    context="edit"
    gender={$userQuery.data.user.gender}
    initialAppointmentResponse={{
      data: $initialAppointmentQuery.data,
      isLoading: $initialAppointmentQuery.isLoading,
      isSuccess: $initialAppointmentQuery.isSuccess,
      isError: $initialAppointmentQuery.isError,
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
