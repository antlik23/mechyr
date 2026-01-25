<script lang="ts">
  import { createEventDispatcher } from 'svelte';

  import * as AlertDialog from '$lib/components/ui/alert-dialog/index.js';
  import * as m from '$paraglide/messages';

  export let open = false;
  export let cancelText = m.cancel();
  export let actionText = m.confirm();

  const dispatch = createEventDispatcher<{
    close: null;
    action: null;
  }>();

  function handleOpenChange() {
    dispatch('close');
  }

  function handleAction() {
    dispatch('action');
  }
</script>

<AlertDialog.Root onOpenChange={handleOpenChange} {open}>
  <AlertDialog.Content>
    <AlertDialog.Header>
      <AlertDialog.Title>
        <slot name="header" />
      </AlertDialog.Title>
    </AlertDialog.Header>

    <slot />

    <AlertDialog.Footer>
      <AlertDialog.Cancel>{cancelText}</AlertDialog.Cancel>

      <AlertDialog.Action on:click={handleAction}>{actionText}</AlertDialog.Action>
    </AlertDialog.Footer>
  </AlertDialog.Content>
</AlertDialog.Root>
