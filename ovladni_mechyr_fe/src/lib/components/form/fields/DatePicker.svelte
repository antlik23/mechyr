<script lang="ts">
  import type { HTMLButtonAttributes } from 'svelte/elements';
  import type { Merge } from 'type-fest';
  import type { PopoverProps } from 'bits-ui';
  import { createEventDispatcher, type ComponentProps } from 'svelte';
  import { getLocalTimeZone, parseDate } from '@internationalized/date';
  import { isDate } from 'date-fns';
  import { cn } from '$lib/utils.js';
  import { languageTag } from '$paraglide/runtime';
  import { getDateString } from '$lib/utils/dates';
  import * as m from '$paraglide/messages';
  import * as Popover from '$lib/components/ui/popover';
  import Button from '$lib/components/common/Button.svelte';
  import Icon from '$lib/components/wrappers/Icon.svelte';
  import { Calendar } from '$lib/components/ui/calendar';
  import Columns from '$lib/components/common/Columns.svelte';
  import { CalendarDaysIcon } from 'lucide-svelte';

  type $$Props = Merge<
    ComponentProps<Button>,
    {
      value?: ComponentProps<Calendar>['value'];
      disabled?: HTMLButtonAttributes['disabled'];
      sameWidth?: ComponentProps<Popover.Content>['sameWidth'];
      prepend?: ComponentProps<Icon>['icon'];
      prependClasses?: ComponentProps<Icon>['class'];
      append?: ComponentProps<Icon>['icon'];
      appendClasses?: ComponentProps<Icon>['class'];
      calendarProps?: ComponentProps<Calendar>;
      minimumDate?: string | Date;
      maximumDate?: $$Props['minimumDate'];
      popoverProps?: PopoverProps;
    }
  >;

  export let value: $$Props['value'] = undefined;
  export let placeholder: $$Props['placeholder'] = undefined;
  export let sameWidth: $$Props['sameWidth'] = undefined;
  export let prepend: $$Props['prepend'] = undefined;
  export let prependClasses: $$Props['prependClasses'] = undefined;
  export let append: $$Props['append'] = CalendarDaysIcon;
  export let appendClasses: $$Props['appendClasses'] = undefined;
  export let calendarProps: $$Props['calendarProps'] = undefined;
  export let minimumDate: $$Props['minimumDate'] = undefined;
  export let maximumDate: $$Props['maximumDate'] = undefined;
  export let popoverProps: $$Props['popoverProps'] = undefined;

  const dispatch = createEventDispatcher<{
    select: { date: string | undefined };
  }>();

  $: formattedValue = value?.toDate(getLocalTimeZone()).toLocaleDateString(languageTag());

  let minValue: ComponentProps<Calendar>['minValue'];
  $: minValue = determineDateValue(minimumDate);

  let maxValue: ComponentProps<Calendar>['maxValue'];
  $: maxValue = determineDateValue(maximumDate);

  function determineDateValue(dateValue: $$Props['minimumDate']) {
    if (!dateValue) return;

    if (isDate(dateValue)) {
      return parseDate(getDateString(dateValue.toISOString()));
    }

    return parseDate(dateValue);
  }

  function handleValueChange(newDate: $$Props['value']) {
    dispatch('select', { date: newDate?.toString() });
  }

  function handleClearClick() {
    value = undefined;
    handleValueChange(value);
  }

  function handleTodayClick() {
    value = parseDate(getDateString(new Date().toISOString()));
    handleValueChange(value);
  }
</script>

<Popover.Root openFocus {...popoverProps}>
  <Popover.Trigger asChild let:builder>
    <Button
      class={cn('font-normal', !value && 'text-muted-foreground')}
      builders={[builder]}
      variant="input"
      {...$$restProps}
    >
      {#if prepend}
        <Icon
          class={cn('-ml-[1px] mr-[1px] text-muted-foreground', prependClasses)}
          icon={prepend}
        />
      {/if}

      <span class="truncate">
        {#if formattedValue}
          {formattedValue}
        {:else if placeholder}
          {placeholder}
        {/if}
      </span>

      {#if append}
        <Icon class={cn('ml-auto text-muted-foreground', appendClasses)} icon={append} />
      {/if}
    </Button>
  </Popover.Trigger>
  <Popover.Content class="w-auto p-0" {sameWidth}>
    <Calendar {maxValue} {minValue} onValueChange={handleValueChange} bind:value {...calendarProps}>
      <Columns slot="append" gap={4} number={2}>
        <Button variant="outline" on:click={handleClearClick}>{m.clear()}</Button>
        <Button on:click={handleTodayClick}>{m.today()}</Button>
      </Columns>
    </Calendar>
  </Popover.Content>
</Popover.Root>
