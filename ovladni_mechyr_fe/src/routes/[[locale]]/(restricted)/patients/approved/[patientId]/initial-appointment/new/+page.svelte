<script lang="ts">
  import * as Patient from '$lib/components/patient';
  import { queries } from '$lib/api/queries/index.js';
  import { createQuery } from '@tanstack/svelte-query';

  export let data;
  $: ({ pageParams } = data);
  $: userQuery = createQuery(queries.users.detail(pageParams.patientId));
</script>

<Patient.Pages.DetailInitialAppointment
  breadcrumbs={data.breadcrumbs}
  context="new"
  patientId={pageParams.patientId}
  userResponse={{
    data: $userQuery.data,
    isLoading: $userQuery.isLoading,
    isSuccess: $userQuery.isSuccess,
    isError: $userQuery.isError,
  }}
/>
