<script lang="ts">
  import type { StoryLayout } from 'histoire';
  import type { Hst } from '@histoire/plugin-svelte';
  export let Hst: Hst;

  import { Calendar } from '$lib/components/ui/calendar';
  import type { ComponentProps } from 'svelte';
  import { parseDate } from '@internationalized/date';

  const layout: StoryLayout = {
    type: 'grid',
    width: '32%',
  };

  const todayDate = new Date();

  const dateIn2Days = new Date();
  dateIn2Days.setDate(todayDate.getDate() + 2);

  let state: Record<'particularTime', ComponentProps<Calendar>> = {
    particularTime: {
      value: parseDate(dateIn2Days.toISOString().slice(0, 10)),
    },
  };
</script>

<svelte:component this={Hst.Story} {layout} title="Calendar/Calendar">
  <svelte:component this={Hst.Variant} title="Current date">
    <Calendar />
  </svelte:component>

  <svelte:component this={Hst.Variant} title="Particular date">
    <Calendar {...state.particularTime} />
  </svelte:component>
</svelte:component>
