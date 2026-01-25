<script lang="ts">
  import type { StoryLayout } from 'histoire';
  import type { Hst } from '@histoire/plugin-svelte';
  import Button from '$lib/components/common/Button.svelte';
  import PlusIcon from '$lib/assets/icons/plus.svg?component';
  import type { ComponentProps } from 'svelte';

  type State = {
    title: string;
    props: ComponentProps<Button>;
  };

  export let Hst: Hst;

  const layout: StoryLayout = {
    type: 'grid',
    width: '20%',
  };

  const state: State[] = [
    { title: 'Default', props: { size: 'default' } },
    {
      title: 'Disabled default',
      props: { prependIcon: PlusIcon, appendIcon: PlusIcon, disabled: true },
    },
    { title: 'Prepend icon', props: { prependIcon: PlusIcon } },
    { title: 'Append icon', props: { appendIcon: PlusIcon } },
    { title: 'Prepend/Append icon', props: { prependIcon: PlusIcon, appendIcon: PlusIcon } },
    {
      title: 'Outline',
      props: { variant: 'outline' },
    },
    {
      title: 'Destructive',
      props: { variant: 'destructive' },
    },
    {
      title: 'Ghost',
      props: { variant: 'ghost' },
    },
    { title: 'Link', props: { variant: 'link' } },
    {
      title: 'onlyIcon',
      props: { onlyIcon: PlusIcon, variant: 'outline' },
    },
  ];

  let content = 'Button';
</script>

<svelte:component this={Hst.Story} {layout} title="Common/Button">
  <svelte:fragment slot="controls">
    <svelte:component this={Hst.Text} title="Content" bind:value={content} />
  </svelte:fragment>
  {#each state as { title, props }}
    <svelte:component this={Hst.Variant} {title}>
      <Button {...props}>{content}</Button>
    </svelte:component>
  {/each}
</svelte:component>
