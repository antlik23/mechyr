<script lang="ts">
  import { goto } from '$app/navigation';
  import { apiClient } from '$lib/api/api';
  import { queryClient } from '$lib/api/queries';
  import Button from '$lib/components/common/Button.svelte';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import Title from '$lib/components/common/Title.svelte';
  import ConfirmEndDiaryDialog from '$lib/components/dialogs/ConfirmEndDiaryDialog.svelte';
  import { LoadingIndicator } from '$lib/components/loading';
  import Breadcrumbs from '$lib/components/ui-wrappers/Breadcrumbs.svelte';
  import * as Tooltip from '$lib/components/ui/tooltip';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import { cn } from '$lib/utils';
  import { handleRequest } from '$lib/utils/request';
  import * as m from '$paraglide/messages';
  import { Check, PencilIcon } from 'lucide-svelte';
  import type { ComponentProps } from 'svelte';
  import { writable } from 'svelte/store';
  import Table from './table.svelte';
  import type { QueryResponseProperties, VoidingDiaryQueryResponseProperties } from './types';

  export let response: QueryResponseProperties;
  export let voidingDiaryResponse: VoidingDiaryQueryResponseProperties;
  export let diaryId: ComponentProps<Table>['diaryId'];
  export let patientId: ComponentProps<Table>['patientId'] = undefined;
  export let userContext: ComponentProps<Table>['userContext'] = 'patient';
  export let breadcrumbs: ComponentProps<Breadcrumbs>['breadcrumbs'];
  export let isAdmin = userContext === 'admin';

  let showDialog = false;

  function openDialog() {
    showDialog = true;
  }

  function handleCancel() {
    showDialog = false;
  }

  async function handleConfirm() {
    const toastSuccessText = writable('');

    await handleRequest(
      async () => {
        await apiClient.PUT('/api/v1/voiding_diaries/{id}', {
          params: { path: { id: diaryId } },
          body: {
            voiding_diary: {
              completed: true,
            },
          },
        });
        queryClient.invalidateQueries();
        toastSuccessText.set(m.successfulVoidingDiaryEdit());
      },
      {
        toastSuccessText,
      }
    );
    showDialog = false;
    toastSuccessText.set(m.successfulVoidingDiaryEdit());
  }
</script>

<Breadcrumbs {breadcrumbs} />

<div class={columnsVariants({ number: 0, gap: 5 })}>
  <Title containerClasses="justify-between" includeMeta={true} text={m.voidingDiaryEntries()}>
    {@const editLink =
      userContext !== 'patient' && patientId
        ? localizeRoute(
            route('/patients/approved/[patientId]/voiding-diary/[diaryId]/edit', {
              patientId,
              diaryId,
            })
          )
        : localizeRoute(route('/voiding-diary/list/[diaryId]/edit', { diaryId }))}

    <div class="flex flex-wrap gap-4">
      {#if voidingDiaryResponse.isLoading}
        <LoadingIndicator />
      {:else if voidingDiaryResponse.isSuccess && voidingDiaryResponse.data}
        {@const isCompleted = voidingDiaryResponse.data.voiding_diary.completed}
        {@const durationDays = voidingDiaryResponse.data.voiding_diary.diary_duration_days}
        {@const wakeupTimeDayOne = voidingDiaryResponse.data.voiding_diary.wake_up_time_day_one}
        {@const bedTimeDayOne = voidingDiaryResponse.data.voiding_diary.bedtime_day_one}
        {@const wakeupTimeDayTwo = voidingDiaryResponse.data.voiding_diary.wake_up_time_day_two}
        {@const bedTimeDayTwo = voidingDiaryResponse.data.voiding_diary.bedtime_day_two}
        {@const canCompleteDiary =
          !isCompleted &&
          ((durationDays === 1 && wakeupTimeDayOne && bedTimeDayOne) ||
            (durationDays === 2 &&
              wakeupTimeDayOne &&
              bedTimeDayOne &&
              wakeupTimeDayTwo &&
              bedTimeDayTwo))}

        {@const tooltipMessage = isCompleted
          ? 'Mikční deník je již ukončen'
          : durationDays === 1
            ? !wakeupTimeDayOne || !bedTimeDayOne
              ? 'Pro dokončení deníku je třeba vyplnit časy vstávání a usínání'
              : ''
            : durationDays === 2
              ? !wakeupTimeDayOne || !bedTimeDayOne || !wakeupTimeDayTwo || !bedTimeDayTwo
                ? 'Pro dokončení deníku je třeba vyplnit časy vstávání a usínání'
                : ''
              : ''}

        <Tooltip.Root openDelay={100}>
          <Tooltip.Trigger asChild let:builder>
            <Button
              builders={[builder]}
              disabled={!canCompleteDiary}
              prependIcon={Check}
              prependIconProps={{ class: 'size-4 [&_svg]:size-[inherit]' }}
              on:click={openDialog}
            >
              Ukončit mikční deník
            </Button>
          </Tooltip.Trigger>
          {#if tooltipMessage}
            <Tooltip.Content>
              <p>{tooltipMessage}</p>
            </Tooltip.Content>
          {/if}
        </Tooltip.Root>

        <Tooltip.Root openDelay={100}>
          <Tooltip.Trigger asChild let:builder>
            <Button
              builders={[builder]}
              disabled={isCompleted && !isAdmin}
              prependIcon={PencilIcon}
              prependIconProps={{ class: 'size-4 [&_svg]:size-[inherit]' }}
              on:click={() => goto(editLink)}
            >
              {m.editVoidingDiary()}
            </Button>
          </Tooltip.Trigger>
          <Tooltip.Content class={cn((!isCompleted || isAdmin) && 'hidden')}>
            <p>Mikční deník je již ukončen</p>
          </Tooltip.Content>
        </Tooltip.Root>
      {/if}
    </div>
  </Title>

  {#if response.isLoading || voidingDiaryResponse.isLoading}
    <LoadingIndicator />
  {:else if response.isSuccess && voidingDiaryResponse.isSuccess}
    {#if response.data && voidingDiaryResponse.data}
      <Table
        {diaryId}
        {patientId}
        responseData={response.data}
        {userContext}
        voidingDiaryData={voidingDiaryResponse.data}
        on:pagination
      />
    {/if}
  {/if}
</div>

<ConfirmEndDiaryDialog onCancel={handleCancel} onConfirm={handleConfirm} open={showDialog} />
