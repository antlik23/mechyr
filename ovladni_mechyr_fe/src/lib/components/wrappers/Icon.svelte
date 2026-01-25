<script lang="ts">
  import type { ComponentType } from 'svelte';
  import type { HTMLAttributes, SVGAttributes } from 'svelte/elements';
  import type { Icon, IconProps } from 'lucide-svelte';
  import type { SvgIcon } from '$lib/types/SvgIcon';

  import { cn } from '$lib/utils';

  type $$Props = SVGAttributes<SVGSVGElement> & {
    class?: HTMLAttributes<HTMLDivElement>['class'];
    icon: SvgIcon | ComponentType<Icon>;
    // Lucide icon only props:
    size?: IconProps['size'];
    strokeWidth?: IconProps['strokeWidth'];
    color?: IconProps['color'];
    absoluteStrokeWidth?: IconProps['absoluteStrokeWidth'];
    testId?: string;
  };

  let className: $$Props['class'] = undefined;
  export let icon: $$Props['icon'];
  export { className as class };
  export let testId: $$Props['testId'] = undefined;
</script>

<div
  class={cn('inline-grid aspect-square w-6 flex-shrink-0 place-items-center', className)}
  data-testid={testId}
>
  <svelte:component this={icon} {...$$restProps} />
</div>
