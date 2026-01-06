<script lang="ts">
  import { Pagination as PaginationPrimitive } from 'bits-ui';
  import ChevronRight from 'lucide-svelte/icons/chevron-right';
  import { cn } from '$lib/utils.js';
  import { Button } from '../button';
  import * as m from '$paraglide/messages';

  type $$Props = PaginationPrimitive.NextButtonProps;

  type $$Events = PaginationPrimitive.NextButtonEvents;

  let className: $$Props['class'] = undefined;
  export { className as class };
</script>

<PaginationPrimitive.NextButton asChild let:builder>
  <Button
    class={cn('gap-1 pr-2.5', className)}
    builders={[builder]}
    variant="ghost"
    on:click
    {...$$restProps}
  >
    <slot>
      <span class="sr-only lg:not-sr-only">{m.next()}</span>
      <ChevronRight class="h-4 w-4" />
    </slot>
  </Button>
</PaginationPrimitive.NextButton>
