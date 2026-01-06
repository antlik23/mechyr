<script lang="ts">
  import * as DropdownMenu from '$lib/components/ui/dropdown-menu';
  import { cn } from '$lib/utils';
  import * as m from '$paraglide/messages';
  import { FileText, PencilIcon, Trash2 as TrashIcon } from 'lucide-svelte';
  import { createEventDispatcher, type ComponentProps } from 'svelte';
  import type { Except } from 'type-fest';
  import TableActions from './TableActions.svelte';

  // Required for when used by "createRender".
  type $$Events = {
    remove: CustomEvent<{ id: typeof id }>;
    detail: CustomEvent<{ id: typeof id }>;
    edit: CustomEvent<{ id: typeof id }>;
  };

  export let id: ComponentProps<TableActions>['id'];
  export let showEdit = true;
  export let editButtonClasses: ComponentProps<DropdownMenu.Item>['class'] = undefined;
  export let editButtonProps: Except<ComponentProps<DropdownMenu.Item>, 'class'> = {};
  export let showRemoval = true;
  export let removalButtonClasses: ComponentProps<DropdownMenu.Item>['class'] = undefined;
  export let removalButtonProps: Except<ComponentProps<DropdownMenu.Item>, 'class'> = {};
  export let userContext: 'doctor' | 'patient' | 'admin' | undefined = undefined;
  export let isCompleted: boolean | undefined = undefined;
  export let isAdmin = userContext === 'admin';
  export let showDetail = false;
  export let detailButtonProps: Except<ComponentProps<DropdownMenu.Item>, 'class'> = {};

  const dispatch = createEventDispatcher<{
    edit: $$Events['edit']['detail'];
    detail: $$Events['detail']['detail'];
    remove: $$Events['remove']['detail'];
  }>();

  function handleDetailClick() {
    dispatch('detail', { id });
  }

  function handleEditClick() {
    dispatch('edit', { id });
  }

  function handleRemoveClick() {
    dispatch('remove', { id });
  }
</script>

<TableActions {id} showDropdown={true}>
  <DropdownMenu.Group>
    <slot name="dropdownMenuItemsPrepend" />

    {#if showDetail}
      <DropdownMenu.Item
        class={'cursor-pointer gap-2 font-medium'}
        {...detailButtonProps}
        on:click={handleDetailClick}
      >
        <FileText class="size-4 shrink-0" />
        {m.detail()}
      </DropdownMenu.Item>
    {/if}

    {#if showEdit}
      <DropdownMenu.Item
        class={cn('cursor-pointer gap-2 font-medium', editButtonClasses)}
        {...editButtonProps}
        disabled={isCompleted && !isAdmin}
        on:click={handleEditClick}
      >
        <PencilIcon class="size-4 shrink-0" />
        {m.edit()}
      </DropdownMenu.Item>
    {/if}

    {#if showRemoval}
      <DropdownMenu.Item
        class={cn(
          'cursor-pointer gap-2 font-medium text-destructive data-[highlighted]:text-destructive',
          removalButtonClasses
        )}
        {...removalButtonProps}
        disabled={isCompleted && !isAdmin}
        on:click={handleRemoveClick}
      >
        <TrashIcon class="size-4 shrink-0" />
        {m.remove()}
      </DropdownMenu.Item>
    {/if}

    <slot name="dropdownMenuItemsAppend" />
  </DropdownMenu.Group>
</TableActions>
