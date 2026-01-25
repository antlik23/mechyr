<script lang="ts">
  import Ellipsis from 'lucide-svelte/icons/ellipsis';
  import type { HTMLAttributes } from 'svelte/elements';
  import { cn } from '$lib/utils.js';
  import * as m from '$paraglide/messages';

  type $$Props = HTMLAttributes<HTMLSpanElement> & {
    el?: HTMLSpanElement;
  };

  let className: $$Props['class'] = undefined;
  export { className as class };
  export let el: $$Props['el'] = undefined;
</script>

<span
  bind:this={el}
  class={cn('flex h-9 w-9 items-center justify-center', className)}
  aria-hidden="true"
  role="presentation"
  {...$$restProps}
>
  <Ellipsis class="h-4 w-4" />
  <span class="sr-only">{m.more()}</span>
</span>
