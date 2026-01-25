<script lang="ts">
  import AlertDialog from '$lib/components/dialogs/AlertDialog.svelte';
  import * as m from '$paraglide/messages';

  export let open: boolean;
  export let onConfirm: () => void;
  export let onCancel: () => void;
</script>

<AlertDialog
  actionText={m.yes()}
  cancelText={m.cancel()}
  {open}
  on:action={onConfirm}
  on:close={onCancel}
>
  <slot slot="header">Opravdu si přejete ukončit mikční deník?</slot>
  <slot><p>Po ukončení již nebude možné mikční deník upravovat.</p></slot>
</AlertDialog>
