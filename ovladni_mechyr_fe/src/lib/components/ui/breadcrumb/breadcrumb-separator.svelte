<script lang="ts">
  import type { HTMLLiAttributes } from 'svelte/elements';
  import ChevronRight from 'lucide-svelte/icons/chevron-right';
  import { cn } from '$lib/utils.js';

  type $$Props = HTMLLiAttributes & {
    el?: HTMLLIElement;
  };

  let className: $$Props['class'] = undefined;
  export { className as class };
  export let el: $$Props['el'] = undefined;
</script>

<li
  bind:this={el}
  class={cn('[&>svg]:size-3.5', className)}
  aria-hidden="true"
  role="presentation"
  {...$$restProps}
>
  <slot>
    <ChevronRight />
  </slot>
</li>
