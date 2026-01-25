<script lang="ts">
  import type { HTMLAttributes } from 'svelte/elements';
  import { cn } from '$lib/utils';
  import * as m from '$paraglide/messages';

  let className: HTMLAttributes<HTMLSpanElement>['class'] = undefined;
  export { className as class };
  export let value: number;
</script>

<span class={cn('text-sm font-semibold', className)}>
  {m.qualityOfLifeIndex()}:

  {value}
</span>
