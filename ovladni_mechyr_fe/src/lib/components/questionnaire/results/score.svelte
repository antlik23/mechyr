<script lang="ts">
  import type { HTMLAttributes } from 'svelte/elements';
  import { cn } from '$lib/utils';
  import * as m from '$paraglide/messages';
  import { titleVariants } from '$lib/components/common/Title.svelte';

  let className: HTMLAttributes<HTMLDivElement>['class'] = undefined;
  export { className as class };
  export let title = m.yourScore();
  export let points: number;
</script>

<div class={cn('flex items-center justify-between gap-2', className)}>
  <span class="text-lg/6 font-semibold">{title}</span>

  <span class={titleVariants({ level: 'h4' })}>
    {m.points({ pointsAmount: points })}
  </span>
</div>
