<script lang="ts">
  import type { ComponentProps } from 'svelte';
  import { cn } from '$lib/utils';
  import Avatar from '$lib/components/user/Avatar.svelte';

  export let name: ComponentProps<Avatar>['name'];
  export let role: string;
  export let pictureUrl: ComponentProps<Avatar>['pictureUrl'] = undefined;
  export let profilePageLink: string | undefined = undefined;

  $: tag = profilePageLink ? 'a' : 'div';
  $: attributes = tag === 'a' ? { href: profilePageLink } : {};
</script>

<svelte:element
  this={tag}
  class={cn(
    'flex items-center gap-2',
    // Anchor tag.
    '[&[href]]:rounded-lg [&[href]]:p-1.5 [&[href]]:transition-colors [&[href]]:hover:bg-gray-100'
  )}
  {...attributes}
>
  <div class="size-8 shrink-0">
    <Avatar {name} {pictureUrl} />
  </div>

  <div class="flex grow flex-col">
    <span class="text-sm">{name}</span>
    <span class="text-3xs">{role}</span>
  </div>
</svelte:element>
