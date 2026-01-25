<script lang="ts">
  import { Command as CommandPrimitive } from 'cmdk-sv';
  import { cn } from '$lib/utils.js';

  type $$Props = CommandPrimitive.ItemProps;

  export let asChild = false;

  let className: string | undefined | null = undefined;
  export { className as class };
</script>

<CommandPrimitive.Item
  class={cn(
    'relative flex cursor-pointer select-none items-center rounded-lg px-2 py-1.5 text-sm font-medium leading-5 text-slate-700 outline-none',
    // Hover.
    'hover:bg-blue-200',
    // Selected.
    'aria-selected:bg-accent aria-selected:text-accent-foreground data-[selected]:bg-blue-200',
    // Disabled.
    'data-[disabled]:pointer-events-none data-[disabled]:opacity-50',
    className
  )}
  {asChild}
  {...$$restProps}
  let:action
  let:attrs
>
  <slot {action} {attrs} />
</CommandPrimitive.Item>
