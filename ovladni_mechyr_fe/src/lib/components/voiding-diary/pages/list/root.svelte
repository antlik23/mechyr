<script lang="ts">
  import { goto } from '$app/navigation';
  import Button from '$lib/components/common/Button.svelte';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import Title from '$lib/components/common/Title.svelte';
  import VoidingDiariesTable from '$lib/components/entry/pages/list/voiding-diaries-table.svelte';
  import { LoadingIndicator } from '$lib/components/loading';
  import Breadcrumbs from '$lib/components/ui-wrappers/Breadcrumbs.svelte';
  import * as Tooltip from '$lib/components/ui/tooltip';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import * as m from '$paraglide/messages';
  import { PlusIcon } from 'lucide-svelte';
  import type { ComponentProps } from 'svelte';
  import type { LatestVoidingDiaryQueryResponseProperties, QueryResponseProperties } from './types';

  export let response: QueryResponseProperties;
  export let breadcrumbs: ComponentProps<Breadcrumbs>['breadcrumbs'];
  export let latestVoidingDiaryResponse: LatestVoidingDiaryQueryResponseProperties;
</script>

<Breadcrumbs {breadcrumbs} />

<div class={columnsVariants({ number: 0, gap: 5 })}>
  <Title containerClasses="justify-between" includeMeta={true} text={m.voidingDiary()}>
    {#if latestVoidingDiaryResponse.isLoading}
      <LoadingIndicator />
    {:else if latestVoidingDiaryResponse.isSuccess}
      {@const latestDiary = latestVoidingDiaryResponse.data?.voiding_diary}
      {@const isDisabled = latestDiary && !latestDiary.completed}
      {@const tooltipMessage = isDisabled ? 'Nedokončený mikční deník již existuje' : null}

      <Tooltip.Root openDelay={100}>
        <Tooltip.Trigger asChild let:builder>
          <Button
            builders={[builder]}
            disabled={isDisabled}
            prependIcon={PlusIcon}
            prependIconProps={{ class: 'size-4 [&_svg]:size-[inherit]' }}
            on:click={() => goto(localizeRoute(route('/voiding-diary/list/new')))}
          >
            {m.newVoidingDiary()}
          </Button>
        </Tooltip.Trigger>
        {#if tooltipMessage}
          <Tooltip.Content>
            <p>{tooltipMessage}</p>
          </Tooltip.Content>
        {/if}
      </Tooltip.Root>
    {/if}
  </Title>

  {#if response.isLoading}
    <LoadingIndicator />
  {:else if response.isSuccess}
    {#if response.data}
      <VoidingDiariesTable responseData={response.data.voiding_diaries} on:pagination />
    {/if}
  {/if}
</div>
