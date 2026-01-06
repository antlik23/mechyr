<script lang="ts">
  import { AlertDialog as AlertDialogPrimitive } from 'bits-ui';
  import Button from '$lib/components/common/Button.svelte';

  type $$Props = AlertDialogPrimitive.CancelProps;

  type $$Events = AlertDialogPrimitive.CancelEvents;

  let className: $$Props['class'] = undefined;
  export { className as class };
</script>

<AlertDialogPrimitive.Cancel {...$$restProps} let:builder>
  <Button class={className} builders={[builder]} variant="outline" on:click on:keydown>
    <slot />
  </Button>
</AlertDialogPrimitive.Cancel>
