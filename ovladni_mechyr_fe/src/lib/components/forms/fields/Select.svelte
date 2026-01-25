<script lang="ts">
  import { createEventDispatcher, type ComponentProps } from 'svelte';
  import type { Selected, Select as SelectPrimitive } from 'bits-ui';
  import type { SelectData } from '$lib/components/form/types';
  import { cn } from '$lib/utils';
  import * as Select from '$lib/components/ui/select';
  import { ScrollArea } from '$lib/components/ui/scroll-area';
  import Icon from '$lib/components/wrappers/Icon.svelte';

  type $$Props = ComponentProps<Select.Trigger> & {
    placeholder?: SelectPrimitive.ValueProps['placeholder'];
    selected?:
      | Selected<SelectData['value'] | undefined>
      | Selected<SelectData['value'] | undefined>[];
    data: SelectData[];
    disabled?: ComponentProps<Select.Item>['disabled'];
    multiple?: boolean;
    preventScroll?: boolean;
    allowDeselect?: boolean;
    scrollAreaClasses?: ComponentProps<ScrollArea>['class'];
    prepend?: ComponentProps<Icon>['icon'];
    prependClasses?: ComponentProps<Icon>['class'];
    append?: ComponentProps<Icon>['icon'];
    appendClasses?: ComponentProps<Icon>['class'];
  };

  export let placeholder: $$Props['placeholder'] = undefined;
  export let name: $$Props['name'] = undefined;
  export let selected: $$Props['selected'] = undefined;
  export let data: $$Props['data'];
  export let disabled: $$Props['disabled'] = undefined;
  export let multiple: $$Props['multiple'] = undefined;
  export let preventScroll: $$Props['preventScroll'] = false;
  export let allowDeselect: $$Props['allowDeselect'] = true;
  export let scrollAreaClasses: $$Props['scrollAreaClasses'] = undefined;
  export let prepend: $$Props['prepend'] = undefined;
  export let prependClasses: $$Props['prependClasses'] = undefined;
  export let append: $$Props['append'] = undefined;
  export let appendClasses: $$Props['appendClasses'] = undefined;

  const dispatch = createEventDispatcher<{
    select: {
      value: SelectData['value'] | SelectData['value'][] | undefined;
    };
  }>();

  function handleSelect(newSelected: $$Props['selected']) {
    if (Array.isArray(newSelected)) {
      const selectedValues = newSelected.reduce(
        (accumulator, { value }) => {
          if (value) {
            accumulator.push(value);
          }
          return accumulator;
        },
        [] as SelectData['value'][]
      );

      selected = newSelected;
      dispatch('select', { value: selectedValues });
    } else if (!Array.isArray(selected)) {
      if (allowDeselect && selected?.value === newSelected?.value) {
        // Reset selected value.
        selected = { value: undefined, label: undefined };
      } else {
        selected = newSelected;
      }

      dispatch('select', { value: selected?.value });
    }
  }
</script>

<Select.Root {disabled} {multiple} onSelectedChange={handleSelect} {preventScroll} {selected}>
  {#if name}
    <Select.Input {name} />
  {/if}

  <Select.Trigger {disabled} {...$$restProps}>
    {#if prepend}
      <Icon class={cn('-ml-[1px] mr-[1px] text-gray-600', prependClasses)} icon={prepend} />
    {/if}

    <slot name="triggerButtonValuePrepend" />

    <Select.Value asChild {placeholder} let:attrs let:label>
      <span class="truncate" {...attrs}>
        {#if label}
          {label}
        {:else if placeholder}
          {placeholder}
        {/if}
      </span>
    </Select.Value>

    <slot name="triggerButtonValueAppend" />

    {#if append}
      <Icon class={cn('ml-auto text-gray-600', appendClasses)} icon={append} />
    {/if}
  </Select.Trigger>
  <Select.Content>
    <ScrollArea class={cn('max-h-64', scrollAreaClasses)}>
      {#each data as item}
        <Select.Item {...item} />
      {/each}
    </ScrollArea>
  </Select.Content>
</Select.Root>
