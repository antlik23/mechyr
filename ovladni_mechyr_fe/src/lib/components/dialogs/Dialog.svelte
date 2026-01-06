<script lang="ts">
  import { createEventDispatcher } from 'svelte';

  import * as Dialog from '$lib/components/ui/dialog/index.js';

  export let open = false;

  const dispatch = createEventDispatcher<{
    close: null;
  }>();

  function handleOpenChange() {
    dispatch('close');
  }
</script>

<Dialog.Root onOpenChange={handleOpenChange} {open}>
  <Dialog.Content>
    {#if $$slots.header}
      <Dialog.Header>
        <Dialog.Title>
          <slot name="header" />
        </Dialog.Title>
      </Dialog.Header>
    {/if}
    <slot />
    {#if $$slots.footer}
      <Dialog.Footer>
        <slot name="footer" />
      </Dialog.Footer>
    {/if}
  </Dialog.Content>
</Dialog.Root>
