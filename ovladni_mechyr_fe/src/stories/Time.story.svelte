<script lang="ts">
  import type { StoryLayout } from 'histoire';
  import type { Hst } from '@histoire/plugin-svelte';
  import { logEvent } from 'histoire/client';
  export let Hst: Hst;

  import Time from '$lib/components/time/Time.svelte';
  import type { ComponentEvents, ComponentProps } from 'svelte';

  const layout: StoryLayout = {
    type: 'grid',
    width: '32%',
  };

  let state: Record<'particularTime', ComponentProps<Time>> = {
    particularTime: {
      hourValue: 13,
      minuteValue: 45,
    },
  };

  function handleValueChange(event: ComponentEvents<Time>['valueChange']) {
    logEvent('valueChange', event.detail);
  }
</script>

<svelte:component this={Hst.Story} {layout} title="Time/Time">
  <svelte:component this={Hst.Variant} title="Current time">
    <Time on:valueChange={handleValueChange} />
  </svelte:component>

  <svelte:component this={Hst.Variant} title="Particular time">
    <svelte:fragment slot="controls">
      <svelte:component
        this={Hst.Number}
        title="Hour"
        bind:value={state.particularTime.hourValue}
      />
      <svelte:component
        this={Hst.Number}
        title="Minute"
        bind:value={state.particularTime.minuteValue}
      />
    </svelte:fragment>

    <Time {...state.particularTime} on:valueChange={handleValueChange} />
  </svelte:component>
</svelte:component>
