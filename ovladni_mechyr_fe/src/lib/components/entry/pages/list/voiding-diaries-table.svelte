<script lang="ts">
  import type { TableExtraOptions } from '$lib/components/table/Table.svelte';
  import type { VoidingDiariesResponseData } from './types';
  import { writable } from 'svelte/store';
  import { createRender, createTable } from 'svelte-headless-table';
  import { addPagination } from 'svelte-headless-table/plugins';
  import { assert } from 'tsafe';
  import { languageTag } from '$paraglide/runtime';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import * as m from '$paraglide/messages';
  import Table from '$lib/components/table/Table.svelte';
  import TableActions from '$lib/components/table/TableActions.svelte';

  export let responseData: Pick<
    VoidingDiariesResponseData['voiding_diaries'][number],
    'id' | 'diary_start_date'
  >[];
  export let patientId: number | undefined = undefined;
  export let userContext: 'doctor' | 'patient' = 'patient';

  const columnIds = {
    diary_start_date: 'diary_start_date',
    actions: 'actions',
  } as const;

  const tableData = writable<typeof responseData>([]);
  $: if (responseData) {
    $tableData = responseData;
  }

  const table = createTable(tableData, {
    pagination: addPagination(),
  });

  const columns = table.createColumns([
    table.column({
      id: columnIds.diary_start_date,
      accessor: (item) => item.diary_start_date,
      header: m.startDate(),
      cell: ({ value }) => new Date(value).toLocaleDateString(languageTag()),
    }),
    table.column({
      id: columnIds.actions,
      accessor: (item) => item.id,
      header: m.actions(),
      cell: ({ value }) => {
        let buttonLink: string;

        if (userContext === 'patient') {
          buttonLink = localizeRoute(
            route('/voiding-diary/list/[diaryId]/records', {
              diaryId: value,
            })
          );
        } else {
          assert(patientId, 'Available patient ID');

          buttonLink = localizeRoute(
            route('/patients/approved/[patientId]/voiding-diary/[diaryId]/records', {
              patientId,
              diaryId: value,
            })
          );
        }

        return createRender(TableActions, {
          id: value,
          showButton: true,
          buttonProps: {
            href: buttonLink,
          },
        });
      },
    }),
  ]);

  const extraOptions: TableExtraOptions<keyof typeof columnIds> = {
    columns: {
      diary_start_date: { width: '80%' },
      actions: { width: '20%', showHeaderText: false },
    },
  };
</script>

<Table {columns} {extraOptions} itemsCount={responseData.length} {table} on:pagination>
  <svelte:fragment slot="paginationRow">
    <slot name="paginationRow" />
  </svelte:fragment>
</Table>
