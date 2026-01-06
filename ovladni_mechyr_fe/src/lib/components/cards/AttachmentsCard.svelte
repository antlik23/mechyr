<script lang="ts">
  import { createEventDispatcher, type ComponentProps } from 'svelte';
  import { convertToLightboxItems } from '$lib/utils/lightbox';

  import Card from '$lib/components/wrappers/Card.svelte';
  import Lightbox from '$lib/components/lightbox/Lightbox.svelte';
  import Button from '$lib/components/common/Button.svelte';
  import Icon from '$lib/components/wrappers/Icon.svelte';

  import TrashIcon from '$lib/assets/icons/trash.svg?component';
  import { cn } from '$lib/utils';

  export let title: ComponentProps<Card>['title'] = undefined;
  export let attachments: Parameters<typeof convertToLightboxItems>['0'];
  export let allowRemoval = false;

  const dispatch = createEventDispatcher<{
    remove: {
      attachmentId: (typeof attachments)[number]['id'];
    };
  }>();

  function handleRemoveClick(attachmentId: (typeof attachments)[number]['id']) {
    dispatch('remove', { attachmentId });
  }
</script>

<Card {title}>
  <Lightbox mediaItems={convertToLightboxItems(attachments)}>
    <svelte:fragment slot="itemAppend" let:id>
      {#if allowRemoval}
        <Button
          class={cn(
            'absolute right-1 top-1 size-10 rounded-sm bg-yellow-600 p-0 text-yellow-600',
            // Hover.
            'hover:bg-yellow-600 hover:text-white',
            // Focus.
            'focus-visible:bg-yellow-600 focus-visible:text-white'
          )}
          variant="ghost"
          on:click={() => handleRemoveClick(id)}
        >
          <Icon icon={TrashIcon} />
        </Button>
      {/if}
    </svelte:fragment>
  </Lightbox>
</Card>
