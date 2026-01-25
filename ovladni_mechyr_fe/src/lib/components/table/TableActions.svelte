<script lang="ts">
  import type { Except } from 'type-fest';
  import { createEventDispatcher, type ComponentProps } from 'svelte';
  import { cn } from '$lib/utils';
  import * as m from '$paraglide/messages';
  import Button from '$lib/components/common/Button.svelte';
  import * as DropdownMenu from '$lib/components/ui/dropdown-menu';
  import Icon from '$lib/components/wrappers/Icon.svelte';
  import TrashIcon from '$lib/assets/icons/trash.svg?component';
  import ArrowRightIcon from '$lib/assets/icons/arrow-right.svg?component';
  import { EllipsisVerticalIcon } from 'lucide-svelte';

  // Required for when used by "createRender".
  type $$Events = {
    remove: CustomEvent<{ id: typeof id }>;
    buttonClick: CustomEvent<{ id: typeof id }>;
  };

  export let id: number;
  export let showArrow = false;
  export let showRemoval = false;
  export let showButton = false;
  export let buttonClasses: ComponentProps<Button>['class'] = undefined;
  export let buttonProps: Except<ComponentProps<Button>, 'class'> = {};
  export let buttonText: string = m.detail();
  export let showDropdown = false;
  export let dropdownButtonClasses: ComponentProps<Button>['class'] = undefined;
  export let dropdownButtonProps: Except<ComponentProps<Button>, 'class'> = {};

  const dispatch = createEventDispatcher<{
    remove: $$Events['remove']['detail'];
    buttonClick: $$Events['buttonClick']['detail'];
  }>();

  function handleRemove() {
    dispatch('remove', { id });
  }

  function handleButtonClick() {
    dispatch('buttonClick', { id });
  }
</script>

<!-- TODO: update -->
{#if showRemoval}
  <button
    class="inline-block aspect-square size-9 rounded-lg border-[1px] border-solid border-blue-300 align-middle transition-all hover:bg-blue-50 [&:not(:last-child)]:mr-2"
    title={m.remove()}
    on:click|stopPropagation={handleRemove}
  >
    <Icon height="18px" icon={TrashIcon} width="18px" />
    <div class="sr-only">{m.remove()}</div>
  </button>
{/if}

{#if showButton}
  <Button
    class={cn('-my-1.5 justify-self-end', buttonClasses)}
    size="sm"
    variant="outline"
    {...buttonProps}
    on:click={handleButtonClick}
  >
    {buttonText}
  </Button>
{/if}

{#if showDropdown}
  <DropdownMenu.Root preventScroll={false}>
    <DropdownMenu.Trigger asChild let:builder>
      <!-- svelte-ignore a11y-click-events-have-key-events -->
      <!-- svelte-ignore a11y-no-static-element-interactions -->
      <div
        class="-my-1.5"
        on:click|stopImmediatePropagation={() => {
          // Blocks table row click event from the whole cell.
        }}
      >
        <Button
          class={cn('justify-self-end', dropdownButtonClasses)}
          builders={[builder]}
          size="iconSm"
          variant="outline"
          {...dropdownButtonProps}
        >
          <EllipsisVerticalIcon />
          <span class="sr-only">{m.more()}</span>
        </Button>
      </div>
    </DropdownMenu.Trigger>
    <DropdownMenu.Content align="end">
      <slot />
    </DropdownMenu.Content>
  </DropdownMenu.Root>
{/if}

{#if showArrow}
  <ArrowRightIcon class="inline-block" />
{/if}
