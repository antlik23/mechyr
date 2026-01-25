<script context="module" lang="ts">
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  import { type StoresValues } from 'svelte/store';
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  import type { Table as TableType, Column } from 'svelte-headless-table';
  import { type AnyPlugins } from 'svelte-headless-table/plugins';

  // Used in generics attribute.
  type TTable = unknown;
  type TColumns = unknown;

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  export type TablePlugins<TAnyPlugins extends AnyPlugins = any> = {
    sort: ReturnType<typeof addSortBy>;
    pagination: ReturnType<typeof addPagination>;
  } & TAnyPlugins;

  export type TableExtraOptions<TColumnIds extends string = string> =
    | {
        columns: Record<
          TColumnIds,
          {
            width: string;
            textAlign?: 'left' | 'center' | 'right';
            headerTextAlign?: 'left' | 'center' | 'right';
            showHeaderText?: boolean;
          }
        >;
        pagination?: { auto: boolean };
        showTableHeadRow?: boolean;
      }
    | undefined;
</script>

<script
  generics="TTable extends TableType<StoresValues<TTable>['data'][number], TablePlugins>, TColumns extends Column<StoresValues<TTable>['data'][number], TablePlugins>[]"
  lang="ts"
>
  import { createEventDispatcher, type ComponentProps } from 'svelte';

  import { Render, Subscribe } from 'svelte-headless-table';
  import { addSortBy, addPagination, type SortKey } from 'svelte-headless-table/plugins';
  import { cn } from '$lib/utils';
  import * as m from '$paraglide/messages';

  import * as Table from '$lib/components/ui/table';
  import Pagination from '$lib/components/ui-wrappers/Pagination.svelte';
  import Card from '$lib/components/wrappers/Card.svelte';
  import Title from '$lib/components/common/Title.svelte';
  import Button from '$lib/components/common/Button.svelte';
  import Icon from '$lib/components/wrappers/Icon.svelte';
  import { MoveUpIcon } from 'lucide-svelte';

  export let table: TTable;
  export let columns: TColumns;
  export let itemsCount: number;
  export let extraOptions: TableExtraOptions = undefined;
  export let paginationClasses: ComponentProps<Pagination>['class'] = undefined;
  export let infoTextFunction:
    | ((params: { items: NonNullable<unknown>; count: NonNullable<unknown> }) => string)
    | undefined = undefined;
  export let onRowClick: ((row: (typeof $pageRows)[number]) => void) | undefined = undefined;

  const dispatch = createEventDispatcher<{
    pagination: {
      page: number;
    };
    sort: {
      sortKeys: SortKey[];
    };
  }>();

  $: ({ headerRows, pageRows, tableAttrs, tableBodyAttrs, pluginStates } =
    table.createViewModel(columns));

  $: ({ sortKeys } = pluginStates.sort ?? {});
  $: ({ pageIndex, pageSize, pageCount } = pluginStates?.pagination ?? {});

  // Detect data count changes due to filtering.
  let previousItemsCount = itemsCount;
  $: {
    if ($pageIndex && itemsCount !== previousItemsCount) {
      $pageIndex = 0;
      previousItemsCount = itemsCount;
    }
  }

  $: handleSort($sortKeys);

  function handlePageChange(page: number) {
    $pageIndex = page - 1;

    dispatch('pagination', { page });
  }

  function handleSort(sortKeys: SortKey[]) {
    dispatch('sort', {
      sortKeys,
    });
  }
</script>

