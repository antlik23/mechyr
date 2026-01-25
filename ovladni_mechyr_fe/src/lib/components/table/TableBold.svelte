<script lang="ts">
  import type { HTMLAttributes } from 'svelte/elements';
  import { cn } from '$lib/utils';

  let className: HTMLAttributes<HTMLDivElement>['class'] = undefined;
  export { className as class };
  export let text: string;
</script>

<span class={cn('font-bold text-foreground', className)}>{text}</span>

<slot />
