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
  <Title includeMeta={true} text={m.ipssForm()} />

  {#if userContext === 'patient'}
    <!-- TODO: move to paraglide messages -->
    <p>
      <strong>Dotazník IPSS</strong> je určen pouze mužům. Jedná se o získání informací ohledně onemocnění
      prostaty či léčby symptomů dolních cest močových. U každé otázky je výběr odpovědí, zvolte odpověď,
      která nejlépe odpovídá Vaší skutečné situaci. Je potřeba zodpovědět všechny otázky.
    </p>

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
      {@const ipss =
        'pagination' in response.data ? response.data.ipss_forms.at(0) : response.data.ipss_form}

      <Card.Root class="uzis-border max-w-prose">
        <Card.Content>
          <Form
            context={ipss === undefined ? 'new' : 'read'}
            {continueLink}
            initialData={{ ipss }}
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
