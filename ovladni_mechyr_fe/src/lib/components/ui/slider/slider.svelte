<script lang="ts">
  import { Slider as SliderPrimitive } from 'bits-ui';
  import { cn } from '$lib/utils.js';

  type $$Props = SliderPrimitive.Props;

  let className: $$Props['class'] = undefined;
  export { className as class };
  export let value: $$Props['value'] = [0];
  export let disabled: $$Props['disabled'] = undefined;
</script>

<SliderPrimitive.Root
  class={cn('relative flex w-full touch-none select-none items-center pt-7', className)}
  {disabled}
  bind:value
  {...$$restProps}
  let:thumbs
>
  <span
    class={cn(
      'relative h-2 w-full grow cursor-pointer overflow-hidden rounded-full bg-secondary',
      disabled && 'cursor-not-allowed'
    )}
  >
    <SliderPrimitive.Range class="absolute h-full bg-primary" />
  </span>

  {#each thumbs as thumb (thumb)}
    <SliderPrimitive.Thumb asChild {thumb} let:builder>
      <span
        {...builder}
        class={cn(
          'block h-5 w-5 cursor-e-resize rounded-full border-2 border-primary bg-background ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50',
          disabled && 'cursor-not-allowed bg-muted'
        )}
        use:builder.action
      >
        <span class={cn('absolute -top-7 flex w-full justify-center', disabled && 'opacity-50')}>
          {thumb['data-value']}
        </span>
      </span>
    </SliderPrimitive.Thumb>
  {/each}

  <slot name="append" />
</SliderPrimitive.Root>
