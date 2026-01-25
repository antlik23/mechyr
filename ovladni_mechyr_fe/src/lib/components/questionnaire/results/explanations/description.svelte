<script lang="ts">
  import type { HTMLAttributes } from 'svelte/elements';
  import { cn } from '$lib/utils';

  let className: HTMLAttributes<HTMLParagraphElement>['class'] = undefined;
  export { className as class };
</script>

<p class={cn('text-sm font-medium text-muted-foreground', className)}>
  <slot />
</p>

{#if $$slots.error}
  <p class="text-md font-semibold text-red-500">
    <slot name="error" />
  </p>
{/if}
