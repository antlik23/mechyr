<script lang="ts">
  import { queries } from '$lib/api/queries/index.js';
  import * as Patient from '$lib/components/patient';
  import { currentUser } from '$lib/components/user/data';
  import { createQuery } from '@tanstack/svelte-query';

  export let data;
  $: ({ pageParams } = data);

  $: detailQuery = createQuery(queries.initialAppointments.detail(pageParams.initialAppointmentId));
  $: userQuery = createQuery(queries.users.detail(pageParams.patientId));
</script>

<Patient.Pages.DetailInitialAppointment
  breadcrumbs={data.breadcrumbs}
  context={$currentUser.isAdmin ? 'edit' : 'read'}
  patientId={pageParams.patientId}
  response={{
    data: $detailQuery.data,
    isLoading: $detailQuery.isLoading,
    isSuccess: $detailQuery.isSuccess,
    isError: $detailQuery.isError,
  }}
  userResponse={{
    data: $userQuery.data,
    isLoading: $userQuery.isLoading,
    isSuccess: $userQuery.isSuccess,
    isError: $userQuery.isError,
  }}
/>
