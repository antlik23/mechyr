<script lang="ts">
  import { createEventDispatcher, onMount, tick } from 'svelte';
  import { cn } from '$lib/utils';
  import ScrollArea from '$lib/components/ui/scroll-area/scroll-area.svelte';
  import Button from '$lib/components/common/Button.svelte';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import * as m from '$paraglide/messages';

  const date = new Date();
  const hoursNow = date.getHours();
  const minutesNow = date.getMinutes();
  export let hourValue: number | undefined = hoursNow;
  export let minuteValue: number | undefined = minutesNow;

  const dispatch = createEventDispatcher<{
    valueChange: {
      hour: number;
      minute: number;
    };
  }>();

  const timeUnits = [
    { type: 'hours', values: Array.from({ length: 24 }, (_, index) => index) },
    { type: 'minutes', values: Array.from({ length: 60 }, (_, index) => index) },
  ] as const;

  const scrollElements = { hours: {}, minutes: {} } as Record<
    (typeof timeUnits)[number]['type'],
    { scrollArea: HTMLDivElement; scrollItem: HTMLDivElement }
  >;

  onMount(async () => {
    // Wait for all updates to be done.
    await Promise.all([await tick(), await new Promise((r) => setTimeout(r, 0))]);

    // Scroll to selected or current hour / minute.
    for (const key of Object.keys(scrollElements) as (keyof typeof scrollElements)[]) {
      let timeIndex: number;
      if (key === 'hours') {
        timeIndex = hourValue ?? hoursNow;
      } else {
        timeIndex = minuteValue ?? minutesNow;
      }

      // Centering.
      timeIndex -= timeIndex === 1 ? 1 : 3;

      // Position where to scroll in pixels.
      const topOffset = scrollElements[key].scrollItem.offsetHeight * timeIndex;

      scrollElements[key].scrollArea.scrollTop = topOffset;
    }
  });

  function handleClick(type: (typeof timeUnits)[number]['type'], value: number) {
    if (type === 'hours') {
      hourValue = value;
    } else {
      minuteValue = value;
    }

    dispatch('valueChange', {
      hour: hourValue ?? 0,
      minute: minuteValue ?? 0,
    });
  }
</script>

<div class={cn('rounded-md bg-white p-4', columnsVariants({ number: 0, gap: 4 }))}>
  <div class={cn(columnsVariants({ gap: 4 }), 'grid-cols-2')}>
    {#each timeUnits as timeUnit}
      <ScrollArea
        class="h-[15.75rem]"
        scrollbarYClasses="hidden"
        viewportClasses="snap-y snap-mandatory"
        bind:viewportEl={scrollElements[timeUnit.type].scrollArea}
      >
        {#each timeUnit.values as timeValue}
          {@const isSelected =
            timeUnit.type === 'hours' ? timeValue === hourValue : timeValue === minuteValue}

          <div bind:this={scrollElements[timeUnit.type].scrollItem}>
            <Button
              class="w-full snap-start font-normal"
              data-selected={isSelected || null}
              size="sm"
              variant={isSelected ? 'default' : 'ghost'}
              on:click={() => handleClick(timeUnit.type, timeValue)}
            >
              {#if timeUnit.type === 'hours'}
                {m.hours({ hoursAmount: timeValue })}
              {:else}
                {m.minutes({ minutesAmount: timeValue })}
              {/if}
            </Button>
          </div>
        {/each}
      </ScrollArea>
    {/each}
  </div>

  <slot name="append" />
</div>
