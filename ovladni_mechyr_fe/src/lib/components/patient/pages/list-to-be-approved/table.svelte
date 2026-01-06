<script lang="ts">
  import type { ComponentEvents, ComponentProps } from 'svelte';
  import type { IsAny } from 'type-fest';
  import type { TableExtraOptions } from '$lib/components/table/Table.svelte';
  import type { ResponseData } from './types';
  import { writable } from 'svelte/store';
  import { createRender, createTable } from 'svelte-headless-table';
  import { addPagination, addSortBy } from 'svelte-headless-table/plugins';
  import { assert, type Equals } from 'tsafe';
  import { toast } from 'svelte-sonner';
  import { createRejectPatientMutation } from '$lib/api/mutations/patient';
  import * as m from '$paraglide/messages';
  import Table from '$lib/components/table/Table.svelte';
  import TableActions from './table-actions.svelte';
  import Dialog from '$lib/components/dialogs/Dialog.svelte';
  import Form from './form.svelte';

  export let responseData: ResponseData;

  const rejectPatientMutation = createRejectPatientMutation();

  const columnIds = {
    patient_id: 'patient_id',
    email: 'email',
    actions: 'actions',
  } as const;

  const tableData = writable<(typeof responseData)['patients']>([]);
  $: if (responseData.patients) {
    $tableData = responseData.patients;
  }

  let isApprovePatientModalOpen = false;
  let selectedPatient: ComponentProps<Form>['initialData']['patient'];

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
      id: columnIds.patient_id,
      accessor: (item) => item.patient_public_id,
      header: m.patientId(),
    }),
    table.column({
      id: columnIds.email,
      accessor: (item) => item.email,
      header: m.email(),
    }),
    table.column({
      id: columnIds.actions,
      accessor: (item) => item,
      header: m.actions(),
      cell: ({ value }) => {
        return createRender(TableActions, {
          patient: value,
        })
          .on('accept', ({ detail: { patient } }) => {
            assert<Equals<IsAny<ComponentEvents<TableActions>['accept']['detail']>, false>>();

            selectedPatient = patient;
            isApprovePatientModalOpen = true;
          })
          .on('reject', ({ detail: { patient } }) => {
            assert<Equals<IsAny<ComponentEvents<TableActions>['reject']['detail']>, false>>();

            toast(m.reallyRejectThisPatient(), {
              action: {
                label: m.yes(),
                onClick: () => {
                  $rejectPatientMutation.mutate({ patientId: patient.patient_id });
                },
              },
            });
          });
      },
    }),
  ]);

  const extraOptions: TableExtraOptions<keyof typeof columnIds> = {
    columns: {
      patient_id: { width: '40%' },
      email: { width: '40%' },
      actions: { width: '20%', showHeaderText: false },
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

<Dialog open={isApprovePatientModalOpen} on:close={() => (isApprovePatientModalOpen = false)}>
  <svelte:fragment slot="header">
    {m.acceptPatientX({ patientName: selectedPatient.patient_public_id })}
  </svelte:fragment>

  <Form
    initialData={{ patient: selectedPatient }}
    on:success={() => (isApprovePatientModalOpen = false)}
  />
</Dialog>
