<script lang="ts">
  import Button from '$lib/components/common/Button.svelte';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import Title from '$lib/components/common/Title.svelte';
  import { LoadingIndicator } from '$lib/components/loading';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import { updateTextNodes } from '$lib/utils';
  import * as m from '$paraglide/messages';
  import { PlusIcon } from 'lucide-svelte';
  import { onMount, type ComponentProps } from 'svelte';
  import TableFilters from './table-filters.svelte';
  import Table from './table.svelte';
  import type { QueryResponseProperties } from './types';

  export let response: QueryResponseProperties;
  export let filters: ComponentProps<TableFilters>['filters'];
  export let userContext: 'admin' | 'patient';

  const titleNames: Record<typeof userContext, () => string> = {
    admin: m.doctorsList,
    patient: m.doctorSelection,
  };

  onMount(() => {
    updateTextNodes();
  });
</script>

<div class={columnsVariants({ number: 0, gap: 5 })}>
  <Title containerClasses="justify-between" includeMeta={true} text={titleNames[userContext]()}>
    {#if userContext === 'admin'}
      <Button
        href={localizeRoute(route('/doctors/new'))}
        prependIcon={PlusIcon}
        prependIconProps={{ class: 'size-4 [&_svg]:size-[inherit]' }}
      >
        {m.newDoctor()}
      </Button>
    {/if}
  </Title>

  <p>Vyberte prosím lékaře ze seznamu a požádejte o vyšetření.</p>

  {#if response.isLoading}
    <LoadingIndicator />
  {:else if response.isSuccess}
    {#if response.data}
      <div class={columnsVariants({ number: 0, gap: 4 })}>
        <TableFilters {filters} on:filter />

        <Table responseData={response.data} on:pagination on:sort />
      </div>
    {/if}
  {/if}
</div>
