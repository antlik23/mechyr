<script lang="ts">
  import { Command as CommandPrimitive } from 'cmdk-sv';
  import MagnifierIcon from '$lib/assets/icons/magnifier.svg?component';
  import { cn } from '$lib/utils.js';

  type $$Props = CommandPrimitive.InputProps;

  let className: string | undefined | null = undefined;
  export { className as class };
  export let value: string = '';
</script>

<div class="flex items-center border-b border-slate-100 px-4" data-cmdk-input-wrapper="">
  <CommandPrimitive.Input
    class={cn(
      'flex h-11 w-full rounded-md py-3 text-sm outline-none placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50',
      className
    )}
    {...$$restProps}
    bind:value
    on:input
  />
  <MagnifierIcon class="shrink-0 opacity-50" />
</div>
