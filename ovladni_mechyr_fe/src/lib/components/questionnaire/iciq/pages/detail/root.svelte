<script lang="ts">
  import DoctorImg from '$lib/assets/images/doktorka.png?url';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import Title from '$lib/components/common/Title.svelte';
  import { LoadingIndicator } from '$lib/components/loading';
  import Breadcrumbs from '$lib/components/ui-wrappers/Breadcrumbs.svelte';
  import * as Card from '$lib/components/ui/card';
  import * as m from '$paraglide/messages';
  import type { ComponentProps } from 'svelte';
  import Form from './form.svelte';
  import type { DetailQueryResponseProperties, QueryResponseProperties } from './types';

  export let response: QueryResponseProperties | DetailQueryResponseProperties;
  export let breadcrumbs: ComponentProps<Breadcrumbs>['breadcrumbs'] | undefined = undefined;
  export let continueLink: ComponentProps<Form>['continueLink'] = undefined;
  export let userContext: ComponentProps<Form>['userContext'] = 'patient';
</script>

{#if breadcrumbs}
  <Breadcrumbs {breadcrumbs} />
{/if}

<div class={columnsVariants({ number: 0 })}>
  <Title includeMeta={true} text={m.iciqForm()} />

  {#if userContext === 'patient'}
    <!-- TODO: move to paraglide messages -->
    <p>
      <strong>Dotazník ICIQ-UI SF</strong> je zaměřen na inkontinenci. Odpovídejte na uvedené otázky,
      které lékaři pomohou zhodnotit inkontinenci v rámci závažnosti, frekvence a dopadu na kvalitu života.
      Je potřeba zodpovědět všechny otázky.
    </p>

    <!-- eslint-disable-next-line svelte/no-at-html-tags -->
    <p>{@html m.thinkAboutHowYouFeltOnAverageDuringTheLastFourWeeks()}</p>

    <p class="text-red-500">
      <strong>
        Po uložení se dotazník uzamkne a nebude možné odpovědi upravit. Prosím, zkontrolujte si je
        před uložením.
      </strong>
    </p>
  {/if}

  {#if response.isLoading}
    <LoadingIndicator />
  {:else if response.isSuccess}
    {#if response.data}
      {@const iciq =
        'pagination' in response.data ? response.data.iciq_forms.at(0) : response.data.iciq_form}

      <Card.Root class="uzis-border max-w-prose">
        <Card.Content>
          <Form
            context={iciq === undefined ? 'new' : 'read'}
            {continueLink}
            initialData={{ iciq }}
            {userContext}
          />
        </Card.Content>
      </Card.Root>
    {/if}
  {/if}
  <!-- svelte-ignore a11y-invalid-attribute -->
  <a class="bottom-0 ml-auto block md:sticky" href="#" title="Nahoru"
    ><img
      class="pointer-events-none w-80 max-w-full transition-all lg:w-96 2xl:w-[553px]"
      alt="illustr"
      src={DoctorImg}
    /></a
  >
</div>
