<script lang="ts">
  import { Avatar as AvatarPrimitive } from 'bits-ui';
  import { cn } from '$lib/utils.js';

  type $$Props = AvatarPrimitive.FallbackProps;

  let className: $$Props['class'] = undefined;
  export { className as class };
</script>

<AvatarPrimitive.Fallback class={cn('leading-none text-blue-700', className)} {...$$restProps}>
  <slot />
</AvatarPrimitive.Fallback>
