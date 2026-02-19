<script lang="ts">
  import * as Tooltip from '$lib/components/ui/tooltip';
  import * as m from '$paraglide/messages';
  import { languageTag } from '$paraglide/runtime';

  export let actualDate: string | null | undefined;
  export let plannedDate: string | null | undefined;

  // Determine which date to display (actual takes priority)
  const displayDate = actualDate || plannedDate;
  const isActual = !!actualDate;

  function formatDate(dateStr: string): string {
    return new Date(dateStr).toLocaleString(languageTag(), {
      dateStyle: 'medium',
    });
  }
</script>

{#if !displayDate}
  <span>-</span>
{:else}
  <Tooltip.Root>
    <Tooltip.Trigger>
      <span class={isActual ? 'font-bold' : ''}>
        {formatDate(displayDate)}
      </span>
    </Tooltip.Trigger>
    <Tooltip.Content>
      {isActual ? m.actualVisitDate() : m.plannedVisitDate()}
    </Tooltip.Content>
  </Tooltip.Root>
{/if}
