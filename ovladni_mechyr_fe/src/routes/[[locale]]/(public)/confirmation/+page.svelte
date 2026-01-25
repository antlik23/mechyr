<script lang="ts">
  import { page } from '$app/stores';
  import * as User from '$lib/components/user';

  const confirmationToken = $page.url.searchParams.get('confirmation_token');
</script>

<User.Pages.Confirmation {confirmationToken} />
