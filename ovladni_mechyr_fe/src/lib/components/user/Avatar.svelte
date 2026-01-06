<script lang="ts">
  import type { ComponentProps } from 'svelte';
  import * as Avatar from '$lib/components/ui/avatar/index.js';

  export let fallbackClasses: ComponentProps<Avatar.Fallback>['class'] = undefined;
  export let name: string;
  export let pictureUrl: ComponentProps<Avatar.Image>['src'] = undefined;

  $: initials = `${name
    .split(/\s/g)
    .map((name) => name[0])
    .join('')}`;
</script>

<Avatar.Root class="size-full">
  <Avatar.Image alt={name} src={pictureUrl} />
  <Avatar.Fallback class={fallbackClasses}>{initials}</Avatar.Fallback>
</Avatar.Root>
