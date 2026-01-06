<script lang="ts">
  import { AlertDialog as AlertDialogPrimitive } from 'bits-ui';
  import * as AlertDialog from './index.js';
  import { cn, flyAndScale } from '$lib/utils.js';

  type $$Props = AlertDialogPrimitive.ContentProps;

  let className: $$Props['class'] = undefined;
  export { className as class };
  export let transition: $$Props['transition'] = flyAndScale;
  export let transitionConfig: $$Props['transitionConfig'] = undefined;
</script>

<AlertDialog.Portal>
  <AlertDialog.Overlay class="bg-[rgba(10,10,10,0.64)]" />

  <AlertDialogPrimitive.Content
    class={cn(
      'fixed left-1/2 top-1/2 z-50 grid w-full max-w-[30rem] -translate-x-1/2 -translate-y-1/2 gap-8 border bg-background p-6 shadow-lg sm:rounded-lg md:w-full',
      className
    )}
    {transition}
    {transitionConfig}
    {...$$restProps}
  >
    <slot />
  </AlertDialogPrimitive.Content>
</AlertDialog.Portal>
