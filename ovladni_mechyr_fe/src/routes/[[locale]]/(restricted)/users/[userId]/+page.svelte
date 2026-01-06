<script lang="ts">
  import { createQuery } from '@tanstack/svelte-query';
  import { queries } from '$lib/api/queries/index.js';
  import * as User from '$lib/components/user';

  export let data;
  $: ({ pageParams } = data);

  $: detailQuery = createQuery(queries.users.detail(pageParams.userId));
</script>

<User.Pages.Detail
  response={{
    data: $detailQuery.data,
    isLoading: $detailQuery.isLoading,
    isSuccess: $detailQuery.isSuccess,
    isError: $detailQuery.isError,
  }}
/>
