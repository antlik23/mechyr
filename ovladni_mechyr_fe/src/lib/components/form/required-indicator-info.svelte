<script lang="ts">
  import type { HTMLAttributes } from 'svelte/elements';
  import { cn } from '$lib/utils';
  import * as m from '$paraglide/messages';
  import { RequiredIndicator } from './index';

  let className: HTMLAttributes<HTMLSpanElement>['class'] = undefined;
  export { className as class };
</script>

<span class={cn('text-sm text-muted-foreground', className)}>
  <RequiredIndicator />
  {m.requiredFields()}
</span>
