<script lang="ts">
  import { createQuery } from '@tanstack/svelte-query';
  import { queries } from '$lib/api/queries';
  import { currentUser } from '$lib/components/user/data';
  import * as Doctor from '$lib/components/doctor';

  export let data;
  $: ({ pageParams } = data);

  $: detailQuery = createQuery(queries.users.detail(pageParams.doctorId));
</script>

<Doctor.Pages.Detail
  breadcrumbs={data.breadcrumbs}
  response={{
    data: $detailQuery.data,
    isLoading: $detailQuery.isLoading,
    isSuccess: $detailQuery.isSuccess,
    isError: $detailQuery.isError,
  }}
  userContext={$currentUser.isAdmin ? 'admin' : 'patient'}
/>
