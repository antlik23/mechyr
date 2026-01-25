<script lang="ts">
  import { Avatar as AvatarPrimitive } from 'bits-ui';
  import { cn } from '$lib/utils.js';

  type $$Props = AvatarPrimitive.Props;

  let className: $$Props['class'] = undefined;
  export let delayMs: $$Props['delayMs'] = undefined;
  export { className as class };
</script>

<AvatarPrimitive.Root
  class={cn(
    'relative grid aspect-square size-10 shrink-0 place-items-center overflow-hidden rounded-full has-[[data-avatar-fallback]]:bg-blue-200',
    className
  )}
  {delayMs}
  {...$$restProps}
>
  <slot />
</AvatarPrimitive.Root>
