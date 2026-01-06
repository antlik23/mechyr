<script lang="ts">
  import { goto } from '$app/navigation';
  import { createDeleteVoidingDiaryRecordMutation } from '$lib/api/mutations/voidingDiaryRecord';
  import Button from '$lib/components/common/Button.svelte';
  import type { TableExtraOptions } from '$lib/components/table/Table.svelte';
  import Table from '$lib/components/table/Table.svelte';
  import TableActionsDropdown from '$lib/components/table/TableActionsDropdown.svelte';
  import * as Tooltip from '$lib/components/ui/tooltip';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import { cn } from '$lib/utils';
  import * as m from '$paraglide/messages';
  import { languageTag } from '$paraglide/runtime';
  import { PlusIcon } from 'lucide-svelte';
  import { createRender, createTable } from 'svelte-headless-table';
  import { addPagination } from 'svelte-headless-table/plugins';
  import { toast } from 'svelte-sonner';
  import { writable } from 'svelte/store';
  import { assert } from 'tsafe';
  import type { ResponseData, VoidingDiaryResponseData } from './types';

  export let responseData: ResponseData;
  export let voidingDiaryData: VoidingDiaryResponseData;
  export let diaryId: number;
  export let patientId: number | undefined = undefined;
  export let userContext: 'doctor' | 'patient' | 'admin';
  export let isAdmin = userContext === 'admin';

  const deleteVoidingDiaryRecordMutation = createDeleteVoidingDiaryRecordMutation();

  const columnIds = {
    recorded_at: 'recorded_at',
    record_type: 'record_type',
    actions: 'actions',
  } as const;

  const tableData = writable<typeof responseData.voiding_records>([]);
  $: if (responseData.voiding_records) {
    $tableData = responseData.voiding_records;
  }

  const table = createTable(tableData, {
    pagination: addPagination({
      initialPageSize: responseData.pagination.items,
      initialPageIndex: responseData.pagination.page - 1,
      serverSide: true,
      serverItemCount: writable(responseData.pagination.count),
    }),
  });

  const columns = table.createColumns([
    table.column({
      id: columnIds.recorded_at,
      accessor: (item) => item.recorded_at,
      header: m.dateAndTime(),
      cell: ({ value }) =>
        new Date(value).toLocaleString(languageTag(), { dateStyle: 'medium', timeStyle: 'short' }),
    }),
    table.column({
      id: columnIds.record_type,
      accessor: (item) => item.record_type,
      header: m.type(),
      cell: ({ value }) => {
        const typeNames: Record<typeof value, () => string> = {
          input: m.income,
          output: m.urination,
        };

        return typeNames[value]();
      },
    }),
    table.column({
      id: columnIds.actions,
      accessor: ({ id, record_type }) => ({ id, record_type }),
      header: m.actions(),
      cell: ({ value: { id, record_type } }) => {
        let typeLinks: Record<typeof record_type, string>;
        let detailLinks: Record<typeof record_type, string>;

        if (userContext === 'patient') {
          detailLinks = {
            output: localizeRoute(
              route('/voiding-diary/list/[diaryId]/records/output/[recordId]', {
                diaryId,
                recordId: id,
              })
            ),
            input: localizeRoute(
              route('/voiding-diary/list/[diaryId]/records/input/[recordId]', {
                diaryId,
                recordId: id,
              })
            ),
          };
          typeLinks = {
            output: localizeRoute(
              route('/voiding-diary/list/[diaryId]/records/output/[recordId]/edit', {
                diaryId,
                recordId: id,
              })
            ),
            input: localizeRoute(
              route('/voiding-diary/list/[diaryId]/records/input/[recordId]/edit', {
                diaryId,
                recordId: id,
              })
            ),
          };
        } else {
          assert(patientId, 'Available patient ID');
          detailLinks = {
            output: localizeRoute(
              route(
                '/patients/approved/[patientId]/voiding-diary/[diaryId]/records/output/[recordId]',
                { patientId, diaryId, recordId: id }
              )
            ),
            input: localizeRoute(
              route(
                '/patients/approved/[patientId]/voiding-diary/[diaryId]/records/input/[recordId]',
                { patientId, diaryId, recordId: id }
              )
            ),
          };

          typeLinks = {
            output: localizeRoute(
              route(
                '/patients/approved/[patientId]/voiding-diary/[diaryId]/records/output/[recordId]/edit',
                { patientId, diaryId, recordId: id }
              )
            ),
            input: localizeRoute(
              route(
                '/patients/approved/[patientId]/voiding-diary/[diaryId]/records/input/[recordId]/edit',
                { patientId, diaryId, recordId: id }
              )
            ),
          };
        }

        return createRender(TableActionsDropdown, {
          id,
          userContext,
          showDetail: true,
          isCompleted: voidingDiaryData.voiding_diary.completed,
          editButtonProps: {
            href: typeLinks[record_type],
          },
          detailButtonProps: {
            href: detailLinks[record_type],
          },
        }).on('remove', ({ detail: { id } }) => {
          toast(m.reallyDeleteThisEntry(), {
            action: {
              label: m.yes(),
              onClick: () => {
                $deleteVoidingDiaryRecordMutation.mutate({ diaryId, recordId: id });
              },
            },
          });
        });
      },
    }),
  ]);

  const extraOptions: TableExtraOptions<keyof typeof columnIds> = {
    columns: {
      recorded_at: { width: '40%' },
      record_type: { width: '40%' },
      actions: { width: '20%', showHeaderText: false },
    },
  };
