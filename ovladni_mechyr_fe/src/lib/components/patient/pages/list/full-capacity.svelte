<script lang="ts">
  import type { HTMLAttributes } from 'svelte/elements';
  import type { IsAny } from 'type-fest';
  import { type ComponentEvents, type ComponentProps } from 'svelte';
  import { assert, type Equals } from 'tsafe';
  import { cn } from '$lib/utils';
  import { createChangeFullCapacityMutation } from '$lib/api/mutations/doctor';
  import * as m from '$paraglide/messages';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import { Label } from '$lib/components/ui/label';
  import Select from '$lib/components/forms/fields/Select.svelte';

  let className: HTMLAttributes<HTMLDivElement>['class'] = undefined;
  export { className as class };
  export let selectedValue: boolean;

  const changeFullCapacityMutation = createChangeFullCapacityMutation();

  const selectId = 'full-capacity';
  const data: ComponentProps<Select>['data'] = [
    { value: 'true', label: m.yes() },
    { value: 'false', label: m.no() },
  ];

  let selected: ComponentProps<Select>['selected'];
  $: selected = data.find(({ value }) => value === String(selectedValue));

  function handleSelect({ detail: { value } }: ComponentEvents<Select>['select']) {
    assert<Equals<IsAny<Parameters<typeof handleSelect>['0']['detail']>, false>>();

    $changeFullCapacityMutation.mutate({ fullCapacity: value === 'true' });
  }
</script>

<div class={cn(columnsVariants({ number: 0, gap: 2 }), className)}>
  <Label for={selectId}>{m.fullCapacity()}</Label>

  <Select id={selectId} allowDeselect={false} {data} {selected} on:select={handleSelect} />
</div>
