<script lang="ts">
  import type { TableExtraOptions } from '$lib/components/table/Table.svelte';
  import type { QuestionnairesTableData } from './types';
  import { writable } from 'svelte/store';
  import { createRender, createTable } from 'svelte-headless-table';
  import { assert } from 'tsafe';
  import { languageTag } from '$paraglide/runtime';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import * as m from '$paraglide/messages';
  import Table from '$lib/components/table/Table.svelte';
  import TableActions from '$lib/components/table/TableActions.svelte';
  import TableTooltip from '$lib/components/table/TableTooltip.svelte';

  export let responseData: QuestionnairesTableData[];
  export let patientId: number | undefined = undefined;
  export let userContext: 'doctor' | 'patient' = 'patient';

  const columnIds = {
    type: 'type',
    completion_timestamp: 'completion_timestamp',
    total_score: 'total_score',
    actions: 'actions',
  } as const;

  const tableData = writable<typeof responseData>([]);
  $: if (responseData) {
    $tableData = responseData;
  }

  const table = createTable(tableData);

  const columns = table.createColumns([
    table.column({
      id: columnIds.type,
      accessor: (item) => item.type,
      header: m.questionnaireType(),
      cell: ({ value }) => {
        const typeNames: Record<typeof value, () => string> = {
          oab_form: m.oabV8Form,
          iciq_form: m.iciqForm,
          ipss_form: m.ipssForm,
          anamnestic_form: m.anamnesticForm,
        };

        return typeNames[value]();
      },
    }),
    table.column({
      id: columnIds.completion_timestamp,
      accessor: (item) => item.completion_timestamp,
      header: m.dateFilled(),
      cell: ({ value }) => {
        if (!value) return '-';

        return new Date(value).toLocaleString(languageTag(), {
          dateStyle: 'medium',
          timeStyle: 'short',
        });
      },
    }),
    table.column({
      id: columnIds.total_score,
      accessor: (item) => item.total_score,
      header: m.score(),
      cell: ({ value }) => {
        if (value !== null) return value;

        // TODO: move to paraglide messages
        return createRender(TableTooltip, {
          tooltipText: 'Anamnestický dotazník není bodově hodnocen.',
          text: '',
        });
      },
    }),
    table.column({
      id: columnIds.actions,
      accessor: ({ id, type }) => ({ id, type }),
      header: m.actions(),
      cell: ({ value: { id, type } }) => {
        let typeLinks = {} as Record<typeof type, string>;

        if (userContext === 'patient') {
          typeLinks = {
            oab_form: localizeRoute(route('/questionnaires')),
            iciq_form: localizeRoute(route('/questionnaires/iciq')),
            ipss_form: localizeRoute(route('/questionnaires/ipss')),
            anamnestic_form: localizeRoute(route('/anamnestic')),
          };
        } else {
          assert(patientId, 'Available patient ID');

          typeLinks = {
            oab_form: localizeRoute(
              route('/patients/approved/[patientId]/oab/[oabFormId]', { patientId, oabFormId: id })
            ),
            iciq_form: localizeRoute(
              route('/patients/approved/[patientId]/iciq/[iciqFormId]', {
                patientId,
                iciqFormId: id,
              })
            ),
            ipss_form: localizeRoute(
              route('/patients/approved/[patientId]/ipss/[ipssFormId]', {
                patientId,
                ipssFormId: id,
              })
            ),
            anamnestic_form: localizeRoute(
              route('/patients/approved/[patientId]/anamnestic/[anamnesticFormId]', {
                patientId,
                anamnesticFormId: id,
              })
            ),
          };
        }

        return createRender(TableActions, {
          id,
          showButton: true,
          buttonProps: { href: typeLinks[type] },
        });
      },
      plugins: { sort: { disable: true } },
    }),
  ]);

  const extraOptions: TableExtraOptions<keyof typeof columnIds> = {
    columns: {
      type: { width: '36%' },
      completion_timestamp: { width: '35%' },
      total_score: { width: '14%' },
      actions: { width: '15%', showHeaderText: false },
    },
  };
</script>

<Table {columns} {extraOptions} itemsCount={responseData.length} {table} />
