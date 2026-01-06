<script lang="ts">
  import type { QueryResponseProperties } from './types';
  import * as m from '$paraglide/messages';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import Title from '$lib/components/common/Title.svelte';
  import { LoadingIndicator } from '$lib/components/loading';
  import * as Card from '$lib/components/ui/card';
  import DoctorForm from './doctor-form.svelte';

  export let response: QueryResponseProperties;
</script>

<div class={columnsVariants({ number: 0, gap: 5 })}>
  <Title includeMeta={true} text={m.myAccount()} />

  <Card.Root class="uzis-border max-w-prose">
    <Card.Content>
      {#if response?.isLoading}
        <LoadingIndicator />
      {:else if response?.isSuccess}
        {#if response.data}
          <DoctorForm context="edit" initialData={{ user: response.data.user }} />
        {/if}
      {/if}
    </Card.Content>
  </Card.Root>
</div>
