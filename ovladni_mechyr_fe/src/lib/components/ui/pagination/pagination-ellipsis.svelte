<script lang="ts">
  import Ellipsis from 'lucide-svelte/icons/ellipsis';
  import type { HTMLAttributes } from 'svelte/elements';
  import { cn } from '$lib/utils.js';
  import * as m from '$paraglide/messages';

  type $$Props = HTMLAttributes<HTMLSpanElement>;

  let className: $$Props['class'] = undefined;
  export { className as class };
</script>

<span
  class={cn('flex h-10 w-10 items-center justify-center', className)}
  aria-hidden
  {...$$restProps}
>
  <Ellipsis class="h-4 w-4" />
  <span class="sr-only">{m.morePages()}</span>
</span>
