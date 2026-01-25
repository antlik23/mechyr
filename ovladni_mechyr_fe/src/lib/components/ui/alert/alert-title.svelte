<script lang="ts">
  import type { HTMLAttributes } from 'svelte/elements';
  import type { HeadingLevel } from './index.js';
  import { cn } from '$lib/utils.js';

  type $$Props = HTMLAttributes<HTMLHeadingElement> & {
    level?: HeadingLevel;
  };

  let className: $$Props['class'] = undefined;
  export { className as class };
  export let level: $$Props['level'] = 'h5';
</script>

<svelte:element
  this={level}
  class={cn('mb-1 font-medium leading-none tracking-tight', className)}
  {...$$restProps}
>
  <slot />
</svelte:element>
