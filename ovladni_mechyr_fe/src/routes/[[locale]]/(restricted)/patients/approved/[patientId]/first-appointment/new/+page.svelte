<script lang="ts">
  import { createQuery } from '@tanstack/svelte-query';
  import { queries } from '$lib/api/queries/index.js';
  import * as Patient from '$lib/components/patient';
  import { LoadingIndicator } from '$lib/components/loading';

  export let data;
  $: ({ pageParams } = data);

  $: userQuery = createQuery(queries.users.detail(pageParams.patientId));
  $: initialAppointmentQuery = createQuery({
    ...queries.initialAppointments.detail(Number($userQuery.data?.user.appointment_initial_id)),
    enabled: Boolean($userQuery.data?.user.appointment_initial_id),
  });
</script>

{#if $userQuery.isLoading}
  <LoadingIndicator />
{:else if $userQuery.isSuccess && $userQuery.data}
  <Patient.Pages.DetailFirstAppointment
    breadcrumbs={data.breadcrumbs}
    context="new"
    gender={$userQuery.data.user.gender}
    initialAppointmentResponse={{
      data: $initialAppointmentQuery.data,
      isLoading: $initialAppointmentQuery.isLoading,
      isSuccess: $initialAppointmentQuery.isSuccess,
      isError: $initialAppointmentQuery.isError,
    }}
    patientId={pageParams.patientId}
  />
{/if}
