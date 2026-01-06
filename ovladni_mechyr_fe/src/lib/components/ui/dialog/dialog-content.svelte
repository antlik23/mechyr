<script lang="ts">
  import { Dialog as DialogPrimitive } from 'bits-ui';
  import * as Dialog from './index.js';
  import { cn, flyAndScale } from '$lib/utils.js';

  import Icon from '$lib/components/wrappers/Icon.svelte';
  import CrossIcon from '$lib/assets/icons/cross.svg?component';

  import * as m from '$paraglide/messages';

  type $$Props = DialogPrimitive.ContentProps;

  let className: $$Props['class'] = undefined;
  export let transition: $$Props['transition'] = flyAndScale;
  export let transitionConfig: $$Props['transitionConfig'] = {
    duration: 200,
  };
  export { className as class };
</script>

<Dialog.Portal>
  <Dialog.Overlay class="bg-[rgba(10,10,10,0.64)]" />
  <DialogPrimitive.Content
    class={cn(
      'fixed left-1/2 top-1/2 z-50 grid max-h-[calc(100dvh-4rem)] w-full max-w-[30rem] -translate-x-1/2 -translate-y-1/2 gap-8 overflow-auto border bg-background p-6 shadow-lg sm:rounded-lg md:w-full',
      className
    )}
    {transition}
    {transitionConfig}
    {...$$restProps}
  >
    <slot />

    <DialogPrimitive.Close
      class="absolute end-0.5 top-0.5 size-11 rounded-lg ring-offset-background transition-colors hover:bg-gray-200 focus:outline-none focus-visible:ring-2 focus-visible:ring-ring disabled:pointer-events-none"
    >
      <Icon height="0.875rem" icon={CrossIcon} width="0.875rem" />

      <span class="sr-only">{m.close()}</span>
    </DialogPrimitive.Close>
  </DialogPrimitive.Content>
</Dialog.Portal>
