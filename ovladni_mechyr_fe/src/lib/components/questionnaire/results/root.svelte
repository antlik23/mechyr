<script lang="ts">
  import type { HTMLAttributes } from 'svelte/elements';
  import { cn } from '$lib/utils';

  let className: HTMLAttributes<HTMLDivElement>['class'] = undefined;
  export { className as class };
</script>

<div class={cn('grid gap-1.5', className)}>
  <slot />
</div>
