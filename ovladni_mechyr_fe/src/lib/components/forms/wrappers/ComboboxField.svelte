<script context="module" lang="ts">
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  import type { FormPath } from 'sveltekit-superforms';
  export type ComboboxData = {
    value: string;
    content: {
      name: string | undefined;
    };
  };

  // Used in generics attribute.
  type T = Record<string, unknown>;
  type U = unknown;
  type TData = unknown;
</script>

<script
  generics="T extends Record<string, unknown>, U extends FormPath<T>, TData extends ComboboxData[]"
  lang="ts"
>
  import type { SuperForm } from 'sveltekit-superforms';
  import type { HTMLAttributes } from 'svelte/elements';
  import { Field, FieldErrors, Control, Label } from 'formsnap';
  import * as Command from '$lib/components/ui/command/index.js';
  import * as Popover from '$lib/components/ui/popover/index.js';
  import { ScrollArea } from '$lib/components/ui/scroll-area/index.js';
  import { tick, type ComponentProps } from 'svelte';
  import { createEventDispatcher } from 'svelte';
  import { cn, debounce } from '$lib/utils';

  import Button from '$lib/components/common/Button.svelte';

  interface $$Slots {
    comboboxItem: TData[number];
  }

  export let form: SuperForm<T>;
  export let name: U;
  export let data: TData;
  export let hasData: boolean = true;
  export let label: string | undefined = undefined;
  export let inputPlaceholder: string = '';
  export let disabled: boolean = false;
  export let noDataMessage: string = '';
  export let placeholder: string = '';
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
    select: { selectedValue: TData[number] };
    filter: {
      filterValue: string;
    };
  }>();

  $: ({ form: formData } = form);

  let open = false;
  $: handleOpenChange(open);

  let selected = {} as { value: (typeof data)[number]['value']; label?: string };
  $: {
    selected.value = $formData[name] as (typeof data)[number]['value'];
    if (!selected.value) {
      selected.label = undefined;
    }

    const selectedItem = data.find((dataItem) => dataItem.value === selected.value);
    if (data.length > 0 && selectedItem) {
      selected.label = selectedItem.content.name;
    }
  }

  function handleOpenChange(isOpen: boolean) {
    dispatch('openChange', { isOpen });
  }

  function handleSelection(data: TData[number], idsTrigger: string) {
    $formData[name] = data.value as T[U];
    dispatch('select', { selectedValue: data });
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

<Field {name} {form} let:errors>
  <div class="flex w-full flex-col gap-1">
    <Popover.Root bind:open let:ids>
      <Control let:attrs>
        {#if label}
          <Label class="label">
            {label}
            {attrs['aria-required'] ? '*' : ''}
          </Label>
        {/if}

        <Popover.Trigger class="grid" asChild let:builder>
          <Button
            class={triggerButtonClasses}
            aria-expanded={open}
            builders={[builder]}
            {disabled}
            role="combobox"
            variant="outline"
            {...attrs}
          >
            {#if selected.label}
              {selected.label}
            {:else}
              <span class="text-slate-400">{placeholder}</span>
            {/if}
          </Button>
        </Popover.Trigger>

        <input name={attrs.name} hidden value={selected.value} />
      </Control>
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

    {#if errors.length > 0}
      <FieldErrors class="text-sm text-destructive" />
    {/if}
  </div>
</Field>
