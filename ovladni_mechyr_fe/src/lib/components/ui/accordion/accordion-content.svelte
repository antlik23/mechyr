<script lang="ts">
  import type { HTMLAttributes } from 'svelte/elements';
  import { Accordion as AccordionPrimitive } from 'bits-ui';
  import { slide } from 'svelte/transition';
  import { cn } from '$lib/utils.js';

  type $$Props = AccordionPrimitive.ContentProps & {
    innerContainerClasses?: HTMLAttributes<HTMLDivElement>['class'];
  };

  let className: $$Props['class'] = undefined;
  export { className as class };
  export let transition: $$Props['transition'] = slide;
  export let transitionConfig: $$Props['transitionConfig'] = {
    duration: 200,
  };
  export let innerContainerClasses: $$Props['innerContainerClasses'] = undefined;
</script>

<AccordionPrimitive.Content
  class={cn('overflow-hidden text-sm transition-all', className)}
  {transition}
  {transitionConfig}
  {...$$restProps}
>
  <div class={cn('pb-4 pt-0', innerContainerClasses)}>
    <slot />
  </div>
</AccordionPrimitive.Content>
