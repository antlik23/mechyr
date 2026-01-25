<script lang="ts">
  import { Command as CommandPrimitive } from 'cmdk-sv';
  import { cn } from '$lib/utils.js';
  import LoaderCircleIcon from 'lucide-svelte/icons/loader-circle';

  type $$Props = CommandPrimitive.LoadingProps;
  let className: string | undefined | null = undefined;
  export { className as class };
</script>

<CommandPrimitive.Loading class={cn('py-6 text-center text-sm', className)} {...$$restProps}>
  <slot>
    <LoaderCircleIcon class="inline-block size-[1.125rem] animate-spin" />
  </slot>
</CommandPrimitive.Loading>
