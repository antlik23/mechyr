<script lang="ts">
  import type { HTMLLiAttributes } from 'svelte/elements';
  import { cn } from '$lib/utils.js';

  type $$Props = HTMLLiAttributes & {
    el?: HTMLLIElement;
  };

  let className: $$Props['class'] = undefined;
  export { className as class };
  export let el: $$Props['el'] = undefined;
</script>

<li bind:this={el} class={cn('inline-flex items-center gap-1.5', className)}>
  <slot />
</li>
