<script lang="ts">
  import type { HTMLAttributes } from 'svelte/elements';
  import logo from '$lib/assets/icons/logo.svg?url';

  let className: HTMLAttributes<HTMLDivElement>['class'] = undefined;
  export { className as class };
  export let linkUrl: string | undefined = undefined;

  $: tag = linkUrl ? 'a' : 'div';
  $: attributes = tag === 'a' ? { href: linkUrl } : {};
</script>

<svelte:element this={tag} class={className} {...attributes}>
  <img alt="NSC" height="22" src={logo} width="94" />
</svelte:element>
