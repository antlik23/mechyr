<script lang="ts">
  import { type Variant, badgeVariants } from './index.js';
  import { cn } from '$lib/utils.js';

  let className: string | undefined | null = undefined;
  export { className as class };
  export let href: string | undefined = undefined;
  export let variant: Variant = 'default';
</script>

<svelte:element
  this={href ? 'a' : 'span'}
  class={cn(badgeVariants({ variant, className }))}
  {href}
  {...$$restProps}
>
  <slot />
</svelte:element>
