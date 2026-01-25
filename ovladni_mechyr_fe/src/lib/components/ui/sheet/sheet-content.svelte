<script lang="ts">
  import { Dialog as SheetPrimitive } from 'bits-ui';
  import X from 'lucide-svelte/icons/x';
  import { fly } from 'svelte/transition';
  import {
    SheetOverlay,
    SheetPortal,
    type Side,
    sheetTransitions,
    sheetVariants,
  } from './index.js';
  import { cn } from '$lib/utils.js';
  import * as m from '$paraglide/messages';

  type $$Props = SheetPrimitive.ContentProps & {
    side?: Side;
  };

  let className: $$Props['class'] = undefined;
  export let side: $$Props['side'] = 'right';
  export { className as class };
  export let inTransition: $$Props['inTransition'] = fly;
  export let inTransitionConfig: $$Props['inTransitionConfig'] =
    sheetTransitions[side ?? 'right'].in;
  export let outTransition: $$Props['outTransition'] = fly;
  export let outTransitionConfig: $$Props['outTransitionConfig'] =
    sheetTransitions[side ?? 'right'].out;
</script>

<SheetPortal>
  <SheetOverlay />
  <SheetPrimitive.Content
    class={cn(sheetVariants({ side }), className)}
    {inTransition}
    {inTransitionConfig}
    {outTransition}
    {outTransitionConfig}
    {...$$restProps}
  >
    <slot />
    <SheetPrimitive.Close
      class="absolute right-2 top-2 rounded-sm p-2 ring-offset-background transition-colors hover:bg-blue-50 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none data-[state=open]:bg-secondary"
    >
      <X class="size-6" />

      <span class="sr-only">{m.close()}</span>
    </SheetPrimitive.Close>
  </SheetPrimitive.Content>
</SheetPortal>
