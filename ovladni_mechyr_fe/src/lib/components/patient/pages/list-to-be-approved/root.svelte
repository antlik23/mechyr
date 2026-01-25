<script lang="ts">
  import type { QueryResponseProperties } from './types';
  import * as m from '$paraglide/messages';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import Title from '$lib/components/common/Title.svelte';
  import { LoadingIndicator } from '$lib/components/loading';
  import Table from './table.svelte';

  export let response: QueryResponseProperties;
</script>

<div class={columnsVariants({ number: 0, gap: 5 })}>
  <Title includeMeta={true} text={m.requestOfSharing()} />

  {#if response.isLoading}
    <LoadingIndicator />
  {:else if response.isSuccess}
    {#if response.data}
      <Table responseData={response.data} on:pagination on:sort />
    {/if}
  {/if}
</div>
