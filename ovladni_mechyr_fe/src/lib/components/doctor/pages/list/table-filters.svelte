<script lang="ts">
  import type { StrictExtract } from 'ts-essentials';
  import type { queries } from '$lib/api/queries';
  import { createEventDispatcher } from 'svelte';
  import { debounce } from '$lib/utils';
  import * as m from '$paraglide/messages.js';
  import Columns, { columnsVariants } from '$lib/components/common/Columns.svelte';
  import { Label } from '$lib/components/ui/label/index.js';
  import Input from '$lib/components/forms/fields/Input.svelte';
  import { SearchIcon } from 'lucide-svelte';

  export let filters: NonNullable<Parameters<typeof queries.doctors.availableList>['0']>;

  const dispatch = createEventDispatcher<{
    filter: {
      filterValue: Parameters<typeof handleFilterValueChange>['0'];
      filterKey: Parameters<typeof handleFilterValueChange>['1'];
    };
  }>();

  const filterIdPrefix = 'doctor-list';
  const filterIds: Record<Parameters<typeof handleFilterValueChange>['1'], string> = {
    full_name: `${filterIdPrefix}-full_name`,
    city: `${filterIdPrefix}-city`,
  } as const;

  const handleFilterValueChange = debounce(
    (
      inputValue: string | undefined,
      parameter: StrictExtract<keyof typeof filters, 'full_name' | 'city'>
    ) => {
      dispatch('filter', {
        filterValue: inputValue?.trim() !== '' ? inputValue : undefined,
        filterKey: parameter,
      });
    }
  );
</script>

<Columns number={4}>
  <div class={columnsVariants({ number: 0, gap: 2 })}>
    <Label for={filterIds.full_name}>{m.searchByName()}</Label>

    <Input
      id={filterIds.full_name}
      prepend={SearchIcon}
      type="text"
      value={filters.full_name}
      on:input={(event) => handleFilterValueChange(event.currentTarget.value, 'full_name')}
    />
  </div>

  <div class={columnsVariants({ number: 0, gap: 2 })}>
    <Label for={filterIds.city}>{m.searchByCity()}</Label>

    <Input
      id={filterIds.city}
      prepend={SearchIcon}
      type="text"
      value={filters.city}
      on:input={(event) => handleFilterValueChange(event.currentTarget.value, 'city')}
    />
  </div>
</Columns>
