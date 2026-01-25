<script lang="ts">
  import type { ComponentProps } from 'svelte';
  import { cn } from '$lib/utils';
  import { LoaderCircleIcon } from 'lucide-svelte';

  let className: ComponentProps<LoaderCircleIcon>['class'] = undefined;
  export { className as class };
</script>

<LoaderCircleIcon class={cn('size-10 animate-spin text-blue-900', className)} />
