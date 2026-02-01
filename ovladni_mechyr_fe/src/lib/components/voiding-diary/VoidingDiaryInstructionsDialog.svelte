<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import * as AlertDialog from '$lib/components/ui/alert-dialog/index.js';

  export let open = false;

  const dispatch = createEventDispatcher<{
    close: null;
  }>();

  function handleOpenChange() {
    dispatch('close');
  }

  function handleContinue() {
    dispatch('close');
  }
</script>

<AlertDialog.Root onOpenChange={handleOpenChange} {open}>
  <AlertDialog.Content>
    <AlertDialog.Header>
      <AlertDialog.Title>Důležité instrukce pro vyplňování deníku</AlertDialog.Title>
    </AlertDialog.Header>

    <div class="space-y-4">
      <p class="text-base font-semibold text-destructive">
        DŮLEŽITÉ: První záznam provádějte DRUHOU ranní mikcí.
      </p>

      <p class="text-sm text-muted-foreground">
        První ranní močení po probuzení se <strong>NEPOČÍTÁ</strong> a patří k předchozímu dni.
      </p>

      <p class="text-sm text-muted-foreground">
        Začněte tedy zapisovat až od druhé mikce během dne a pokračujte pravidelně po celou dobu
        trvání deníku.
      </p>
    </div>

    <AlertDialog.Footer>
      <AlertDialog.Action on:click={handleContinue}>Rozumím, pokračovat</AlertDialog.Action>
    </AlertDialog.Footer>
  </AlertDialog.Content>
</AlertDialog.Root>
