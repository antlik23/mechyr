<script lang="ts">
  import type { StoryLayout } from 'histoire';
  import type { Hst } from '@histoire/plugin-svelte';
  export let Hst: Hst;

  import type { ComponentProps } from 'svelte';
  import Avatar from '$lib/components/user/Avatar.svelte';
  import AvatarImageUrl from '../stories/mock-assets/avatar-img.jpg';

  const layout: StoryLayout = {
    type: 'grid',
    width: '33%',
  };

  let state: Record<'default' | 'noImage', ComponentProps<Avatar>> = {
    default: { name: 'Daniel Křemešník', pictureUrl: AvatarImageUrl },
    noImage: { name: 'Daniel Křemešník' },
  };
</script>

<svelte:component this={Hst.Story} {layout} title="User/Avatar">
  <svelte:component this={Hst.Variant} title="Default">
    <div class="w-8"><Avatar {...state.default} /></div>
  </svelte:component>

  <svelte:component this={Hst.Variant} title="No image">
    <svelte:fragment slot="controls">
      <svelte:component this={Hst.Text} title="Name" bind:value={state.noImage.name} />
    </svelte:fragment>

    <div class="w-8"><Avatar {...state.noImage} /></div>
  </svelte:component>
</svelte:component>
