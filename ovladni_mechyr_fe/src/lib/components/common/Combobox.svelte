<script context="module" lang="ts">
  export type ComboboxData = {
    value: string;
    content: {
      name: string | undefined;
    };
  };

  // Used in generics attribute.
  type TData = unknown;
</script>

<script generics="TData extends ComboboxData[]" lang="ts">
  import type { HTMLAttributes } from 'svelte/elements';
  import * as Command from '$lib/components/ui/command/index.js';
  import * as Popover from '$lib/components/ui/popover/index.js';
  import { ScrollArea } from '$lib/components/ui/scroll-area/index.js';
  import { tick, type ComponentProps } from 'svelte';
  import { createEventDispatcher } from 'svelte';
  import { cn, debounce } from '$lib/utils';

  import Button from '$lib/components/common/Button.svelte';

  interface $$Slots {
    trigger: { selectedValue: typeof selectedValue };
    comboboxItem: TData[number];
  }

  export let data: TData;
  export let hasData: boolean = true;
  export let inputPlaceholder: string = '';
  export let noDataMessage: string = '';
  export let triggerText: string = '';
  export let shouldFilter: ComponentProps<Command.Root>['shouldFilter'] = true;
  export let isLoading: boolean = false;
  export let triggerButtonClasses: ComponentProps<Button>['class'] = undefined;
  export let popoverContentClasses: ComponentProps<Popover.Content>['class'] = undefined;
  export let popoverContentSideOffset: ComponentProps<Popover.Content>['sideOffset'] = 4;
  export let scrollAreaClasses: ComponentProps<ScrollArea>['class'] = undefined;
  export let dataContainerClasses: HTMLAttributes<HTMLDivElement>['class'] = undefined;
  export let commandItemClasses: ComponentProps<Command.Item>['class'] = undefined;

  const dispatch = createEventDispatcher<{
    openChange: { isOpen: boolean };
    select: TData[number];
    filter: {
      filterValue: string;
    };
  }>();

  let open = false;
  let selectedValue: string | undefined = undefined;
  $: handleOpenChange(open);

  function handleOpenChange(isOpen: boolean) {
    dispatch('openChange', { isOpen });
  }

  function handleSelection(data: TData[number], idsTrigger: string) {
    selectedValue = data.content.name;
    dispatch('select', data);
    closeAndFocusTrigger(idsTrigger);
  }

  function closeAndFocusTrigger(triggerId: string) {
    open = false;
    tick().then(() => {
      document.getElementById(triggerId)?.focus();
    });
  }

  const handleInputValueChange = debounce((event: Event) => {
    const { value } = event.target as HTMLInputElement;

    dispatch('filter', { filterValue: value });
  });
</script>

<Popover.Root bind:open let:ids>
  <Popover.Trigger class="grid" asChild let:builder>
    <Button
      class={triggerButtonClasses}
      aria-expanded={open}
      builders={[builder]}
      role="combobox"
      variant="outline"
    >
      <slot name="trigger" {selectedValue}>
        {#if selectedValue}
          {selectedValue}
        {:else}
          <span class="text-slate-400">{triggerText}</span>
        {/if}
      </slot>
    </Button>
  </Popover.Trigger>
  <Popover.Content
    class={cn('rounded-lg border-none bg-white p-0', popoverContentClasses)}
    sameWidth
    sideOffset={popoverContentSideOffset}
  >
    <Command.Root {shouldFilter}>
      <Command.Input
        placeholder={inputPlaceholder}
        on:input={(event) => handleInputValueChange(event)}
      />

      {#if isLoading}
        <Command.Loading />
      {:else if !hasData}
        <Command.Empty>{noDataMessage}</Command.Empty>
      {:else if data.length > 0}
        <Command.Empty>{noDataMessage}</Command.Empty>
        <Command.Group>
          <ScrollArea class={cn('max-h-56', scrollAreaClasses)}>
            <div class={cn('grid', dataContainerClasses)}>
              {#each data as item}
                <Command.Item
                  class={commandItemClasses}
                  onSelect={() => handleSelection(item, ids.trigger)}
                  value={item.content.name}
                >
                  <slot name="comboboxItem" content={item.content} value={item.value}>
                    {item.content.name}
                  </slot>
                </Command.Item>
              {/each}
            </div>
          </ScrollArea>
        </Command.Group>
      {/if}
    </Command.Root>
  </Popover.Content>
</Popover.Root>
