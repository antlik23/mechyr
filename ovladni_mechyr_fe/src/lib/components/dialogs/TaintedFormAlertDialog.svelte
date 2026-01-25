<script lang="ts">
  import type { ComponentProps } from 'svelte';
  import { progressBar } from '$lib/stores/progressBar';
  import AlertDialog from '$lib/components/dialogs/AlertDialog.svelte';
  import * as m from '$paraglide/messages.js';

  export const taintedMessage = async () => {
    open = true;
    const shouldLeave = await promise;

    ({ promise, resolve } = Promise.withResolvers<boolean>());

    return shouldLeave;
  };

  export let headerText = m.reallyLeaveThisPage();
  export let descriptionText = m.youLoseChanges();
  export let actionText = m.yes();
  export let cancelText: ComponentProps<AlertDialog>['cancelText'] = undefined;

  let open = false;

  let { promise, resolve } = Promise.withResolvers<boolean>();

  function handleAlertDialogAction() {
    open = false;
    resolve(true);
  }

  function handleAlertDialogClose() {
    open = false;
    resolve(false);
    $progressBar?.complete();
  }
</script>

<AlertDialog
  {actionText}
  {cancelText}
  {open}
  on:action={handleAlertDialogAction}
  on:close={handleAlertDialogClose}
>
  <slot slot="header">{headerText}</slot>

  <slot><p>{descriptionText}</p></slot>
</AlertDialog>
