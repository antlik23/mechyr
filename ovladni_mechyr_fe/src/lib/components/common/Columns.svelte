<script context="module" lang="ts">
  export const columnsVariants = tv({
    base: 'grid-cols-1 gap-2',
    variants: {
      useGrid: {
        true: 'grid',
        false: 'flex flex-col',
      },
      number: {
        0: 'grid-cols-none',
        1: '',
        2: 'xl:grid-cols-2',
        3: 'xl:grid-cols-3',
        4: 'xl:grid-cols-4',
      },
      gap: {
        0: 'gap-0',
        0.5: 'gap-0.5',
        2: '',
        4: 'lg:gap-4',
        5: 'sm:gap-3 lg:gap-5',
        6: 'sm:gap-3 lg:gap-6',
        8: 'sm:gap-3 md:gap-5 lg:gap-8',
      },
      verticalAlign: {
        start: 'items-start',
        center: 'items-center',
      },
      horizontalAlign: {
        center: 'justify-center',
      },
      useSpacing: {
        true: 'gap-0 space-y-2 sm:gap-0 md:gap-0 lg:gap-0',
        false: '',
      },
    },
    defaultVariants: {
      gap: 4,
      useGrid: true,
    },
    compoundVariants: [
      {
        useSpacing: true,
        gap: 0,
        class: 'space-y-0',
      },
      {
        useSpacing: true,
        gap: 4,
        class: 'lg:space-y-4',
      },
      {
        useSpacing: true,
        gap: 5,
        class: 'sm:space-y-3 lg:space-y-5',
      },
      {
        useSpacing: true,
        gap: 6,
        class: 'sm:space-y-3 lg:space-y-6',
      },
      {
        useSpacing: true,
        gap: 8,
        class: 'sm:space-y-3 md:space-y-5 lg:space-y-8',
      },
    ],
  });
</script>

<script lang="ts">
  import type { HTMLAttributes } from 'svelte/elements';
  import { tv, type VariantProps } from 'tailwind-variants';
  import { cn } from '$lib/utils';

  type $$Props = {
    class?: HTMLAttributes<HTMLDivElement>['class'];
    number: Exclude<VariantProps<typeof columnsVariants>['number'], undefined>;
    gap?: VariantProps<typeof columnsVariants>['gap'];
    verticalAlign?: VariantProps<typeof columnsVariants>['verticalAlign'];
    horizontalAlign?: VariantProps<typeof columnsVariants>['horizontalAlign'];
  };

  let className: $$Props['class'] = undefined;
  export { className as class };
  export let number: $$Props['number'];
  export let gap: $$Props['gap'] = undefined;
  export let verticalAlign: $$Props['verticalAlign'] = undefined;
  export let horizontalAlign: $$Props['horizontalAlign'] = undefined;
</script>

<div class={cn(columnsVariants({ number, gap, verticalAlign, horizontalAlign }), className)}>
  <slot />
</div>
