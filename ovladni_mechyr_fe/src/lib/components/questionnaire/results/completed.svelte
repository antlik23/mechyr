<script lang="ts">
  import type { HTMLAttributes } from 'svelte/elements';
  import { cn } from '$lib/utils';
  import { languageTag } from '$paraglide/runtime';
  import * as m from '$paraglide/messages';

  let className: HTMLAttributes<HTMLSpanElement>['class'] = undefined;
  export { className as class };
  export let completedDate: string;
</script>

<span class={cn('text-sm font-medium text-muted-foreground', className)}>
  {m.completed()}:

  {new Date(completedDate).toLocaleString(languageTag(), {
    dateStyle: 'medium',
    timeStyle: 'short',
  })}
</span>
