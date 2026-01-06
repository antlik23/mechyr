<script lang="ts">
  import type { HTMLAttributes } from 'svelte/elements';
  import { cn } from '$lib/utils.js';

  type $$Props = HTMLAttributes<HTMLSpanElement> & {
    el?: HTMLSpanElement;
  };

  export let className: $$Props['class'] = undefined;
  export { className as class };
  export let el: $$Props['el'] = undefined;
</script>

<span
  bind:this={el}
  class={cn('font-normal text-foreground', className)}
  aria-current="page"
  aria-disabled="true"
  role="link"
  {...$$restProps}
>
  <slot />
</span>
