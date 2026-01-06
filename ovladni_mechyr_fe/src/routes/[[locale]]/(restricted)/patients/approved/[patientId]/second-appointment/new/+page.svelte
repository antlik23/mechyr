<script lang="ts">
  import { createQuery } from '@tanstack/svelte-query';
  import { queries } from '$lib/api/queries/index.js';
  import * as Patient from '$lib/components/patient';
  import { LoadingIndicator } from '$lib/components/loading';

  export let data;
  $: ({ pageParams } = data);

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
    context="new"
    firstAppointmentResponse={{
      data: $firstAppointmentQuery.data,
      isLoading: $firstAppointmentQuery.isLoading,
      isSuccess: $firstAppointmentQuery.isSuccess,
      isError: $firstAppointmentQuery.isError,
    }}
    patientId={pageParams.patientId}
  />
{/if}
