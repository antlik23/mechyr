<script context="module" lang="ts">
  import { tv } from 'tailwind-variants';

  export const requiredIndicatorVariants = tv({
    base: 'text-destructive',
  });
</script>

<script lang="ts">
  import type { HTMLAttributes } from 'svelte/elements';
  import { cn } from '$lib/utils';

  let className: HTMLAttributes<HTMLSpanElement>['class'] = undefined;
  export { className as class };
</script>

<span class={cn(requiredIndicatorVariants(), className)}>
  <slot>*</slot>
</span>
