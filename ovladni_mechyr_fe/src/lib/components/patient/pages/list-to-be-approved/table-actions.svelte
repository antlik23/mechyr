<script lang="ts">
  import type { Patient } from './types';
  import { createEventDispatcher } from 'svelte';
  import * as m from '$paraglide/messages';
  import TableActionsDropdown from '$lib/components/table/TableActionsDropdown.svelte';
  import * as DropdownMenu from '$lib/components/ui/dropdown-menu';
  import { UserCheckIcon, UserXIcon } from 'lucide-svelte';

  type $$Events = {
    accept: CustomEvent<{ patient: Patient }>;
    reject: CustomEvent<{ patient: Patient }>;
  };

  export let patient: Patient;

  const dispatch = createEventDispatcher<{
    accept: $$Events['accept']['detail'];
    reject: $$Events['reject']['detail'];
  }>();

  function handleAcceptClick() {
    dispatch('accept', { patient });
  }

  function handleRejectClick() {
    dispatch('reject', { patient });
  }
</script>

<TableActionsDropdown id={patient.id} showEdit={false} showRemoval={false}>
  <svelte:fragment slot="dropdownMenuItemsPrepend">
    <DropdownMenu.Item class="cursor-pointer gap-2 font-medium" on:click={handleAcceptClick}>
      <UserCheckIcon class="size-4 shrink-0" />
      {m.accept()}
    </DropdownMenu.Item>

    <DropdownMenu.Item
      class="cursor-pointer gap-2 font-medium text-destructive data-[highlighted]:text-destructive"
      on:click={handleRejectClick}
    >
      <UserXIcon class="size-4 shrink-0" />
      {m.reject()}
    </DropdownMenu.Item>
  </svelte:fragment>
</TableActionsDropdown>
