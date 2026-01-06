<script lang="ts">
  import type { HTMLAttributes } from 'svelte/elements';
  import { cn } from '$lib/utils';
  import { tv, type VariantProps } from 'tailwind-variants';
  import { languageTag } from '$paraglide/runtime';

  import Icon from '$lib/components/wrappers/Icon.svelte';
  import CalendarIcon from '$lib/assets/icons/calendar.svg?component';

  const variants = tv({
    base: 'flex w-full items-center justify-between gap-2 text-base',
    variants: {
      variant: {
        positive: 'text-positive-dark',
        warning: 'text-warning-dark',
        negative: 'text-negative-dark',
        info: 'text-blue-300',
        tangerine: 'text-yellow-600',
        barkleyBlue: 'text-blue-dark',
      },
    },
  });

  let className: HTMLAttributes<HTMLDivElement>['class'] = undefined;
  export { className as class };
  export let variant: VariantProps<typeof variants>['variant'] = undefined;
  export let dateString: string;

  $: date = new Date(dateString);
</script>

<div class={cn(variants({ variant }), className)}>
  {date.toLocaleDateString(languageTag())}

  <Icon icon={CalendarIcon} />
</div>
