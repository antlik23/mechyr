<script lang="ts">
  import type { HTMLAttributes } from 'svelte/elements';
  import { cn } from '$lib/utils';

  let className: HTMLAttributes<HTMLDivElement>['class'] = undefined;
  export let title: string | undefined = undefined;
  export { className as class };
</script>

<div class={cn('flex flex-col gap-4 rounded-lg bg-gray-100 p-6', className)}>
  {#if title}
    <h2 class="text-xl font-medium">{title}</h2>
  {/if}

  <slot />
</div>
