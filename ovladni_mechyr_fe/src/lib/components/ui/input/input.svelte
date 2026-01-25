<script lang="ts">
  import type { HTMLInputAttributes } from 'svelte/elements';
  import type { InputEvents } from './index.js';
  import { cn } from '$lib/utils.js';

  type $$Props = HTMLInputAttributes;

  type $$Events = InputEvents;

  let className: $$Props['class'] = undefined;
  export { className as class };
  export let value: $$Props['value'] = undefined;
  export let readonly: $$Props['readonly'] = undefined;
  export let type: $$Props['type'] = 'text';
</script>

<input
  class={cn(
    'flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 aria-[invalid]:border-destructive',
    className
  )}
  {readonly}
  {...{ type }}
  step={type === 'number' ? 'any' : undefined}
  bind:value
  on:blur
  on:change
  on:click
  on:focus
  on:focusin
  on:focusout
  on:keydown
  on:keypress
  on:keyup
  on:mouseover
  on:mouseenter
  on:mouseleave
  on:mousemove
  on:paste
  on:input
  on:wheel|passive
  {...$$restProps}
/>
