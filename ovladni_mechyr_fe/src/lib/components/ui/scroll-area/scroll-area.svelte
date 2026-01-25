<script lang="ts">
  import { ScrollArea as ScrollAreaPrimitive } from 'bits-ui';
  import { cn } from '$lib/utils.js';
  import { Scrollbar } from './index.js';

  type $$Props = ScrollAreaPrimitive.Props & {
    orientation?: 'vertical' | 'horizontal' | 'both';
    scrollbarXClasses?: string;
    scrollbarYClasses?: string;
    viewportClasses?: string;
    viewportEl?: HTMLDivElement;
  };

  let className: $$Props['class'] = undefined;
  export { className as class };
  export let type: $$Props['type'] = 'auto';
  export let orientation = 'vertical';
  export let scrollbarXClasses: string = '';
  export let scrollbarYClasses: string = '';
  export let viewportClasses: $$Props['viewportClasses'] = '';
  export let viewportEl: $$Props['viewportEl'] = undefined;
</script>

<ScrollAreaPrimitive.Root {type} {...$$restProps} class={cn('relative overflow-hidden', className)}>
  <ScrollAreaPrimitive.Viewport
    class={cn('h-full max-h-[inherit] w-full rounded-[inherit]', viewportClasses)}
    bind:el={viewportEl}
  >
    <ScrollAreaPrimitive.Content class="w-full table-fixed">
      <slot />
    </ScrollAreaPrimitive.Content>
  </ScrollAreaPrimitive.Viewport>
  {#if orientation === 'vertical' || orientation === 'both'}
    <Scrollbar class={scrollbarYClasses} orientation="vertical" />
  {/if}
  {#if orientation === 'horizontal' || orientation === 'both'}
    <Scrollbar class={scrollbarXClasses} orientation="horizontal" />
  {/if}
  <ScrollAreaPrimitive.Corner />
</ScrollAreaPrimitive.Root>
