<script lang="ts">
  import type { HTMLAttributes } from 'svelte/elements';
  import { cn } from '$lib/utils';

  let className: HTMLAttributes<HTMLSpanElement>['class'] = undefined;
  export { className as class };
</script>

<span class={cn('text-sm/3.5 font-medium text-blue-dark-900', className)}>
  <slot />
</span>
