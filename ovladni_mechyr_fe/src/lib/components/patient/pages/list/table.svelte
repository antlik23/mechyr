<script lang="ts">
  import type { TableExtraOptions } from '$lib/components/table/Table.svelte';
  import Table from '$lib/components/table/Table.svelte';
  import TableActions from '$lib/components/table/TableActions.svelte';
  import TableHtml from '$lib/components/table/TableHtml.svelte';
  import { Badge } from '$lib/components/ui/badge';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import * as m from '$paraglide/messages';
  import { languageTag } from '$paraglide/runtime';
  import { createRender, createTable } from 'svelte-headless-table';
  import { addPagination, addSortBy } from 'svelte-headless-table/plugins';
  import { writable } from 'svelte/store';
  import type { ResponseData } from './types';
  import { currentUser } from '$lib/components/user/data';

  export let responseData: ResponseData;

  const columnIds = {
    patient_id: 'patient_id',
    email: 'email',
    next_appointment: 'next_appointment',
    appointment_initial: 'appointment_initial',
    appointment_first: 'appointment_first',
    appointment_second: 'appointment_second',
    actions: 'actions',
  } as const;

  const tableData = writable<(typeof responseData)['patients']>([]);
  $: if (responseData.patients) {
    $tableData = responseData.patients;
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
      id: columnIds.next_appointment,
      accessor: (item) => item.next_appointment,
      header: m.firstPersonalVisitDate(),
      cell: ({ value }) => {
        if (!value) return '-';

        return new Date(value).toLocaleString(languageTag(), {
          dateStyle: 'medium',
          timeStyle: 'short',
        });
      },
    }),
    table.column({
      id: columnIds.appointment_initial,
      accessor: ({ appointment_initial, appointment_initial_id, id }) => ({
        appointment_initial,
        appointment_initial_id,
        id,
      }),
      header: m.remotePatientDiagnostics(),
      cell: ({ value: { appointment_initial, appointment_initial_id, id } }) => {
        return createRender(Badge, {
          variant: appointment_initial ? 'positive' : 'negative',
          class: 'h-5 w-14',
          href:
            appointment_initial_id && $currentUser.role === 'admin'
              ? localizeRoute(
                  route(
                    '/patients/approved/[patientId]/initial-appointment/[initialAppointmentId]',
                    {
                      patientId: id,
                      initialAppointmentId: appointment_initial_id,
                    }
                  )
                )
              : undefined,
        });
      },
    }),
    table.column({
      id: columnIds.appointment_first,
      accessor: ({ appointment_first, appointment_first_id, id }) => ({
        appointment_first,
        appointment_first_id,
        id,
      }),
      header: createRender(TableHtml, {
        text: 'Diagnostika pacienta při&nbsp;první&nbsp;osobní návštěvě',
      }),
      cell: ({ value: { appointment_first, appointment_first_id, id } }) => {
        return createRender(Badge, {
          variant: appointment_first ? 'positive' : 'negative',
          class: 'h-5 w-14',
          href: appointment_first_id
            ? localizeRoute(
                route('/patients/approved/[patientId]/first-appointment/[firstAppointmentId]', {
                  patientId: id,
                  firstAppointmentId: appointment_first_id,
                })
              )
            : undefined,
        });
      },
    }),
    table.column({
      id: columnIds.appointment_second,
      accessor: ({ appointment_second, appointment_second_id, id }) => ({
        appointment_second,
        appointment_second_id,
        id,
      }),
      header: createRender(TableHtml, { text: 'Kontrolní návštěva po&nbsp;3&nbsp;měsících' }),
      cell: ({ value: { appointment_second, appointment_second_id, id } }) => {
        return createRender(Badge, {
          variant: appointment_second ? 'positive' : 'negative',
          class: 'h-5 w-14',
          href: appointment_second_id
            ? localizeRoute(
                route('/patients/approved/[patientId]/second-appointment/[secondAppointmentId]', {
                  patientId: id,
                  secondAppointmentId: appointment_second_id,
                })
              )
            : undefined,
        });
      },
    }),
    table.column({
      id: columnIds.actions,
      accessor: (item) => item.id,
      header: m.actions(),
      cell: ({ value }) => {
        return createRender(TableActions, {
          id: value,
          showButton: true,
          buttonProps: {
            href: localizeRoute(route('/patients/approved/[patientId]', { patientId: value })),
          },
        });
      },
    }),
  ]);

  const extraOptions: TableExtraOptions<keyof typeof columnIds> = {
    columns: {
      patient_id: { width: '9%' },
      email: { width: '20%' },
      next_appointment: { width: '13%' },
      appointment_initial: { width: '17%', textAlign: 'center' },
      appointment_first: { width: '17%', textAlign: 'center' },
      appointment_second: { width: '17%', textAlign: 'center' },
      actions: { width: '7%', showHeaderText: false },
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
