<script lang="ts">
  import type { HTMLAttributes } from 'svelte/elements';
  import { type Variant, alertVariants, type Inverted } from './index.js';
  import { cn } from '$lib/utils.js';

  type $$Props = HTMLAttributes<HTMLDivElement> & {
    variant?: Variant;
    inverted?: Inverted;
  };

  let className: $$Props['class'] = undefined;
  export { className as class };
  export let variant: $$Props['variant'] = 'default';
  export let inverted: $$Props['inverted'] = undefined;
</script>

<div class={cn(alertVariants({ variant, inverted }), className)} {...$$restProps} role="alert">
  <slot />
</div>
