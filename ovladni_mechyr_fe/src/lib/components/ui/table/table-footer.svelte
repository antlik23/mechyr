<script lang="ts">
  import { cn } from '$lib/utils.js';
  import type { HTMLAttributes } from 'svelte/elements';

  type $$Props = HTMLAttributes<HTMLTableSectionElement>;

  let className: $$Props['class'] = undefined;
  export { className as class };
</script>

<tfoot class={cn('bg-muted/50 font-medium text-primary-foreground', className)} {...$$restProps}>
  <slot />
</tfoot>
