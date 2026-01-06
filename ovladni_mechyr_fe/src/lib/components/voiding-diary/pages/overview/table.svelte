<script lang="ts">
  import type { TableExtraOptions } from '$lib/components/table/Table.svelte';
  import type { ResponseData } from './types';
  import { writable } from 'svelte/store';
  import { createRender, createTable } from 'svelte-headless-table';
  import * as m from '$paraglide/messages';
  import Table from '$lib/components/table/Table.svelte';
  import TableTooltip from '$lib/components/table/TableTooltip.svelte';
  import TableBold from '$lib/components/table/TableBold.svelte';

  export let responseData: {
    label: string;
    tooltipText?: string;
    value: NonNullable<ResponseData['voiding_diary']>[keyof NonNullable<
      ResponseData['voiding_diary']
    >];
  }[];

  const columnIds = {
    label: 'label',
    value: 'value',
  } as const;

  const tableData = writable<typeof responseData>([]);
  $: if (responseData) {
    $tableData = responseData;
  }

  const table = createTable(tableData);

  const columns = table.createColumns([
    table.column({
      id: columnIds.label,
      accessor: ({ label, tooltipText }) => ({ label, tooltipText }),
      header: m.theName(),
      cell: ({ value: { label, tooltipText } }) => {
        if (!tooltipText) {
          return createRender(TableBold, { text: label, class: 'font-bold' });
        }

        return createRender(TableTooltip, { text: label, tooltipText, textClasses: 'font-bold' });
      },
    }),
    table.column({
      id: columnIds.value,
      accessor: (item) => item.value,
      header: m.value(),
      cell: ({ value }) => {
        if (typeof value === 'boolean') return [m.no(), m.yes()][Number(value)];
        if (Array.isArray(value)) return value.join(', ');
        return value ?? '-';
      },
    }),
  ]);

  const extraOptions: TableExtraOptions<keyof typeof columnIds> = {
    columns: {
      label: { width: '50%' },
      value: { width: '50%' },
    },
    showTableHeadRow: false,
  };
</script>

<Table {columns} {extraOptions} itemsCount={responseData.length} {table} />
