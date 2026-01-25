<script lang="ts">
  import DoctorImg from '$lib/assets/images/doktorka.png?url';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import Title from '$lib/components/common/Title.svelte';
  import { LoadingIndicator } from '$lib/components/loading';
  import Breadcrumbs from '$lib/components/ui-wrappers/Breadcrumbs.svelte';
  import * as Card from '$lib/components/ui/card';
  import { updateTextNodes } from '$lib/utils';
  import * as m from '$paraglide/messages';
  import { onMount, type ComponentProps } from 'svelte';
  import Form from './form.svelte';
  import type { DetailQueryResponseProperties, QueryResponseProperties } from './types';

  export let response: QueryResponseProperties | DetailQueryResponseProperties;
  export let breadcrumbs: ComponentProps<Breadcrumbs>['breadcrumbs'] | undefined = undefined;
  export let continueLink: ComponentProps<Form>['continueLink'] = undefined;
  export let userContext: ComponentProps<Form>['userContext'] = 'patient';
  export let formGender: ComponentProps<Form>['initialData']['gender'];

  onMount(() => {
    updateTextNodes();
  });
</script>

{#if breadcrumbs}
  <Breadcrumbs {breadcrumbs} />
{/if}

<div class={columnsVariants({ number: 0 })}>
  <Title includeMeta={true} text={m.oabV8Form()} />

  {#if userContext === 'patient'}
    <!-- TODO: move to paraglide messages -->
    <p>
      <strong>Dotazník OAB-V8</strong> pomůže lékaři zjistit souvislost vašich problémů s močovým měchýřem.
      U každé otázky je výběr odpovědí, zvolte odpověď, která nejlépe odpovídá Vaší skutečné situaci.
      Je potřeba zodpovědět všechny otázky.
    </p>

    <p class="text-red-500">
      <strong>
        Po uložení se dotazník uzamkne a nebude možné odpovědi upravit. Prosím, zkontrolujte si je
        před uložením.
      </strong>
    </p>

    <p>{m.howMuchItBothersYou()}:</p>
  {/if}

  {#if response.isLoading}
    <LoadingIndicator />
  {:else if response.isSuccess}
    {#if response.data}
      {@const oab =
        'pagination' in response.data ? response.data.oab_forms.at(0) : response.data.oab_form}

      <Card.Root class="uzis-border max-w-prose">
        <Card.Content>
          <Form
            context={oab === undefined ? 'new' : 'read'}
            {continueLink}
            initialData={{ oab, gender: formGender }}
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
