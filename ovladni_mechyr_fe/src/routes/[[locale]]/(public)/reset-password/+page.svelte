<script lang="ts">
  import { page } from '$app/stores';
  import * as m from '$paraglide/messages';
  import Title from '$lib/components/common/Title.svelte';
  import * as Card from '$lib/components/ui/card';
  import * as Form from '$lib/components/form/index';

  $: token = $page.url.searchParams.get('reset_password_token');
</script>

<Card.Root class="uzis-border mx-auto max-w-[25rem]">
  <Card.Header>
    <Title includeMeta={true} text={m.resetPassword()} />
  </Card.Header>
  <Card.Content>
    <Form.ResetPassword initialData={{ token }} />
  </Card.Content>
</Card.Root>
