<script lang="ts">
  import * as Sheet from '$lib/components/ui/sheet';
  import { cn } from '$lib/utils';

  export let open: boolean;
  export let title: string;
  export let contentClasses: string | undefined = undefined;
  export let headerClasses: string | undefined = undefined;
  export let titleClasses: string | undefined = undefined;
</script>

<Sheet.Root bind:open>
  <Sheet.Content class={cn('flex flex-col gap-8', contentClasses)}>
    <Sheet.Header class={headerClasses}>
      <Sheet.Title class={titleClasses}>{title}</Sheet.Title>
      <Sheet.Description>
        <slot name="description" />
      </Sheet.Description>

      <slot name="header" />
    </Sheet.Header>
    <slot />

    {#if $$slots.footer}
      <Sheet.Footer>
        <slot name="footer" />
      </Sheet.Footer>
    {/if}
  </Sheet.Content>
</Sheet.Root>
