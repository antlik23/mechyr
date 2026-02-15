<script lang="ts">
  import Button from '$lib/components/common/Button.svelte';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import Title from '$lib/components/common/Title.svelte';
  import { LoadingIndicator } from '$lib/components/loading';
  import Card from '$lib/components/wrappers/Card.svelte';
  import { persistedUser } from '$lib/components/user/data';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import { updateTextNodes } from '$lib/utils';
  import * as m from '$paraglide/messages';
  import { CheckCircle2Icon, PlusIcon } from 'lucide-svelte';
  import { onMount, type ComponentProps } from 'svelte';

  import TableFilters from './table-filters.svelte';
  import Table from './table.svelte';
  import type { QueryResponseProperties } from './types';

  export let response: QueryResponseProperties;
  export let filters: ComponentProps<TableFilters>['filters'];
  export let userContext: 'admin' | 'patient';

  const titleNames: Record<typeof userContext, () => string> = {
    admin: m.doctorsList,
    patient: m.doctorSelection,
  };

  $: assignedDoctorId = ($persistedUser?.user as { doctor_id?: number | null })?.doctor_id ?? null;
  $: assignedDoctorName =
    ($persistedUser?.user as { doctor_name?: string | null })?.doctor_name ?? null;

  onMount(() => {
    updateTextNodes();
  });
</script>

<div class={columnsVariants({ number: 0, gap: 5 })}>
  <Title containerClasses="justify-between" includeMeta={true} text={titleNames[userContext]()}>
    {#if userContext === 'admin'}
      <Button
        href={localizeRoute(route('/doctors/new'))}
        prependIcon={PlusIcon}
        prependIconProps={{ class: 'size-4 [&_svg]:size-[inherit]' }}
      >
        {m.newDoctor()}
      </Button>
    {/if}
  </Title>

  <p>Vyberte prosím lékaře ze seznamu a požádejte o vyšetření.</p>

  {#if userContext === 'patient' && assignedDoctorId && assignedDoctorName}
    <Card class="border-green-200 bg-green-50">
      <div class="flex items-center justify-between gap-4">
        <div class="flex items-center gap-3">
          <CheckCircle2Icon class="size-5 text-green-600" />
          <div>
            <p class="font-medium text-green-900">{m.yourDoctor()}</p>
            <p class="text-sm text-green-700">{assignedDoctorName}</p>
          </div>
        </div>
        <Button
          href={localizeRoute(route('/doctors/[doctorId]', { doctorId: String(assignedDoctorId) }))}
          size="sm"
          variant="outline"
        >
          {m.detail()}
        </Button>
      </div>
    </Card>
  {/if}

  {#if response.isLoading}
    <LoadingIndicator />
  {:else if response.isSuccess}
    {#if response.data}
      <div class={columnsVariants({ number: 0, gap: 4 })}>
        <TableFilters {filters} on:filter />

        <Table {assignedDoctorId} responseData={response.data} on:pagination on:sort />
      </div>
    {/if}
  {/if}
</div>
