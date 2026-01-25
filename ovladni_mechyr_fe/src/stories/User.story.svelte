<script lang="ts">
  import type { StoryLayout } from 'histoire';
  import type { Hst } from '@histoire/plugin-svelte';
  export let Hst: Hst;

  import type { ComponentProps } from 'svelte';
  import User from '$lib/components/header/User.svelte';
  import AvatarImageUrl from '../stories/mock-assets/avatar-img.jpg';

  const layout: StoryLayout = {
    type: 'grid',
    width: '49%',
  };

  let state: Record<'default' | 'defaultNoImage' | 'link' | 'linkNoImage', ComponentProps<User>> = {
    default: { name: 'Daniel Křemešník', role: 'Skladník', pictureUrl: AvatarImageUrl },
    defaultNoImage: { name: 'Daniel Křemešník', role: 'Skladník' },
    link: {
      name: 'Daniel Křemešník',
      role: 'Skladník',
      pictureUrl: AvatarImageUrl,
      profilePageLink: '/',
    },
    linkNoImage: { name: 'Daniel Křemešník', role: 'Skladník', profilePageLink: '/' },
  };
</script>

<svelte:component this={Hst.Story} {layout} title="Header/User">
  <svelte:component this={Hst.Variant} title="Default">
    <svelte:fragment slot="controls">
      <svelte:component this={Hst.Text} title="Name" bind:value={state.default.name} />
      <svelte:component this={Hst.Text} title="Position" bind:value={state.default.role} />
    </svelte:fragment>

    <User {...state.default} />
  </svelte:component>

  <svelte:component this={Hst.Variant} title="Default no image">
    <svelte:fragment slot="controls">
      <svelte:component this={Hst.Text} title="Name" bind:value={state.defaultNoImage.name} />
      <svelte:component this={Hst.Text} title="Position" bind:value={state.defaultNoImage.role} />
    </svelte:fragment>

    <User {...state.defaultNoImage} />
  </svelte:component>

  <svelte:component this={Hst.Variant} title="Link">
    <svelte:fragment slot="controls">
      <svelte:component this={Hst.Text} title="Name" bind:value={state.link.name} />
      <svelte:component this={Hst.Text} title="Position" bind:value={state.link.role} />
    </svelte:fragment>

    <User {...state.link} />
  </svelte:component>

  <svelte:component this={Hst.Variant} title="Link no image">
    <svelte:fragment slot="controls">
      <svelte:component this={Hst.Text} title="Name" bind:value={state.linkNoImage.name} />
      <svelte:component this={Hst.Text} title="Position" bind:value={state.linkNoImage.role} />
    </svelte:fragment>

    <User {...state.linkNoImage} />
  </svelte:component>
</svelte:component>