</script>

<Table {columns} {extraOptions} itemsCount={responseData.pagination.count} {table} on:pagination>
  <svelte:fragment slot="paginationRow">
    {@const newOutputLink =
      userContext !== 'patient' && patientId
        ? localizeRoute(
            route('/patients/approved/[patientId]/voiding-diary/[diaryId]/records/output/new', {
              patientId,
              diaryId,
            })
          )
        : localizeRoute(route('/voiding-diary/list/[diaryId]/records/output/new', { diaryId }))}
    {@const newInputLink =
      userContext !== 'patient' && patientId
        ? localizeRoute(
            route('/patients/approved/[patientId]/voiding-diary/[diaryId]/records/input/new', {
              patientId,
              diaryId,
            })
          )
        : localizeRoute(route('/voiding-diary/list/[diaryId]/records/input/new', { diaryId }))}
    {@const isCompleted = voidingDiaryData.voiding_diary.completed}

    <div class="flex flex-wrap gap-4">
      <Tooltip.Root openDelay={100}>
        <Tooltip.Trigger asChild let:builder>
          <Button
            builders={[builder]}
            disabled={isCompleted && !isAdmin}
            prependIcon={PlusIcon}
            prependIconProps={{ class: 'size-4 [&_svg]:size-[inherit]' }}
            on:click={() => goto(newOutputLink)}
          >
            {m.addUrination()}
          </Button>
        </Tooltip.Trigger>
        <Tooltip.Content class={cn((!isCompleted || isAdmin) && 'hidden')}>
          <p>Mikční deník je již ukončen</p>
        </Tooltip.Content>
      </Tooltip.Root>

      <Tooltip.Root openDelay={100}>
        <Tooltip.Trigger asChild let:builder>
          <Button
            builders={[builder]}
            disabled={isCompleted && !isAdmin}
            prependIcon={PlusIcon}
            prependIconProps={{ class: 'size-4 [&_svg]:size-[inherit]' }}
            on:click={() => goto(newInputLink)}
          >
            {m.addIncome()}
          </Button>
        </Tooltip.Trigger>
        <Tooltip.Content class={cn((!isCompleted || isAdmin) && 'hidden')}>
          <p>Mikční deník je již ukončen</p>
        </Tooltip.Content>
      </Tooltip.Root>
    </div>
  </svelte:fragment>
</Table>
