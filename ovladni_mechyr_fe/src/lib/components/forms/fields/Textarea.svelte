<script lang="ts">
  import { type ComponentProps } from 'svelte';
  import { cn } from '$lib/utils.js';
  import { Textarea } from '$lib/components/ui/textarea';

  type $$Props = ComponentProps<Textarea>;

  let className: $$Props['class'] = undefined;
  export { className as class };
  export let value: $$Props['value'] = undefined;
  export let disabled: $$Props['disabled'] = false;
</script>

<div class="relative flex items-center">
  <Textarea
    class={cn('min-h-[6.125rem] py-3', className)}
    {disabled}
    {...$$restProps}
    bind:value
    on:blur
    on:change
    on:click
    on:focus
    on:keydown
    on:keypress
    on:keyup
    on:mouseover
    on:mouseenter
    on:mouseleave
    on:paste
    on:input
  />
</div>
