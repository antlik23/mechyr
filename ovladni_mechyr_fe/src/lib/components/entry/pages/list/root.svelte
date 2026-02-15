<script lang="ts">
  import { createEventDispatcher, type ComponentEvents, type ComponentProps } from 'svelte';
  import type { QueryResponseProperties as OabQueryResponseProperties } from '$lib/components/questionnaire/oab/pages/detail/types';
  import type { QueryResponseProperties as IciqQueryResponseProperties } from '$lib/components/questionnaire/iciq/pages/detail/types';
  import type { QueryResponseProperties as IpssQueryResponseProperties } from '$lib/components/questionnaire/ipss/pages/detail/types';
  import type { QueryResponseProperties as AnamnesticQueryResponseProperties } from '$lib/components/questionnaire/anamnestic/pages/detail/types';
  import type { VoidingDiariesQueryResponseProperties } from './types';
  import * as m from '$paraglide/messages';
  import Title from '$lib/components/common/Title.svelte';
  import * as Card from '$lib/components/ui/card';
  import Columns, { columnsVariants } from '$lib/components/common/Columns.svelte';
  import { LoadingIndicator } from '$lib/components/loading';
  import Button from '$lib/components/common/Button.svelte';
  import { goto } from '$app/navigation';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import QuestionnairesTable from './questionnaires-table.svelte';
  import VoidingDiariesTable from './voiding-diaries-table.svelte';

  export let oabResponse: OabQueryResponseProperties;
  export let iciqResponse: IciqQueryResponseProperties;
  export let ipssResponse: IpssQueryResponseProperties;
  export let anamnesticResponse: AnamnesticQueryResponseProperties;
  export let voidingDiariesResponse: VoidingDiariesQueryResponseProperties;

  const dispatch = createEventDispatcher<{
    voidingDiariesPagination: ComponentEvents<VoidingDiariesTable>['pagination']['detail'];
  }>();

  $: tableResponses = [oabResponse, iciqResponse, ipssResponse, anamnesticResponse];

  let tableResponseData: ComponentProps<QuestionnairesTable>['responseData'] = [];
  $: {
    tableResponseData = [];
    if (Array.isArray(oabResponse.data?.oab_forms)) {
      tableResponseData.push(...transformToTableResponse('oab_form', oabResponse.data.oab_forms));
    }

    if (Array.isArray(iciqResponse.data?.iciq_forms)) {
      tableResponseData.push(
        ...transformToTableResponse('iciq_form', iciqResponse.data.iciq_forms)
      );
    }

    if (Array.isArray(ipssResponse.data?.ipss_forms)) {
      tableResponseData.push(
        ...transformToTableResponse('ipss_form', ipssResponse.data.ipss_forms)
      );
    }

    if (Array.isArray(anamnesticResponse.data?.anamnestic_forms)) {
      tableResponseData.push(
        ...transformToTableResponse(
          'anamnestic_form',
          anamnesticResponse.data.anamnestic_forms.map((anamnesticForm) => ({
            ...anamnesticForm,
            total_score: null,
          }))
        )
      );
    }

    tableResponseData = tableResponseData;
  }

  function transformToTableResponse(
    type: (typeof tableResponseData)[number]['type'],
    questionnaire:
      | NonNullable<(typeof oabResponse)['data']>['oab_forms']
      | NonNullable<(typeof iciqResponse)['data']>['iciq_forms']
      | NonNullable<(typeof ipssResponse)['data']>['ipss_forms']
      | (NonNullable<(typeof anamnesticResponse)['data']>['anamnestic_forms'][number] & {
          total_score: null;
        })[]
  ) {
    return questionnaire.map(({ completion_timestamp, total_score, id }) => ({
      type,
      completion_timestamp,
      total_score,
      id,
    })) satisfies typeof tableResponseData;
  }

  // Check if all questionnaires are completed
  $: hasCompletedOab = oabResponse.data?.oab_forms?.some((form) => form.completion_timestamp);
  $: hasCompletedIciq = iciqResponse.data?.iciq_forms?.some((form) => form.completion_timestamp);
  $: hasCompletedIpss = ipssResponse.data?.ipss_forms?.some((form) => form.completion_timestamp);
  $: hasCompletedAnamnestic = anamnesticResponse.data?.anamnestic_forms?.some(
    (form) => form.completion_timestamp
  );
  $: hasCompletedDiary =
    voidingDiariesResponse.data?.voiding_diaries?.some((diary) => diary.completed) || false;

  $: allQuestionnairesCompleted =
    hasCompletedOab && hasCompletedIciq && hasCompletedIpss && hasCompletedAnamnestic;

  function handleDoctorSelection() {
    goto(localizeRoute(route('/doctors')));
  }

  function handleCreateDiary() {
    goto(localizeRoute(route('/voiding-diary')));
  }
</script>

<div class={columnsVariants({ number: 0, gap: 5 })}>
  <Title includeMeta={true} text={m.entries()} />

  {#if allQuestionnairesCompleted}
    <Card.Root class="border-primary bg-primary/5">
      <Card.Header>
        <Title level="h3" text="Další krok: Výběr lékaře" />
      </Card.Header>
      <Card.Content class={columnsVariants({ number: 0, gap: 4 })}>
        <p class="text-base">
          Výborně! Dokončili jste všechny povinné dotazníky. Nyní můžete pokračovat výběrem lékaře,
          který bude vaše záznamy vyhodnocovat a poskytne vám odbornou péči.
        </p>
        {#if !hasCompletedDiary}
          <Card.Root class="border-amber-500 bg-amber-50">
            <Card.Content class="pt-6">
              <p class="text-sm text-amber-900">
                <strong>Upozornění:</strong> Pro stanovení léčby je nezbytný vyplněný mikční deník –
                bez toho lékař nedokáže stanovit léčbu. Doporučujeme nejprve vytvořit a dokončit mikční
                deník.
              </p>
            </Card.Content>
          </Card.Root>
        {/if}
        <div class="flex flex-wrap gap-3">
          <Button on:click={handleDoctorSelection}>Vybrat lékaře</Button>
          {#if !hasCompletedDiary}
            <Button variant="outline" on:click={handleCreateDiary}>Vytvořit mikční deník</Button>
          {/if}
        </div>
      </Card.Content>
    </Card.Root>
  {/if}

  <Columns number={2} verticalAlign="start">
    <Card.Root>
      <Card.Header>
        <Title text={m.questionnaires()} />
      </Card.Header>

      <Card.Content>
        {#if tableResponses.some((response) => response.isLoading)}
          <LoadingIndicator />
        {:else if tableResponses.every((response) => response.isSuccess)}
          <QuestionnairesTable responseData={tableResponseData} />
        {/if}
      </Card.Content>
    </Card.Root>

    <Card.Root>
      <Card.Header>
        <Title text={m.voidingDiary()} />
      </Card.Header>

      <Card.Content>
        {#if voidingDiariesResponse.isLoading}
          <LoadingIndicator />
        {:else if voidingDiariesResponse.isSuccess}
          {#if voidingDiariesResponse.data}
            <VoidingDiariesTable
              responseData={voidingDiariesResponse.data.voiding_diaries}
              on:pagination={({ detail }) => dispatch('voidingDiariesPagination', detail)}
            />
          {/if}
        {/if}
      </Card.Content>
    </Card.Root>
  </Columns>
</div>
