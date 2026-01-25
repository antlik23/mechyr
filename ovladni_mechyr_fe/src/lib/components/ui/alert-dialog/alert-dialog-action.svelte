<script lang="ts">
  import { AlertDialog as AlertDialogPrimitive } from 'bits-ui';
  import Button from '$lib/components/common/Button.svelte';

  type $$Props = AlertDialogPrimitive.ActionProps;

  type $$Events = AlertDialogPrimitive.ActionEvents;

  let className: $$Props['class'] = undefined;
  export { className as class };
</script>

<AlertDialogPrimitive.Action asChild {...$$restProps} let:builder>
  <Button class={className} builders={[builder]} on:click on:keydown>
    <slot />
  </Button>
</AlertDialogPrimitive.Action>
