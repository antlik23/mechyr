<script lang="ts">
  import Input from '$lib/components/forms/fields/Input.svelte';
  import type { StoryLayout } from 'histoire';
  import type { Hst } from '@histoire/plugin-svelte';
  import type { ComponentProps } from 'svelte';
  import MagnifierIcon from '$lib/assets/icons/magnifier.svg';

  export let Hst: Hst;

  const layout: StoryLayout = {
    type: 'grid',
    width: '50%',
  };

  let state: Record<
    'default' | 'prepend' | 'append' | 'prependIcon' | 'appendIcon',
    ComponentProps<Input>
  > = {
    default: {},
    prepend: {
      prepend: 'prepend',
    },
    append: {
      append: 'append',
    },
    prependIcon: {
      prepend: MagnifierIcon,
    },
    appendIcon: {
      append: MagnifierIcon,
    },
  };
</script>

<svelte:component this={Hst.Story} {layout} title="Form fields/Input">
  <svelte:component this={Hst.Variant} title="default">
    <Input />
  </svelte:component>
  <svelte:component this={Hst.Variant} title="prepend">
    <Input {...state.prepend} />
  </svelte:component>
  <svelte:component this={Hst.Variant} title="append">
    <Input {...state.append} />
  </svelte:component>
  <svelte:component this={Hst.Variant} title="prependIcon">
    <Input {...state.prependIcon} />
  </svelte:component>
  <svelte:component this={Hst.Variant} title="appendIcon">
    <Input {...state.appendIcon} />
  </svelte:component>
</svelte:component>
