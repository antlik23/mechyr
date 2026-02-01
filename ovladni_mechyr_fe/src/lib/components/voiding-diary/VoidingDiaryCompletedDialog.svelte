<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import * as AlertDialog from '$lib/components/ui/alert-dialog/index.js';
  import Button from '$lib/components/common/Button.svelte';

  export let open = false;
  export let canSelectDoctor = false;

  const dispatch = createEventDispatcher<{
    close: null;
    selectDoctor: null;
  }>();

  function handleOpenChange() {
    dispatch('close');
  }

  function handleSelectDoctor() {
    dispatch('selectDoctor');
    dispatch('close');
  }

  function handleClose() {
    dispatch('close');
  }
</script>

<AlertDialog.Root onOpenChange={handleOpenChange} {open}>
  <AlertDialog.Content>
    <AlertDialog.Header>
      <AlertDialog.Title>Gratulujeme! Deník byl úspěšně dokončen</AlertDialog.Title>
    </AlertDialog.Header>

    <div class="space-y-4">
      <p class="text-base">
        Výborně! Dokončili jste vyplňování mikčního deníku. Vaše záznamy byly uloženy a jsou
        připraveny k vyhodnocení.
      </p>

      {#if canSelectDoctor}
        <p class="text-sm text-muted-foreground">
          Nyní můžete pokračovat výběrem lékaře, který bude vaše záznamy vyhodnocovat a poskytne vám
          odbornou péči.
        </p>
      {:else}
        <p class="text-sm text-muted-foreground">
          Pro výběr lékaře je nejprve nutné dokončit všechny povinné dotazníky.
        </p>
      {/if}
    </div>

    <AlertDialog.Footer class="gap-2">
      <AlertDialog.Cancel on:click={handleClose}>Zavřít</AlertDialog.Cancel>

      {#if canSelectDoctor}
        <Button on:click={handleSelectDoctor}>Vybrat lékaře</Button>
      {/if}
    </AlertDialog.Footer>
  </AlertDialog.Content>
</AlertDialog.Root>
