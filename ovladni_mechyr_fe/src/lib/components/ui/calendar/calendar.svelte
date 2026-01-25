<script lang="ts">
  import { Calendar as CalendarPrimitive } from 'bits-ui';
  import * as Calendar from './index.js';
  import { cn } from '$lib/utils.js';
  import { languageTag } from '$paraglide/runtime.js';

  type $$Props = CalendarPrimitive.Props & {
    uppercaseWeekDays?: boolean;
  };

  type $$Events = CalendarPrimitive.Events;

  export let value: $$Props['value'] = undefined;
  export let placeholder: $$Props['placeholder'] = undefined;
  export let fixedWeeks: $$Props['fixedWeeks'] = true;
  export let locale: $$Props['locale'] = languageTag();
  export let initialFocus: $$Props['initialFocus'] = true;
  export let weekStartsOn: $$Props['weekStartsOn'] = 0;
  export let weekdayFormat: $$Props['weekdayFormat'] = 'short';
  export let uppercaseWeekDays: $$Props['uppercaseWeekDays'] = true;

  let className: $$Props['class'] = undefined;
  export { className as class };
</script>

<CalendarPrimitive.Root
  class={cn('rounded-md bg-white p-3', className)}
  {fixedWeeks}
  {initialFocus}
  {locale}
  {weekStartsOn}
  {weekdayFormat}
  bind:value
  bind:placeholder
  {...$$restProps}
  on:keydown
  let:months
  let:weekdays
>
  <Calendar.Header>
    <Calendar.PrevButton />
    <Calendar.Heading />
    <Calendar.NextButton />
  </Calendar.Header>
  <Calendar.Months>
    {#each months as month}
      <Calendar.Grid>
        <Calendar.GridHead>
          <Calendar.GridRow>
            {#each weekdays as weekday}
              <Calendar.HeadCell>
                {@const weekdayShort = weekday.slice(0, 2)}

                {#if uppercaseWeekDays}
                  {weekdayShort.toUpperCase()}
                {:else}
                  {weekdayShort}
                {/if}
              </Calendar.HeadCell>
            {/each}
          </Calendar.GridRow>
        </Calendar.GridHead>
        <Calendar.GridBody>
          {#each month.weeks as weekDates}
            <Calendar.GridRow>
              {#each weekDates as date}
                <Calendar.Cell {date}>
                  <Calendar.Day {date} month={month.value} />
                </Calendar.Cell>
              {/each}
            </Calendar.GridRow>
          {/each}
        </Calendar.GridBody>
      </Calendar.Grid>
    {/each}

    <slot name="append" />
  </Calendar.Months>
</CalendarPrimitive.Root>
