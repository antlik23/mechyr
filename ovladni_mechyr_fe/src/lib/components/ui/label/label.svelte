<script context="module" lang="ts">
  export const labelVariants = tv({
    base: 'text-pretty text-base font-medium text-grays-900 peer-disabled:cursor-not-allowed peer-disabled:opacity-70 peer-[[role="checkbox"]:disabled]:cursor-not-allowed peer-[[role="checkbox"]]:cursor-pointer peer-[[role="radio"]:disabled]:cursor-not-allowed peer-[[role="radio"]]:cursor-pointer peer-[[role="checkbox"]]:text-sm/3.5 peer-[[role="radio"]]:text-sm/3.5 lg:text-lg [fieldset>legend&]:font-semibold',
    variants: {
      afterInput: {
        true: 'peer-[[role="checkbox"]]:pl-2 peer-[[role="radio"]]:pl-2',
        false: 'peer-[[role="checkbox"]]:pr-2 peer-[[role="radio"]]:pr-2',
      },
    },
    defaultVariants: {
      afterInput: true,
    },
  });
</script>

<script lang="ts">
  import { Label as LabelPrimitive } from 'bits-ui';
  import { cn } from '$lib/utils.js';
  import { tv, type VariantProps } from 'tailwind-variants';

  type $$Props = LabelPrimitive.Props & {
    afterInput?: VariantProps<typeof labelVariants>['afterInput'];
  };

  type $$Events = LabelPrimitive.Events;

  let className: $$Props['class'] = undefined;
  export { className as class };
  export let afterInput: $$Props['afterInput'] = undefined;
</script>

<LabelPrimitive.Root
  class={cn(labelVariants({ afterInput }), className)}
  {...$$restProps}
  on:mousedown
>
  <slot />
</LabelPrimitive.Root>
