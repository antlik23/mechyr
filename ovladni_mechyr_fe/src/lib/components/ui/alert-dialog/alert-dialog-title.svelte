<script lang="ts">
  import { AlertDialog as AlertDialogPrimitive } from 'bits-ui';
  import { cn } from '$lib/utils.js';

  type $$Props = AlertDialogPrimitive.TitleProps;

  let className: $$Props['class'] = undefined;
  export { className as class };
  export let level: $$Props['level'] = 'h2';
</script>

<AlertDialogPrimitive.Title
  class={cn('text-2xl font-medium leading-none tracking-tight', className)}
  {level}
  {...$$restProps}
>
  <slot />
</AlertDialogPrimitive.Title>