<div>
  {#if $$slots['filters']}
    <Card class="mb-6">
      <h2 class="text-xl font-medium">{m.filters()}</h2>

      <div class="grid grid-flow-col items-center gap-4">
        <slot name="filters" />
      </div>
    </Card>
  {/if}

  {#if infoTextFunction}
    <Title
      class="font-normal text-gray-500"
      containerClasses="mb-4 justify-between"
      level="h5"
      text={infoTextFunction({
        items: $pageIndex * $pageSize + $pageRows.length,
        count: itemsCount,
      })}
    />
  {/if}

  <Table.Root {...$tableAttrs}>
    {@const showTableHeadRow = extraOptions?.showTableHeadRow !== false}

    <Table.Header class={cn(!showTableHeadRow && '[&_tr]:border-0')}>
      {#each $headerRows as headerRow}
        <Subscribe rowAttrs={headerRow.attrs()}>
          <Table.Row class="hover:bg-transparent">
            {#each headerRow.cells as cell (cell.id)}
              {@const width = extraOptions?.columns[cell.id]?.width}
              {@const textAlign = extraOptions?.columns[cell.id]?.headerTextAlign}
              {@const showHeaderText = extraOptions?.columns[cell.id]?.showHeaderText !== false}

              <Subscribe attrs={cell.attrs()} props={cell.props()} let:attrs let:props>
                {@const showSort =
                  !props.sort?.disabled && props.sort?.toggle !== undefined && $pageRows.length > 1}

                <Table.Head
                  style={`${width ? `width: ${width};` : ''} ${textAlign ? `text-align: ${textAlign};` : ''}`}
                  class={cn(
                    'h-auto align-bottom text-foreground',
                    showSort && showTableHeadRow && showHeaderText && 'px-0',
                    (!showSort || !showTableHeadRow || !showHeaderText) && 'px-4 py-3.5',
                    (!showTableHeadRow || !showHeaderText) &&
                      'p-0 *:sr-only *:h-[1px] *:w-[1px] *:p-0'
                  )}
                  {...attrs}
                >
                  {#if showSort}
                    <Button
                      class={cn(
                        'group h-auto w-full justify-start whitespace-normal rounded-none px-4 py-3.5 font-medium text-inherit [text-align:inherit] hover:bg-muted/50'
                      )}
                      variant="none"
                      on:click={props.sort?.toggle}
                    >
                      <Render of={cell.render()} />

                      <Icon
                        class={cn(
                          'size-4 transition-all [&_svg]:size-[inherit]',
                          props.sort?.order === 'desc' && 'rotate-180',
                          !props.sort?.order && 'opacity-0 group-hover:opacity-40'
                        )}
                        icon={MoveUpIcon}
                      />
                    </Button>
                  {:else if !showTableHeadRow || !showHeaderText}
                    <span>
                      <Render of={cell.render()} />
                    </span>
                  {:else}
                    <Render of={cell.render()} />
                  {/if}
                </Table.Head>
              </Subscribe>
            {/each}
          </Table.Row>
        </Subscribe>
      {/each}
    </Table.Header>

    <Table.Body {...$tableBodyAttrs} class="[&_tr:last-child]:border-b">
      {#each $pageRows as row (row.id)}
        <Subscribe rowAttrs={row.attrs()} let:rowAttrs>
          <Table.Row
            class={cn(onRowClick !== undefined && 'cursor-pointer')}
            on:click={() => onRowClick?.(row)}
            {...rowAttrs}
          >
            {#each row.cells as cell (cell.id)}
              {@const textAlign = extraOptions?.columns[cell.id]?.textAlign}

              <Subscribe attrs={cell.attrs()} let:attrs>
                <Table.Cell
                  style={`${textAlign ? `text-align: ${textAlign};` : ''}`}
                  class="px-4 py-3.5"
                  {...attrs}
                >
                  <Render of={cell.render()} />
                </Table.Cell>
              </Subscribe>
            {/each}
          </Table.Row>
        </Subscribe>
      {/each}
    </Table.Body>
  </Table.Root>

  {#if $$slots['paginationRow'] || pluginStates.pagination}
    <div class="mt-4 flex flex-wrap items-center gap-4">
      {#if pluginStates.pagination && itemsCount > 0}
        <Pagination
          class={cn('items-start', paginationClasses)}
          count={extraOptions?.pagination?.auto ? $pageCount * $pageSize : itemsCount}
          onPageChange={handlePageChange}
          page={$pageIndex + 1}
          perPage={$pageSize}
        />
      {/if}

      <slot name="paginationRow" />
    </div>
  {/if}
</div>
