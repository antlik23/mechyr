<script lang="ts">
  import { createEventDispatcher, type ComponentProps } from 'svelte';
  import { debounce } from '$lib/utils';

  import Input from '$lib/components/forms/fields/Input.svelte';
  import { Label } from '$lib/components/ui/label/index.js';

  import MagnifierIcon from '$lib/assets/icons/magnifier.svg?component';

  export let value: string = '';
  export let id: ComponentProps<Label>['for'];
  export let label: string;
  export let placeholder: ComponentProps<Input>['placeholder'] = undefined;

  const dispatch = createEventDispatcher<{
    filter: {
      filterValue: Parameters<typeof handleFilterValueChange>['0'];
    };
  }>();

  const handleFilterValueChange = debounce((inputValue: string) => {
    dispatch('filter', {
      filterValue: inputValue,
    });
  });
</script>

<div class="flex flex-col gap-1">
  <Label class="label" for={id}>{label}</Label>

  <div class="relative">
    <Input
      {id}
      append={MagnifierIcon}
      {placeholder}
      type="text"
      bind:value
      on:input={(event) => handleFilterValueChange(event.currentTarget.value)}
    />
  </div>
</div>
