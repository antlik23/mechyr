<script lang="ts">
  import { type ComponentProps } from 'svelte';
  import type { QueryResponseProperties } from './types';
  import * as m from '$paraglide/messages';
  import Title from '$lib/components/common/Title.svelte';
  import * as Card from '$lib/components/ui/card';
  import Form from './form.svelte';
  import { LoadingIndicator } from '$lib/components/loading';

  export let response: QueryResponseProperties;
  export let invitationToken: ComponentProps<Form>['initialData']['invitationToken'];
</script>

<Card.Root class="uzis-border mx-auto max-w-[25rem]">
  <Card.Header>
    <Title includeMeta={true} text={m.acceptInvite()} />
  </Card.Header>
  <Card.Content>
    {#if response?.isLoading}
      <LoadingIndicator />
    {:else if response?.isSuccess}
      {#if response.data}
        <Form initialData={{ invitationToken, user: response.data.user }} />
      {/if}
    {/if}
  </Card.Content>
</Card.Root>
