<script lang="ts">
  import * as Popover from '$lib/components/ui/popover';
  import Button from '$lib/components/ui/button/button.svelte';
  import Icon from '$lib/components/wrappers/Icon.svelte';
  import { cn } from '$lib/utils.js';
  import { type ComponentProps } from 'svelte';
  import * as m from '$paraglide/messages';

  type $$Props = ComponentProps<Button> & {
    prependIcon?: ComponentProps<Icon>['icon'];
    prependIconProps?: Partial<ComponentProps<Icon>>;
    appendIcon?: ComponentProps<Icon>['icon'];
    appendIconProps?: Partial<ComponentProps<Icon>>;
    onlyIcon?: ComponentProps<Icon>['icon'];
    open?: boolean;
    'data-testid'?: string;
  };

  let className: $$Props['class'] = undefined;
  export { className as class };
  export let variant: $$Props['variant'] = 'default';
  export let size: $$Props['size'] = 'default';
  export let builders: $$Props['builders'] = [];
  export let type: $$Props['type'] = 'button';
  export let open: $$Props['open'] = false;
  export let appendIcon: $$Props['appendIcon'] = undefined;
  export let appendIconProps: $$Props['appendIconProps'] = undefined;
  export let prependIcon: $$Props['prependIcon'] = undefined;
  export let prependIconProps: $$Props['prependIconProps'] = undefined;
  export let onlyIcon: $$Props['onlyIcon'] = undefined;
</script>

{#if onlyIcon}
  <Popover.Root bind:open>
    <Popover.Trigger asChild let:builder>
      <Button
        class={className}
        aria-label={m.viewMore()}
        builders={Array.isArray(builders) && builders.length > 0 ? builders : [builder]}
        {size}
        {type}
        {variant}
        {...$$restProps}
        on:click
        on:keydown
      >
        <Icon icon={onlyIcon} />
      </Button>
    </Popover.Trigger>
    <Popover.Content class="rouded-lg border-none bg-white shadow-100" sideOffset={4}>
      <slot name="popoverContent" />
    </Popover.Content>
  </Popover.Root>
{:else}
  <Button
    class={cn('flex gap-2', className)}
    {builders}
    {size}
    {type}
    {variant}
    {...$$restProps}
    on:click
    on:keydown
  >
    {#if prependIcon}
      <Icon icon={prependIcon} {...prependIconProps} />
    {/if}
    <slot />
    {#if appendIcon}
      <Icon icon={appendIcon} {...appendIconProps} />
    {/if}
  </Button>
{/if}
