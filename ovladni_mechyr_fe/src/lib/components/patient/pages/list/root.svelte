<script lang="ts">
  import type { ComponentProps } from 'svelte';
  import type { QueryResponseProperties, UserDetailQueryResponseProperties } from './types';
  import * as m from '$paraglide/messages';
  import Columns, { columnsVariants } from '$lib/components/common/Columns.svelte';
  import Title from '$lib/components/common/Title.svelte';
  import { LoadingIndicator } from '$lib/components/loading';
  import Table from './table.svelte';
  import TableFilters from './table-filters.svelte';
  import FullCapacity from './full-capacity.svelte';

  export let response: QueryResponseProperties;
  export let userResponse: UserDetailQueryResponseProperties | undefined = undefined;
  export let filters: ComponentProps<TableFilters>['filters'];
</script>

<div class={columnsVariants({ number: 0, gap: 5 })}>
  <Title includeMeta={true} text={m.patientsList()} />

  {#if response.isLoading || (userResponse?.isLoading ?? false)}
    <LoadingIndicator />
  {:else if response.isSuccess && (userResponse?.isSuccess ?? true)}
    {#if response.data && (userResponse?.data ?? true)}
      <div class={columnsVariants({ number: 0, gap: 4 })}>
        <Columns number={2}>
          <TableFilters columnsProps={{ number: 2 }} {filters} on:filter />

          {#if userResponse?.data}
            <Columns number={2}>
              <FullCapacity
                class="col-start-2"
                selectedValue={userResponse.data.user.full_capacity ?? false}
              />
            </Columns>
          {/if}
        </Columns>

        <Table responseData={response.data} on:pagination on:sort />
      </div>
    {/if}
  {/if}
</div>
