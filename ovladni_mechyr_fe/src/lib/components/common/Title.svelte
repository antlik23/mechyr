<script context="module" lang="ts">
  import { tv } from 'tailwind-variants';

  export const titleVariants = tv({
    base: cn('text-primary font-extrabold uppercase uzis-title'),
    variants: {
      level: {
        h1: 'text-4xl',
        h2: 'text-lg',
        h3: 'text-2xl',
        h4: 'text-xl',
        h5: '',
        h6: '',
      },
    },
    defaultVariants: {
      level: 'h1',
    },
  });
</script>

<script lang="ts">
  import type { HTMLAttributes } from 'svelte/elements';
  import { type VariantProps } from 'tailwind-variants';
  import { cn } from '$lib/utils';
  import Meta from '$lib/components/common/Meta.svelte';

  let className: HTMLAttributes<HTMLHeadingElement>['class'] = undefined;
  export { className as class };
  export let text: string;
  export let level: VariantProps<typeof titleVariants>['level'] = 'h1';
  export let includeMeta = false;
  export let containerClasses: string | undefined = undefined;
</script>

{#if includeMeta}
  <Meta title={text} />
{/if}

<div class={cn('flex flex-wrap items-center gap-4', containerClasses)}>
  <svelte:element this={level} class={cn(titleVariants({ level }), className)}>
    {text}
  </svelte:element>

  <slot />
</div>
