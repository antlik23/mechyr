<script lang="ts">
  import DoctorImg from '$lib/assets/images/doktorka.png?url';
  import Button from '$lib/components/common/Button.svelte';
  import Columns, { columnsVariants } from '$lib/components/common/Columns.svelte';
  import Title from '$lib/components/common/Title.svelte';
  import { LoadingIndicator } from '$lib/components/loading';
  import Breadcrumbs from '$lib/components/ui-wrappers/Breadcrumbs.svelte';
  import * as Tooltip from '$lib/components/ui/tooltip';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import { cn } from '$lib/utils';
  import * as m from '$paraglide/messages';
  import type { ComponentProps } from 'svelte';
  import type { QueryResponseProperties } from './types';

  export let response: QueryResponseProperties;
  export let breadcrumbs: ComponentProps<Breadcrumbs>['breadcrumbs'];
  export let userContext: 'admin' | 'patient';

  const DEFAULT_VALUE = '-';

  let doctorData: { value: string; label: string; class?: string; isLink?: boolean }[] = [];
  $: if (response.data) {
    const doctor = response.data.user;

    doctorData = [
      { value: doctor.street_and_number || DEFAULT_VALUE, label: m.address() },
      { value: doctor.city || DEFAULT_VALUE, label: m.city() },
      {
        value: doctor.working_hours || DEFAULT_VALUE,
        label: m.officeHours(),
        class: 'whitespace-pre-wrap',
      },
      { value: doctor.contact_email || DEFAULT_VALUE, label: m.email() },
      { value: doctor.contact_phone || DEFAULT_VALUE, label: m.phone() },
      {
        value: doctor.web
          ? doctor.web.startsWith('http')
            ? doctor.web
            : `https://${doctor.web}`
          : DEFAULT_VALUE,
        label: 'Web',
        isLink: Boolean(doctor.web),
      },
    ];
  }
</script>

<Breadcrumbs {breadcrumbs} />

<div class={columnsVariants({ number: 0, gap: 6 })}>
  {#if response.isLoading}
    <LoadingIndicator />
  {:else if response.isSuccess}
    {#if response.data}
      {@const doctor = response.data.user}

      <Title includeMeta={true} text={doctor.full_name || DEFAULT_VALUE} />

      <Columns gap={8} number={2}>
        <div class={columnsVariants({ number: 0, gap: 2 })}>
          {#each doctorData as item}
            <div class="flex gap-6">
              <span class="min-w-44 text-lg/6 font-semibold">{item.label}</span>

              {#if item.isLink}
                <a
                  class={cn('text-lg hover:underline', item.class)}
                  href={item.value}
                  target="_blank">{item.value}</a
                >
              {:else}
                <span class={cn('text-lg', item.class)}>{item.value}</span>
              {/if}
            </div>
          {/each}
        </div>
      </Columns>

      <!-- TODO: move to paraglide messages -->
      {#if userContext === 'patient'}
        {@const canContact = response.data.user.contact_status === 'allowed'}
        {@const forbiddenContact = response.data.user.contact_status === 'forbidden'}
        {@const hasContacted = response.data.user.contact_status === 'contacted'}
        {@const hasFullCapacity = !response.data.user.is_contactable}

        <Tooltip.Root openDelay={100}>
          <Tooltip.Trigger asChild let:builder>
            <Button
              class="justify-self-start"
              builders={[builder]}
              disabled={!canContact}
              href={canContact
                ? localizeRoute(route('/doctors/[doctorId]/contact', { doctorId: doctor.id }))
                : undefined}
              size="lg"
            >
              {m.contactADoctor()}
            </Button>
          </Tooltip.Trigger>
          <Tooltip.Content class={cn(canContact && 'hidden')}>
            <p>
              {#if hasFullCapacity}
                {'Lékář má vyčerpanou kapacitu'}
              {:else if hasContacted}
                {'Lékář byl již kontaktován'}
              {:else if forbiddenContact}
                {'Pro kontaktování lékaře je potřeba vyplnit dotazníky a mikční deník'}
              {/if}
            </p>
          </Tooltip.Content>
        </Tooltip.Root>
      {/if}
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
