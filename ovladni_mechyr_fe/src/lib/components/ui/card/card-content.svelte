<script lang="ts">
  import type { HTMLAttributes } from 'svelte/elements';
  import { cn } from '$lib/utils.js';

  type $$Props = HTMLAttributes<HTMLDivElement>;

  let className: $$Props['class'] = undefined;
  export { className as class };
</script>

<div class={cn('p-5 pt-4 lg:p-8 lg:pt-6', className)} {...$$restProps}>
  <slot />
</div>
