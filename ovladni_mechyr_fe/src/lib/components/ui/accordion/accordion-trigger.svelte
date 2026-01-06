<script lang="ts">
  import { Accordion as AccordionPrimitive } from 'bits-ui';
  import ChevronDown from 'lucide-svelte/icons/chevron-down';
  import { cn } from '$lib/utils.js';

  type $$Props = AccordionPrimitive.TriggerProps & {
    level?: AccordionPrimitive.HeaderProps['level'];
  };
  type $$Events = AccordionPrimitive.TriggerEvents;

  let className: $$Props['class'] = undefined;
  export { className as class };
  export let level: $$Props['level'] = 3;
</script>

<AccordionPrimitive.Header class="flex" {level}>
  <AccordionPrimitive.Trigger
    class={cn(
      'flex flex-1 items-center justify-between gap-2 py-4 text-left font-medium transition-all hover:underline [&[data-state=open]>svg]:rotate-180',
      className
    )}
    {...$$restProps}
    on:click
  >
    <slot />
    <ChevronDown class="h-4 w-4 flex-shrink-0 transition-transform duration-200" />
  </AccordionPrimitive.Trigger>
</AccordionPrimitive.Header>
