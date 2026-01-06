<script lang="ts">
  import type { ComponentProps } from 'svelte';
  import * as m from '$paraglide/messages';
  import * as Tooltip from '$lib/components/ui/tooltip';
  import TableBold from './TableBold.svelte';
  import { InfoIcon } from 'lucide-svelte';

  export let text: ComponentProps<TableBold>['text'];
  export let textClasses: ComponentProps<TableBold>['class'] = undefined;
  export let tooltipText: string;
</script>

<div class="flex items-center justify-between gap-2">
  {#if text}
    <TableBold class={textClasses} {text} />
  {/if}

  <Tooltip.Root openDelay={100}>
    <Tooltip.Trigger class="text-blue-dark-900" aria-label={m.informations()}>
      <InfoIcon class="size-4" strokeWidth={3} />
    </Tooltip.Trigger>
    <Tooltip.Content class="max-w-prose">
      <p>{tooltipText}</p>
    </Tooltip.Content>
  </Tooltip.Root>
</div>
