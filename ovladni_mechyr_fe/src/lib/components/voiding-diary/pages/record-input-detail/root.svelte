<script lang="ts">
  import { goto } from '$app/navigation';
  import DoctorImg from '$lib/assets/images/doktorka.png?url';
  import Button from '$lib/components/common/Button.svelte';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import Title from '$lib/components/common/Title.svelte';
  import { LoadingIndicator } from '$lib/components/loading';
  import Breadcrumbs from '$lib/components/ui-wrappers/Breadcrumbs.svelte';
  import * as Card from '$lib/components/ui/card';
  import * as Tooltip from '$lib/components/ui/tooltip';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import { cn } from '$lib/utils';
  import * as m from '$paraglide/messages';
  import { PencilIcon } from 'lucide-svelte';
  import type { ComponentProps } from 'svelte';
  import Form from './form.svelte';
  import type { QueryResponseProperties, VoidingDiaryQueryResponseProperties } from './types';

  export let response: QueryResponseProperties | undefined = undefined;
  export let voidingDiaryResponse: VoidingDiaryQueryResponseProperties;
  export let diaryId: ComponentProps<Form>['initialData']['diaryId'];
  export let patientId: ComponentProps<Form>['initialData']['patientId'] = undefined;
  export let breadcrumbs: ComponentProps<Breadcrumbs>['breadcrumbs'];
  export let context: NonNullable<ComponentProps<Form>['context']>;
  export let userContext: ComponentProps<Form>['userContext'] = 'patient';
  export let isAdmin = userContext === 'admin';

  const titleNames: Record<typeof context, () => string> = {
    new: m.addIncome,
    read: m.income,
    edit: m.editIncome,
  };
</script>

<Breadcrumbs {breadcrumbs} />

<div class={columnsVariants({ number: 0, gap: 5 })}>
  <Title containerClasses="justify-between" includeMeta={true} text={titleNames[context]()}>
    {@const recordId = response?.data?.voiding_record.id}
    {@const isCompleted = voidingDiaryResponse.data?.voiding_diary.completed}

    {#if context === 'read' && recordId}
      {@const editLink =
        userContext !== 'patient' && patientId
          ? localizeRoute(
              route(
                '/patients/approved/[patientId]/voiding-diary/[diaryId]/records/input/[recordId]/edit',
                { patientId, diaryId, recordId }
              )
            )
          : localizeRoute(
              route('/voiding-diary/list/[diaryId]/records/input/[recordId]/edit', {
                diaryId,
                recordId,
              })
            )}

      <Tooltip.Root openDelay={100}>
        <Tooltip.Trigger asChild let:builder>
          <Button
            builders={[builder]}
            disabled={isCompleted && !isAdmin}
            prependIcon={PencilIcon}
            prependIconProps={{ class: 'size-4 [&_svg]:size-[inherit]' }}
            on:click={() => goto(editLink)}
          >
            {m.edit()}
          </Button>
        </Tooltip.Trigger>
        <Tooltip.Content class={cn((!isCompleted || isAdmin) && 'hidden')}>
          <p>Mikční deník je již ukončen</p>
        </Tooltip.Content>
      </Tooltip.Root>
    {/if}
  </Title>

  <Card.Root class="uzis-border max-w-prose">
    <Card.Content>
      {#if context === 'new'}
        {#if voidingDiaryResponse.isLoading}
          <LoadingIndicator />
        {:else if voidingDiaryResponse.isSuccess}
          {#if voidingDiaryResponse.data}
            <Form
              initialData={{
                voidingDiary: voidingDiaryResponse.data.voiding_diary,
                diaryId,
                patientId,
              }}
              {userContext}
            />
          {/if}
        {/if}
      {/if}

      {#if context !== 'new'}
        {#if response?.isLoading || voidingDiaryResponse.isLoading}
          <LoadingIndicator />
        {:else if response?.isSuccess && voidingDiaryResponse.isSuccess}
          {#if response.data && voidingDiaryResponse.data}
            <Form
              {context}
              initialData={{
                voidingDiaryRecord: response.data.voiding_record,
                voidingDiary: voidingDiaryResponse.data.voiding_diary,
                diaryId,
                patientId,
              }}
              {userContext}
            />
          {/if}
        {/if}
      {/if}
    </Card.Content>
  </Card.Root>
  <!-- svelte-ignore a11y-invalid-attribute -->
  <a class="bottom-0 ml-auto block md:sticky" href="#" title="Nahoru"
    ><img
      class="pointer-events-none w-80 max-w-full transition-all lg:w-96 2xl:w-[553px]"
      alt="illustr"
      src={DoctorImg}
    /></a
  >
</div>
