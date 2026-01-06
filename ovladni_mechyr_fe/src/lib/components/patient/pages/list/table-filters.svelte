<script lang="ts">
  import type { StrictExtract } from 'ts-essentials';
  import type { queries } from '$lib/api/queries';
  import { createEventDispatcher, type ComponentProps } from 'svelte';
  import { debounce } from '$lib/utils';
  import * as m from '$paraglide/messages.js';
  import Columns, { columnsVariants } from '$lib/components/common/Columns.svelte';
  import { Label } from '$lib/components/ui/label/index.js';
  import Input from '$lib/components/forms/fields/Input.svelte';
  import { SearchIcon } from 'lucide-svelte';

  export let filters: NonNullable<Parameters<typeof queries.patients.list>['0']>;
  export let columnsProps: ComponentProps<Columns> | undefined = undefined;

  const dispatch = createEventDispatcher<{
    filter: {
      filterValue: Parameters<typeof handleFilterValueChange>['0'];
      filterKey: Parameters<typeof handleFilterValueChange>['1'];
    };
  }>();

  const filterIdPrefix = 'patient-list';
  const filterIds: Record<Parameters<typeof handleFilterValueChange>['1'], string> = {
    patient_id: `${filterIdPrefix}-patient_id`,
    email: `${filterIdPrefix}-email`,
  } as const;

  const handleFilterValueChange = debounce(
    (
      inputValue: string | number | undefined,
      parameter: StrictExtract<keyof typeof filters, 'patient_id' | 'email'>
    ) => {
      dispatch('filter', {
        filterValue:
          typeof inputValue === 'string' && inputValue?.trim() === '' ? undefined : inputValue,
        filterKey: parameter,
      });
    }
  );
</script>

<Columns number={4} {...columnsProps}>
  <div class={columnsVariants({ number: 0, gap: 2 })}>
    <Label for={filterIds.patient_id}>{m.searchById()}</Label>

    <Input
      id={filterIds.patient_id}
      prepend={SearchIcon}
      type="number"
      value={filters.patient_id}
      on:input={(event) => {
        handleFilterValueChange(
          event.currentTarget.value !== '' ? Number(event.currentTarget.value) : undefined,
          'patient_id'
        );
      }}
    />
  </div>

  <div class={columnsVariants({ number: 0, gap: 2 })}>
    <Label for={filterIds.email}>{m.searchByEmail()}</Label>

    <Input
      id={filterIds.email}
      prepend={SearchIcon}
      type="text"
      value={filters.email}
      on:input={(event) => handleFilterValueChange(event.currentTarget.value, 'email')}
    />
  </div>
</Columns>
