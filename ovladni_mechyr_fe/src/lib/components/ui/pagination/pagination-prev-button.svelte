<script lang="ts">
  import { Pagination as PaginationPrimitive } from 'bits-ui';
  import ChevronLeft from 'lucide-svelte/icons/chevron-left';
  import { cn } from '$lib/utils.js';
  import { Button } from '../button';
  import * as m from '$paraglide/messages';

  type $$Props = PaginationPrimitive.PrevButtonProps;

  type $$Events = PaginationPrimitive.PrevButtonEvents;

  let className: $$Props['class'] = undefined;
  export { className as class };
</script>

<PaginationPrimitive.PrevButton asChild let:builder>
  <Button
    class={cn('gap-1 pl-2.5', className)}
    builders={[builder]}
    variant="ghost"
    on:click
    {...$$restProps}
  >
    <slot>
      <ChevronLeft class="h-4 w-4" />
      <span class="sr-only lg:not-sr-only">{m.previous()}</span>
    </slot>
  </Button>
</PaginationPrimitive.PrevButton>
