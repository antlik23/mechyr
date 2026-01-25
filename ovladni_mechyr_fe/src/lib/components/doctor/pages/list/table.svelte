<script lang="ts">
  import type { TableExtraOptions } from '$lib/components/table/Table.svelte';
  import Table from '$lib/components/table/Table.svelte';
  import TableActions from '$lib/components/table/TableActions.svelte';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import * as m from '$paraglide/messages';
  import { createRender, createTable } from 'svelte-headless-table';
  import { addPagination, addSortBy } from 'svelte-headless-table/plugins';
  import { writable } from 'svelte/store';
  import type { ResponseData } from './types';

  export let responseData: ResponseData;

  const columnIds = {
    full_name: 'full_name',
    city: 'city',
    street_and_number: 'street_and_number',
    actions: 'actions',
  } as const;

  const tableData = writable<(typeof responseData)['doctors']>([]);
  $: if (responseData.doctors) {
    $tableData = responseData.doctors;
  }

  const table = createTable(tableData, {
    sort: addSortBy({
      toggleOrder: ['asc', 'desc'],
      serverSide: true,
    }),
    pagination: addPagination({
      initialPageSize: responseData.pagination.items,
      initialPageIndex: responseData.pagination.page - 1,
      serverSide: true,
      serverItemCount: writable(responseData.pagination.count),
    }),
  });

  const columns = table.createColumns([
    table.column({
      id: columnIds.full_name,
      accessor: (item) => item.full_name || '-',
      header: m.doctorsName(),
    }),
    table.column({
      id: columnIds.city,
      accessor: (item) => item.city || '-',
      header: m.city(),
    }),
    table.column({
      id: columnIds.street_and_number,
      accessor: (item) => item.street_and_number || '-',
      header: m.address(),
    }),
    table.column({
      id: columnIds.actions,
      accessor: (item) => item.id,
      header: m.actions(),
      cell: ({ value }) => {
        return createRender(TableActions, {
          id: value,
          showButton: true,
          buttonProps: { href: localizeRoute(route('/doctors/[doctorId]', { doctorId: value })) },
        });
      },
      plugins: { sort: { disable: true } },
    }),
  ]);

  const extraOptions: TableExtraOptions<keyof typeof columnIds> = {
    columns: {
      full_name: { width: '30%' },
      city: { width: '30%' },
      street_and_number: { width: '30%' },
      actions: { width: '10%', showHeaderText: false },
    },
  };
</script>

<Table
  {columns}
  {extraOptions}
  itemsCount={responseData.pagination.count}
  {table}
  on:pagination
  on:sort
/>
