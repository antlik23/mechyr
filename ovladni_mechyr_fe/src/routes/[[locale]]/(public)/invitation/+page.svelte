<script lang="ts">
  import { page } from '$app/stores';
  import { createQuery } from '@tanstack/svelte-query';
  import { queries } from '$lib/api/queries';
  import * as User from '$lib/components/user';

  const invitationToken = $page.url.searchParams.get('invitation_token');

  $: userQuery = createQuery({
    ...queries.users.findByToken(String(invitationToken)),
    enabled: Boolean(invitationToken),
  });
</script>

<User.Pages.InvitationAccept
  {invitationToken}
  response={{
    data: $userQuery.data,
    isLoading: $userQuery.isLoading,
    isSuccess: $userQuery.isSuccess,
    isError: $userQuery.isError,
  }}
/>
